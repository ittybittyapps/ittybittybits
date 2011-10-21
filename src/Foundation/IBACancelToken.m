//
//  IBACancelToken.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 21/10/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

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
