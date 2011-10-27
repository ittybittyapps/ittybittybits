//
//  IBACancelToken.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 21/10/11.
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

#import "IBACancelToken.h"
#import "IBACommon.h"

#import <libkern/OSAtomic.h>

@implementation IBACancelToken
{
    NSObject *lock;
    __volatile BOOL cancelled;
}

+ (id)token
{
    return [[IBACancelToken new] autorelease];
}

- (id)init
{
    if ((self = [super init]))
    {
        lock = [NSObject new];
    }
    
    return self;
}

- (void)dealloc
{
    IBA_RELEASE(lock);
    [super dealloc];
}

- (void)cancel
{
    @synchronized(lock)
    {
        cancelled = YES;
    }
}

- (BOOL)notCancelled
{
    return [self cancelled] == NO;
}

- (BOOL)cancelled
{
    @synchronized(lock)
    {
        return cancelled;
    }
}

@end
