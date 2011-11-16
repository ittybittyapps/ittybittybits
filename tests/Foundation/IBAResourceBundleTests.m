//
//  IBAResourceBundleTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 16/11/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
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

#import "IBAResourceBundleTests.h"
#import "IttyBittyBits.h"

@implementation IBAResourceBundleTests
{
    IBAResourceBundle *bundle; 
}

// Run before each test method
- (void)setUp 
{
    bundle = [[IBAResourceBundle alloc] initWithBundleName:@"DefaultResources"];
    
    GHAssertNotNil(bundle, @"");
}

// Run after each test method
- (void)tearDown 
{
    IBA_RELEASE(bundle);
}

- (void)testStrings
{
    NSString *string = [bundle stringNamed:@"string"];
    NSString *stringRedirect = [bundle stringNamed:@"stringRedirect"];
    
    GHAssertNotNil(string, @"");
    GHAssertNotNil(stringRedirect, @"");
    GHAssertEqualStrings(string, stringRedirect, @"");
}

- (void)testData
{
    NSData *data = [bundle dataNamed:@"data"];
    NSData *dataRedirect = [bundle dataNamed:@"dataRedirect"];
    NSData *dataFile = [bundle dataNamed:@"dataFile"];
    
    GHAssertNotNil(data, @"");
    GHAssertNotNil(dataRedirect, @"");
    GHAssertNotNil(dataFile, @"");
    
    GHAssertTrue([data isEqualToData:dataRedirect], @"");
    
    GHAssertTrue([[[[NSString alloc] initWithBytes:[dataFile bytes] length:[dataFile length] encoding:NSUTF8StringEncoding] autorelease] hasPrefix:@"This is a test data file."], @"");
}

- (void)testNumbers
{
    NSNumber *numberAsNumber = [bundle numberNamed:@"numberAsNumber"];
    NSNumber *numberAsString = [bundle numberNamed:@"numberAsString"];
    NSNumber *numberAsRedirect = [bundle numberNamed:@"numberAsRedirect"];
    
    GHAssertNotNil(numberAsNumber, @"");
    
    GHAssertEquals([numberAsNumber intValue], 1234, @"");
    GHAssertEquals([numberAsString floatValue], 3.14f, @"");
    GHAssertEquals([numberAsRedirect intValue], 1234, @"");
    GHAssertEqualObjects(numberAsNumber, numberAsRedirect, @"");
}

@end
