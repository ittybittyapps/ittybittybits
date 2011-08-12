//
//  NSNumber+IBAExtensions.h
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

#import <Foundation/Foundation.h>

#define IBAFloatToNumber(x) [NSNumber numberWithFloat:(x)]
#define IBADoubleToNumber(x) [NSNumber numberWithDouble:(x)]
#define IBABoolToNumber(x) [NSNumber numberWithBool:(x)]
#define IBAIntToNumber(x) [NSNumber numberWithInt:(x)]
#define IBAIntegerToNumber(x) [NSNumber numberWithInteger:(x)]
#define IBAUIntToNumber(x) [NSNumber numberWithUnsignedInt:(x)]
#define IBAUIntegerToNumber(x) [NSNumber numberWithUnsignedInteger:(x)]
#define IBALongToNumber(x) [NSNumber numberWithLong:(x)]
#define IBAULongToNumber(x) [NSNumber numberWithUnsignedLong:(x)]
#define IBALongLongToNumber(x) [NSNumber numberWithLongLong:(x)]
#define IBAULongLongToNumber(x) [NSNumber numberWithUnsignedLongLong:(x)]

/*!
 \def       IBANSNumberZero
 \brief     Macro that defines a NSNumber "zero".
 */
#define IBANSNumberZero [NSNumber numberWithInt:0]


@interface NSNumber (IBAExtensions)

- (BOOL)ibaIsLessThanInt:(int)n;
- (BOOL)ibaIsGreaterThanInt:(int)n;
- (BOOL)ibaIsEqualToInt:(int)n;

- (BOOL)ibaIsLessThanFloat:(float)n;
- (BOOL)ibaIsGreaterThanFloat:(float)n;
- (BOOL)ibaIsEqualToFloat:(float)n;

- (BOOL)ibaIsLessThan:(NSNumber *)other;
- (BOOL)ibaIsLessThanOrEqualTo:(NSNumber *)other;
- (BOOL)ibaIsGreaterThan:(NSNumber *)other;
- (BOOL)ibaIsGreaterThanOrEqualTo:(NSNumber *)other;

@end
