//
//  UIApplication+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 19/08/11.
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

#import "UIApplication+IBAExtensions.h"
#import "objc/runtime.h"

#import "IBALogger.h"
#import "NSNumber+IBAExtensions.h"

static int kNetworkActivityIndicatorKey = 0;

@implementation UIApplication (IBAExtensions)

/*!
 \brief     Begin application network activitity.
 \details   Turns on the application network activity indicator.  We count each invocation of this method and will only turn the indicator off when that count returns back to zero.
 \note      All invocations of this method should be paired with an equal number of UIApplication#ibaEndNetworkActivity.
 \sa        UIApplication#ibaEndNetworkActivity
 */
-  (void)ibaBeginNetworkActivity
{    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *count = objc_getAssociatedObject(self, &kNetworkActivityIndicatorKey);
        if (count == nil)
        {
            count = IBAIntToNumber(0);   
        }
        
        count = IBAIntToNumber([count intValue] + 1);
        objc_setAssociatedObject(self, &kNetworkActivityIndicatorKey, count, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        NSLog(@"Network activity began count: %@", count);
        self.networkActivityIndicatorVisible = YES;
    });
}

/*!
 \brief     End application network activitity.
 \note      All invocations of this method should be paired with an equal number of UIApplication#ibaBeginNetworkActivity.
 \details   Turns off the application network activity indicator when the activity count returns to zero.  
 \sa        UIApplication#ibaBeginNetworkActivity
 */
- (void)ibaEndNetworkActivity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *count = objc_getAssociatedObject(self, &kNetworkActivityIndicatorKey);
        if (count == nil)
        {
            count = IBAIntToNumber(0);        
        }
        
        count = IBAIntToNumber(MAX(0, [count intValue] - 1));
        
        objc_setAssociatedObject(self, &kNetworkActivityIndicatorKey, count, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        NSLog(@"Network activity began count: %@ (networkActivityIndicatorVisible == %@)", count, [count boolValue] ? @"YES" : @"NO");
        self.networkActivityIndicatorVisible = [count boolValue];
    });
}

@end
