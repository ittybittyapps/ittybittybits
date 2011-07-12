//
//  NSNumber+IBACompare.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 13/05/11.
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
