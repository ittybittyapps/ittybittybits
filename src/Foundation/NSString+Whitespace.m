//
//  NSString+Whitespace.m
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

#import "NSString+Whitespace.h"
#import "IBACommon.h"

@implementation NSString (IBAWhitespaceAdditions)

/////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*) ibaStringByTrimmingWhitespaceAndNewline
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *) ibaStringByCompressingWhitespaceAndNewlineTo:(NSString *)seperator
{
    NSArray *components = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray *nonemptyComponents = [[NSMutableArray alloc] initWithCapacity:[components count]];

    for (NSString *component in components)
    {
        if ([@"" isEqualToString:component] == NO)
        {
            [nonemptyComponents addObject:component];
        }
    }

    NSString* compressedString = [nonemptyComponents componentsJoinedByString:seperator];
    IBA_RELEASE(nonemptyComponents);
    
    return compressedString;
}

@end
