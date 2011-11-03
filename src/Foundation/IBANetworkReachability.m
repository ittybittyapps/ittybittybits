//
//  IBAReachability.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 12/08/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

/*
 
 File: Reachability.m
 Abstract: Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 
 Version: 2.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>

#import "IBANetworkReachability.h"
#import "IBALogger.h"

typedef SCNetworkReachabilityRef (^IBANetworkReachabilityRefFactory)();

#pragma mark - Private Class Extension

@interface IBANetworkReachability () 
{
    BOOL localWiFiRef;
    SCNetworkReachabilityRef reachabilityRef;
}

@property (nonatomic, copy) IBANetworkReachabilityChangeHandler changeHandler;

+ (IBANetworkReachability *)reachabilityWithReachabilityRefFactory:(IBANetworkReachabilityRefFactory)factory 
                                                      localWiFiRef:(BOOL)isWifi 
                                                     changeHandler:(IBANetworkReachabilityChangeHandler)changeHandler;

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)ref 
                 localWiFiRef:(BOOL)isWifi 
                changeHandler:(IBANetworkReachabilityChangeHandler)changeHandler;

@end

/*!
 \brief     The notification that is posted when the network reachability changes.
 */
NSString * const IBANetworkReachabilityChangedNotification = @"IBANetworkReachabilityChangedNotification";

#define kShouldPrintReachabilityFlags 1

static void PrintReachabilityFlags(SCNetworkReachabilityFlags IBA_UNUSED flags, const char* IBA_UNUSED comment)
{
#if kShouldPrintReachabilityFlags
    IBALogDebug(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
          (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
          
          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
          comment
          );
#endif
}

static IBANetworkReachabilityStatus LocalWiFiStatusForFlags(SCNetworkReachabilityFlags flags)
{
    PrintReachabilityFlags(flags, "LocalWiFiStatusForFlags");
    
    if(IBA_HAS_FLAG(flags, kSCNetworkReachabilityFlagsReachable) && 
       IBA_HAS_FLAG(flags, kSCNetworkReachabilityFlagsIsDirect))
    {
        return IBANetworkReachabilityStatusReachableViaWiFi;
    }
    
    return IBANetworkReachabilityStatusNotReachable;
}

static IBANetworkReachabilityStatus NetworkStatusForFlags(SCNetworkReachabilityFlags flags)
{
    PrintReachabilityFlags(flags, "NetworkStatusForFlags");
    if (IBA_HAS_FLAG(flags, kSCNetworkReachabilityFlagsReachable) == NO)
    {
        // if target host is not reachable
        return IBANetworkReachabilityStatusNotReachable;
    }
    
    IBANetworkReachabilityStatus retVal = IBANetworkReachabilityStatusNotReachable;
    
    if (IBA_HAS_FLAG(flags, kSCNetworkReachabilityFlagsConnectionRequired) == NO)
    {
        // if target host is reachable and no connection is required
        //  then we'll assume (for now) that your on Wi-Fi
        retVal = IBANetworkReachabilityStatusReachableViaWiFi;
    }
    
    if (IBA_HAS_FLAG(flags, kSCNetworkReachabilityFlagsConnectionOnDemand) ||
        IBA_HAS_FLAG(flags, kSCNetworkReachabilityFlagsConnectionOnTraffic))
    {
        // ... and the connection is on-demand (or on-traffic) if the
        //     calling application is using the CFSocketStream or higher APIs
        
        if (IBA_HAS_FLAG(flags, kSCNetworkReachabilityFlagsInterventionRequired) == NO)
        {
            // ... and no [user] intervention is needed
            retVal = IBANetworkReachabilityStatusReachableViaWiFi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        // ... but WWAN connections are OK if the calling application
        //     is using the CFNetwork (CFSocketStream?) APIs.
        retVal = IBANetworkReachabilityStatusReachableViaWWAN;
    }
    
    return retVal;
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
    NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
    NSCAssert([(NSObject*) info isKindOfClass: [IBANetworkReachability class]], @"info was wrong class in ReachabilityCallback");
    
    // We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
    // in case someone uses the Reachablity object in a different thread.
    NSAutoreleasePool* myPool = [[NSAutoreleasePool alloc] init];
    
    IBANetworkReachability* reachability = (IBANetworkReachability*)info;
    if (reachability.changeHandler)
    {
        reachability.changeHandler(reachability);
    }
    
    // Post a notification to notify the client that the network reachability changed.
    [[NSNotificationCenter defaultCenter] postNotificationName:IBANetworkReachabilityChangedNotification 
                                                        object:reachability];
    
    [myPool release];
}

@implementation IBANetworkReachability

IBA_SYNTHESIZE(changeHandler);

+ (IBANetworkReachability *)reachabilityWithReachabilityRefFactory:(SCNetworkReachabilityRef (^)())factory 
                                                      localWiFiRef:(BOOL)isWifi 
                                                     changeHandler:(IBANetworkReachabilityChangeHandler)changeHandler
{
    IBANetworkReachability *instance = nil;
    SCNetworkReachabilityRef reachability = factory();
    if (reachability != NULL)
    {
        instance = [[[self alloc] initWithReachabilityRef:reachability localWiFiRef:isWifi changeHandler:changeHandler] autorelease];
        CFRelease(reachability);     
    }
    
    return instance;
}

/*!
 \brief     Checks the reachability of a particular host name. 
 \param     hostName     The domain name of the host to monitor.
 */
+ (IBANetworkReachability *)reachabilityForHostName:(NSString *)hostName
{
    return [self reachabilityForHostName:hostName withChangeHandler:nil];
}

/*!
 \brief     Checks the reachability of a particular host name. 
 \param     hostName     The domain name of the host to monitor.
 \param     handler      The block to invoke when the reachability changes.
 */
+ (IBANetworkReachability *)reachabilityForHostName:(NSString *)hostName 
                                  withChangeHandler:(IBANetworkReachabilityChangeHandler)handler
{
    return [self reachabilityWithReachabilityRefFactory:^{ return SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, 
                                                                                                      [hostName UTF8String]); }
                                           localWiFiRef:NO
                                          changeHandler:handler];    
}

/*!
 \brief     Checks the reachability of a particular IP address. 
 */
+ (IBANetworkReachability *)reachabilityForAddress:(const struct sockaddr_in *)hostAddress 
{
    return [self reachabilityForAddress:hostAddress withChangeHandler:nil];
}

/*!
 \brief     Checks the reachability of a particular IP address. 
 \param     hostAddress     The address of the host to monitor.
 \param     handler         The block to invoke when the reachability changes.
 */
+ (IBANetworkReachability *)reachabilityForAddress:(const struct sockaddr_in *)hostAddress 
                                 withChangeHandler:(IBANetworkReachabilityChangeHandler)handler
{
    return [self reachabilityWithReachabilityRefFactory:^{ return SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, 
                                                                                                         (const struct sockaddr *)hostAddress); }
                                           localWiFiRef:NO
                                          changeHandler:handler];    
}

