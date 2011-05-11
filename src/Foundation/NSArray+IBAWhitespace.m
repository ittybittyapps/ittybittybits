//
//  NSArray+Whitespace.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 10/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSArray+Whitespace.h"
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
