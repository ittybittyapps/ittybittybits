//
//  NSNumber+IBACompare.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 13/05/11.
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

#import "NSNumber+IBACompare.h"


@implementation NSNumber (IBACompare)

- (BOOL)ibaLessThanInt:(int)n
{
    return [self compare:[NSNumber numberWithInt:n]] == NSOrderedAscending;
}

- (BOOL)ibaGreaterThanInt:(int)n
{
    return [self compare:[NSNumber numberWithInt:n]] == NSOrderedDescending;
}

- (BOOL)ibaEqualToInt:(int)n
{
    return [self compare:[NSNumber numberWithInt:n]] == NSOrderedSame;
}

- (BOOL)ibaLessThanFloat:(float)n
{
    return [self compare:[NSNumber numberWithFloat:n]] == NSOrderedAscending;
}

- (BOOL)ibaGreaterThanFloat:(float)n
{
    return [self compare:[NSNumber numberWithFloat:n]] == NSOrderedDescending;
}

- (BOOL)ibaEqualToFloat:(float)n
{
    return [self compare:[NSNumber numberWithFloat:n]] == NSOrderedSame;
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is less than another given number.
 \param     other The other number to compare to the receiver.
 \return    YES if the receiver is less than other, otherwise NO.
 */
- (BOOL)ibaIsLessThan:(NSNumber *)other 
{
    return [self compare:other] == NSOrderedAscending;
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is less than or equal to another given number.
 \param     other The other number to compare to the receiver.
 \return YES if the receiver is less than or equal to other, otherwise NO.
 */
- (BOOL)ibaIsLessThanOrEqualTo:(NSNumber *)other 
{
    return [self compare:other] == NSOrderedSame || [self compare:other] == NSOrderedAscending;
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is greater than another given number.
 \param     other The other number to compare to the receiver.
 \return    YES if the receiver is greater than other, otherwise NO.
 */
- (BOOL)ibaIsGreaterThan:(NSNumber *)other 
{
    return [self compare:other] == NSOrderedDescending;
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is greater than or equal to another given number.
 \param     other The other number to compare to the receiver.
 \return    YES if the receiver is greater than or equal to other, otherwise NO.
 */
- (BOOL)ibaIsGreaterThanOrEqualTo:(NSNumber *)other 
{
    return [self compare:other] == NSOrderedSame || [self compare:other] == NSOrderedDescending;
}

@end
