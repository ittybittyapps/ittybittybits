//
//  NSHTTPURLResponse+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 3/10/11.
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

#import "NSHTTPURLResponse+IBAExtensions.h"
#import "NSDate+IBAExtensions.h"

@implementation NSHTTPURLResponse (IBAExtensions)

- (NSString *)ibaDebugDescription
{
    return [NSString stringWithFormat:@"%d: %@, Expected Content Length: %lld, Headers: %@", self.statusCode, [[self class] localizedStringForStatusCode:self.statusCode], self.expectedContentLength, self.allHeaderFields];
}

/*!
 \brief     Returns the date header from the HTTP response (if the header exists & is parseable).
 \return    The response header date/time if available; otherwise nil.
 */
- (NSDate *)ibaDateHeader
{
    NSString *dateString = [[self allHeaderFields] objectForKey:@"Date"];
    if (dateString)
    {
        return [NSDate ibaDateFromRFC822String:dateString];
    }
    
    return nil;
}

@end
