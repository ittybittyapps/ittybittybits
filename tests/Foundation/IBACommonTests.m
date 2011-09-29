//
//  IBACommonTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 29/09/11.
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

#import "IBACommonTests.h"
#import "IBACommon.h"

@implementation IBACommonTests

- (void)testIBANSIntegerToNSUInteger
{
    GHAssertEquals((NSUInteger)NSIntegerMax, IBANSIntegerToNSUInteger(NSIntegerMax), @"");
    GHAssertEquals((NSUInteger)0, IBANSIntegerToNSUInteger(NSIntegerMin), @"");
    GHAssertEquals((NSUInteger)0, IBANSIntegerToNSUInteger(0), @"");
    GHAssertEquals((NSUInteger)NSIntegerMax-1, IBANSIntegerToNSUInteger(NSIntegerMax-1), @"");
}

- (void)testIBANSUIntegerToNSInteger
{
    GHAssertEquals((NSInteger)NSIntegerMax, IBANSUIntegerToNSInteger(NSUIntegerMax), @"");
    GHAssertEquals((NSInteger)NSIntegerMax, IBANSUIntegerToNSInteger(NSUIntegerMax-1), @"");
    GHAssertEquals((NSInteger)NSIntegerMax, IBANSUIntegerToNSInteger((NSUInteger)NSIntegerMax), @"");
    GHAssertEquals((NSInteger)NSIntegerMax-1, IBANSUIntegerToNSInteger((NSUInteger)NSIntegerMax-1), @"");
    GHAssertEquals((NSInteger)0, IBANSUIntegerToNSInteger(0), @"");
}

@end
