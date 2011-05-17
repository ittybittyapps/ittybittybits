//
//  NSNumber+IBACompare.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 13/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSNumber+IBACompare.h"


@implementation NSNumber (IBACompare)

- (BOOL) ibaLessThanInt:(int)n
{
    return [self compare:[NSNumber numberWithInt:n]] < 0;
}

- (BOOL) ibaGreaterThanInt:(int)n
{
    return [self compare:[NSNumber numberWithInt:n]] > 0;
}

- (BOOL) ibaEqualToInt:(int)n
{
    return [self compare:[NSNumber numberWithInt:n]] == 0;
}

- (BOOL) ibaLessThanFloat:(float)n
{
    return [self compare:[NSNumber numberWithFloat:n]] < 0;
}

- (BOOL) ibaGreaterThanFloat:(float)n
{
    return [self compare:[NSNumber numberWithFloat:n]] > 0;
}

- (BOOL) ibaEqualToFloat:(float)n
{
    return [self compare:[NSNumber numberWithFloat:n]] == 0;
}


@end
