//
//  NSArray+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 24/06/11.
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


#import "NSArray+IBAExtensions.h"

@implementation NSArray (IBAExtensions)

/*!
 \brief     Returns the object in the array with the lowest index value.
 \return    The object in the array with the lowest index value.
 */
- (id)ibaFirstObject
{
    if ([self count] > 0)
    {
        return [self objectAtIndex:0];
    }
    
    return nil;
}

/*!
 \brief     Returns a value indicating whether the array is empty.
 \return    A value indicating whether the array is empty.
 */
- (BOOL)ibaIsEmpty
{
    return [self count] == 0;
}

@end
