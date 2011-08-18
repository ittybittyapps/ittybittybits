//
//  NSDate+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 1/07/11.
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

#import "NSDate+IBAExtensions.h"


@implementation NSDate (IBAExtensions)

/*!
 \brief Return the number of days from the receiver to the specified \a date.
 */
- (NSInteger)ibaNumberOfDaysUntil:(NSDate *)date 
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit 
                                                        fromDate:self 
                                                          toDate:date
                                                         options:0];
    [gregorianCalendar release];
    
    return [components day];
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is earlier than another given date.
 \param     other The other date to compare to the receiver.
 \return    YES if the receiver is earlier than other, otherwise NO.
 */
- (BOOL)ibaIsEarlierThan:(NSDate *)other
{
    return [self compare:other] == NSOrderedAscending;
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is earlier than or equal to another given date.
 \param     other The other date to compare to the receiver.
 \return    YES if the receiver is earlier than or equal to other, otherwise NO.
 */
- (BOOL)ibaIsEarlierThanOrEqualTo:(NSDate *)other
{
    NSComparisonResult result = [self compare:other];
    return result == NSOrderedAscending || result == NSOrderedSame;
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is later than another given date.
 \param     other The other date to compare to the receiver.
 \return    YES if the receiver is later than other, otherwise NO.
 */
- (BOOL)ibaIsLaterThan:(NSDate *)other
{
    return [self compare:other] == NSOrderedDescending;
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is later than or equal to another given date.
 \param     other The other date to compare to the receiver.
 \return    YES if the receiver is later than or equal to other, otherwise NO.
 */
- (BOOL)ibaIsLaterThanOrEqualTo:(NSDate *)other
{
    NSComparisonResult result = [self compare:other];
    return result == NSOrderedDescending || result == NSOrderedSame;
}

@end
