//
//  NSIndexPath+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 14/09/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
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

#import "NSIndexPath+IBAExtensions.h"
#import "IBACommon.h"

@implementation NSIndexPath (IBAExtension)

/*!
 \brief     Returns a value indicating whether the NSIndexPath's row property value is within the index bounds of the specified \a array.
 \return    YES if the NSIndexPath's row property value is within the index bounds of the specified \a array; otherwise NO.
 */
- (BOOL)ibaRowIsWithinBoundsOfArray:(NSArray *)array
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_4_3
    return (self.row >= 0 && IBANSIntegerLessThanNSUInteger(self.row, [array count]));
#else
    return (self.row < [array count]);
#endif
}

@end
