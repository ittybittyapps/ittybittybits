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

#define IBALiteralsToNumbers(type, ...) IBA_CAT(_IBALiteralsToNumbers_, IBA_N_ARGS(__VA_ARGS__))(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_H(type, x) [NSNumber numberWith##type:(x)]
#define _IBALiteralsToNumbers_1(type, a) _IBALiteralsToNumbers_H(type, a)
#define _IBALiteralsToNumbers_2(type, a, b) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_H(type, b)
#define _IBALiteralsToNumbers_3(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_2(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_4(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_3(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_5(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_4(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_6(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_5(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_7(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_6(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_8(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_7(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_9(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_8(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_10(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_9(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_11(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_10(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_12(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_11(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_13(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_12(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_14(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_13(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_15(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_14(type, __VA_ARGS__)
#define _IBALiteralsToNumbers_16(type, a, ...) _IBALiteralsToNumbers_H(type, a), _IBALiteralsToNumbers_15(type, __VA_ARGS__)

#define IBAFloatsToNumbers(...) IBALiteralsToNumbers(Float, __VA_ARGS__)
#define IBADoublesToNumbers(...) IBALiteralsToNumbers(Double, __VA_ARGS__)
#define IBABoolsToNumbers(...) IBALiteralsToNumbers(Bool, __VA_ARGS__)
#define IBAIntsToNumbers(...) IBALiteralsToNumbers(Int, __VA_ARGS__)
#define IBAIntegersToNumbers(...) IBALiteralsToNumbers(Integer, __VA_ARGS__)
#define IBAUIntsToNumbers(...) IBALiteralsToNumbers(UnsignedInt, __VA_ARGS__)
#define IBAUIntegersToNumbers(...) IBALiteralsToNumbers(UsignedInteger, __VA_ARGS__)
#define IBALongsToNumbers(...) IBALiteralsToNumbers(Long, __VA_ARGS__)
#define IBAULongsToNumbers(...) IBALiteralsToNumbers(UnsignedLong, __VA_ARGS__)
#define IBALongLongsToNumbers(...) IBALiteralsToNumbers(LongLong, __VA_ARGS__)
#define IBAULongLongsToNumbers(...) IBALiteralsToNumbers(UnsignedLongLong, __VA_ARGS__)

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


