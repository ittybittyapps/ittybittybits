//
//  NSOperationQueue+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 26/09/11.
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

#import "NSOperationQueue+IBAExtensions.h"

@implementation NSOperationQueue (IBAExtensions)

/*!
 \brief     Returns an auto-released NSOperationQueue instance with the specified \a name.
 \param     name        The name of the queue.
 */
+ (NSOperationQueue *)ibaOperationQueueWithName:(NSString *)name
{
    NSOperationQueue *q = [[self alloc] init];
    [q setName:name];
    
    return [q autorelease];
}

/*!
 \brief     Returns an auto-released NSOperationQueue instance with the specified \a name and maxConcurrentOperationCount set to 1.
 \param     name        The name of the queue.
 */
+ (NSOperationQueue *)ibaSerialOperationQueueWithName:(NSString *)name
{
    NSOperationQueue *q = [self ibaOperationQueueWithName:name];
    q.maxConcurrentOperationCount = 1;
    return q;
}

@end
