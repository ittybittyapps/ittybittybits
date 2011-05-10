//
//  NSArray+Whitespace.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 10/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSArray+Whitespace.h"
#import "IBACommon.h"

@implementation NSArray (IBANSArrayWhitespaceAdditions)

/////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*) ibaNonEmptyComponentsJoinedByString:(NSString*)string
{
    NSMutableArray* nonEmpty = [[NSMutableArray alloc] initWithCapacity:[self count]];
    
    for (id item in self)
    {
        if ([@"" isEqualToString:[item description]] == NO)
        {
            [nonEmpty addObject:item];
        }
    }
    
    NSString* joined = [nonEmpty componentsJoinedByString:string];

    IBA_RELEASE(nonEmpty);
    
    return joined;
}

@end
