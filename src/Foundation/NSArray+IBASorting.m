//
//  NSArray+IBASorting.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 18/05/11.
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


#import "NSArray+IBASorting.h"

@implementation NSArray (IBASorting)

/*!
 \brief     Returns a sorted version of the receiving array.
 \details   The returned array is sorted in assending numerical order.  Assumes all members of the array are NSNumber instances.
 */
- (NSArray *)ibaSortedArrayOfNumbers
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(NSNumber *a, NSNumber *b) {
        return [a compare:b];
    }];
}

/*!
 \brief     Returns a localized sorted version of the receiving array.
 \details   Assumes all members of the array are NSString instances.  The values of the array are sorted in ascending order.
 */
- (NSArray *)ibaSortedArrayOfLocalizedStrings
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        return [a localizedCompare:b];
    }];
}

/*!
 \brief     Returns an array in the reverse order to the recieving array.
 */
- (NSArray *)ibaReversedArray
{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) 
    {
        [temp addObject:element];
    }
    
    NSArray *result = [NSArray arrayWithArray:temp];
    [temp release];
    
    return result;
}

@end
