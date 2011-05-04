//
//  IBADebugLog.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 3/05/11.
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

#import "IBALogger.h"
#import "IBADebug.h"
#import "IBACommon.h"
#import "IBASynthesizeSingleton.h"

#import <stdarg.h>

@implementation IBALogger

IBA_SYNTHESIZE_SINGLETON_FOR_CLASS(IBALogger, sharedLogger)

@synthesize facility;
@synthesize name;

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init
{
    return [self initWithName:[[NSBundle mainBundle] bundleIdentifier]
                     facility:@"com.ittybittyapps.debug"];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithFacility:(NSString*) aFacility
{
    return [self initWithName:[[NSBundle mainBundle] bundleIdentifier] 
                     facility:aFacility];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithName:(NSString*)aName facility:(NSString*) aFacility
{
    if ((self = [super init]))
    {
        additionalFiles = [NSMutableDictionary new];
        logQueue = dispatch_queue_create("com.ittybittyapps.logger", NULL);
        dispatch_set_target_queue(logQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
        
        name = [aName retain];
        self.facility = aFacility;
    
        uint32_t opts = ASL_OPT_STDERR   | // adds stderr as an output file descriptor
                        ASL_OPT_NO_DELAY | // connects to the server immediately
                        ASL_OPT_NO_REMOTE; // disables remote-control filter adjustment
        
        aslClient = asl_open([aName UTF8String], [aFacility UTF8String], opts);
        aslMsg = asl_new(ASL_TYPE_MSG);
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
    dispatch_sync(logQueue, ^{        
        asl_free(aslMsg);
        asl_close(aslClient);
        
        IBA_RELEASE(name);
        IBA_RELEASE(facility);
        IBA_RELEASE(additionalFiles);
    });
    
    dispatch_release(logQueue);
    
    [super dealloc];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFacility:(NSString *)newFacility
{
    dispatch_sync(logQueue, ^{
        if (facility != newFacility)
        {
            [facility release];
            facility = [newFacility retain];
            asl_set(aslMsg, ASL_KEY_FACILITY, [facility UTF8String]);
        }
    });
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addLogFile:(NSString*)path
{
    dispatch_sync(logQueue, ^{
        if ([additionalFiles objectForKey:path] == nil)
        {
            NSFileHandle* handle = [NSFileHandle fileHandleForWritingAtPath:path];
            if (handle != nil)
            {
                [additionalFiles setObject:handle forKey:path];
            
                asl_add_log_file(aslClient, [handle fileDescriptor]);
            }
        }
    });
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) removeLogFile:(NSString*)path
{
    dispatch_sync(logQueue, ^{
        
        NSFileHandle* handle = [additionalFiles objectForKey:path];
        if (handle != nil)
        {
            asl_remove_log_file(aslClient, [handle fileDescriptor]);
            [additionalFiles removeObjectForKey:path];
        }
    });
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) log:(NSString*)format level:(NSInteger)level, ...
{
    va_list args;
    va_start(args, level);
    [self log:format level:level args:args];
    va_end(args);
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) log:(NSString*)format level:(NSInteger)level args:(va_list)args
{
    NSString* msg = [[NSString alloc] initWithFormat:format arguments:args];
    
    dispatch_async(logQueue, ^ {
        if (asl_log(aslClient, aslMsg, level, "%s", [msg UTF8String]))
        {
            // Log failed, try using NSLog to log message instead.
            NSLog(@"%@", msg);
        }
    });
    
    [msg release];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) logDebug:(NSString*)format, ...
{
    va_list args;
    va_start(args, format);
    [self logDebug:format args:args];
    va_end(args);
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) logDebug:(NSString*)format args:(va_list)args
{
    [self log:format level:ASL_LEVEL_DEBUG args:args];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) logInfo:(NSString*)format, ...
{
    va_list args;
    va_start(args, format);
    [self logInfo:format args:args];
    va_end(args);
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) logInfo:(NSString*)format args:(va_list)args
{
    [self log:format level:ASL_LEVEL_INFO args:args];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) logNotice:(NSString*)format, ...
{
    va_list args;
    va_start(args, format);
    [self logNotice:format args:args];
    va_end(args);
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) logNotice:(NSString*)format args:(va_list)args
{
    [self log:format level:ASL_LEVEL_NOTICE args:args];
}

@end