/*!
 \brief     Checks whether the default route is available.  
 \details   Should be used by applications that do not connect to a particular host.
 */
+ (IBANetworkReachability *)reachabilityForInternetConnection
{
    return [self reachabilityForInternetConnectionWithChangeHandler:nil];
}

/*!
 \brief     Checks whether the default route is available.  
 \details   Should be used by applications that do not connect to a particular host.
 \param     handler         The block to invoke when the reachability changes.
 */
+ (IBANetworkReachability *)reachabilityForInternetConnectionWithChangeHandler:(IBANetworkReachabilityChangeHandler)handler
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithReachabilityRefFactory:^{ return SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, 
                                                                                                         (const struct sockaddr *)&zeroAddress); }
                                           localWiFiRef:NO
                                          changeHandler:handler];

}

/*!
 \brief     Checks whether a local wifi connection is available.
 \param     handler         The block to invoke when the reachability changes.
 */
+ (IBANetworkReachability *)reachabilityForLocalWiFi
{
    return [self reachabilityForLocalWiFiWithChangeHandler:nil];
}

/*!
 \brief     Checks whether a local wifi connection is available.
 \param     handler         The block to invoke when the reachability changes.
 */
+ (IBANetworkReachability *)reachabilityForLocalWiFiWithChangeHandler:(IBANetworkReachabilityChangeHandler)handler
{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    
    return [self reachabilityWithReachabilityRefFactory:^{ return SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, 
                                                                                                         (const struct sockaddr *)&localWifiAddress); }
                                           localWiFiRef:YES
                                          changeHandler:handler];
}

#pragma mark - Initializers & Dealloc

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)ref 
                 localWiFiRef:(BOOL)isWifi 
                changeHandler:(IBANetworkReachabilityChangeHandler)changeHandlerBlock
{
    if ((self = [super init]))
    {
        reachabilityRef = CFRetain(ref);
        localWiFiRef = isWifi;
        
        self.changeHandler = changeHandlerBlock;
    }
    
    return self;
}

/*
 Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    [self stopMonitoringReachability];
    
    IBA_CFRELEASE(reachabilityRef);
    IBA_RELEASE_PROPERTY(changeHandler);
    
    [super dealloc];
}

#pragma mark - Public Instance Methods

/*!
 \brief     Start listening for reachability notifications on the current run loop.
 */
- (BOOL)monitorReachabilityOnCurrentRunLoop
{
    BOOL retVal = NO;
    SCNetworkReachabilityContext context = { 0, self, NULL, NULL, NULL };
    if (SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context))
    {
        if (SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
        {
            retVal = YES;
        }
    }
    
    return retVal;
}

/*!
 \brief     Stop listening for reachability notifications.
 */
- (void)stopMonitoringReachability
{
    if (reachabilityRef != NULL)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

- (BOOL)connectionRequired
{
    NSAssert(reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }
    
    return NO;
}

- (IBANetworkReachabilityStatus)currentReachabilityStatus
{
    NSAssert(reachabilityRef != NULL, @"currentNetworkStatus called with NULL reachabilityRef");

    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
        return localWiFiRef ? LocalWiFiStatusForFlags(flags) : NetworkStatusForFlags(flags);
    }
    
    return IBANetworkReachabilityStatusNotReachable;
}

@end
