//
//  NSArray+IBASorting.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 18/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSArray+IBASorting.h"

@implementation NSArray (IBASorting)

- (NSArray *) sortedArrayOfNumbers
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(NSNumber *a, NSNumber *b) {
        return [a compare:b];
    }];
}

- (NSArray *) sortedArrayOfLocalizedStrings
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        return [a localizedCompare:b];
    }];
}

@end
