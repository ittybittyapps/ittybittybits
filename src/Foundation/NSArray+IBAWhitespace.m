//
//  NSArray+IBAWhitespace.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 10/05/11.
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


#import "NSArray+IBAWhitespace.h"
#import "IBACommon.h"

@implementation NSArray (IBAWhitespace)

/*!
 \brief     Constructs and returns an NSString object that is the result of interposing a given separator between the non-empty elements of the array.
 \param     separator
            The string to interpose between the elements of the array.
 \return    An NSString object that is the result of interposing separator between the elements of the array. If the array has no elements, returns an NSString object representing an empty string.
 
 \note   Each element in the array must handle description.
 */
- (NSString *)ibaNonEmptyComponentsJoinedByString:(NSString *)string
{
    NSMutableArray *nonEmpty = [[NSMutableArray alloc] initWithCapacity:[self count]];
    
    for (id item in self)
    {
        if ([@"" isEqualToString:[item description]] == NO)
        {
            [nonEmpty addObject:item];
        }
    }
    
    NSString *joined = [nonEmpty componentsJoinedByString:string];

    IBA_RELEASE(nonEmpty);
    
    return joined;
}

@end
