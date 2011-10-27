//
//  NSMutableSet+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 25/07/11.
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

#import "NSMutableSet+IBAExtensions.h"

@implementation NSMutableSet (IBAExtensions)

/*!
 \brief     Removes all occurrences in the array of a given array if objects.
 \param     objects     An array of objects to remove.
 */
- (void)ibaRemoveObjectsInArray:(NSArray *)objects
{
    for (id o in objects) 
    {
        [self removeObject:o];
    }
}

@end
