//
//  IBAResourceBundle+CoreGraphicsTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 16/11/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//
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

#import "IBAResourceBundle+CoreGraphicsTests.h"
#import "IttyBittyBits.h"

@implementation IBAResourceBundle_CoreGraphicsTests
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

// Run before the tests are run for this class
- (void)setUpClass {}

// Run before the tests are run for this class
- (void)tearDownClass {}

- (void)testSizes
{
    GHAssertTrue([bundle hasResourceNamed:@"sizeAsString"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"sizeAsDict"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"sizeAsRedirect"], @"");
    
    CGSize sizeAsString = [bundle sizeNamed:@"sizeAsString"];
    CGSize sizeAsDict = [bundle sizeNamed:@"sizeAsDict"];
    CGSize sizeAsRedirect = [bundle sizeNamed:@"sizeAsRedirect"];
    
    GHAssertEquals(sizeAsString.width, 1.0f, @"");
    GHAssertEquals(sizeAsString.height, 2.0f, @"");
    
    GHAssertEquals(sizeAsDict.width, 3.0f, @"");
    GHAssertEquals(sizeAsDict.height, 4.0f, @"");
    
    GHAssertEquals(sizeAsString, sizeAsRedirect, @"");
}

- (void)testPoints
{
    GHAssertTrue([bundle hasResourceNamed:@"pointAsString"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"pointAsDict"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"pointAsRedirect"], @"");
    
    CGPoint pointAsString = [bundle pointNamed:@"pointAsString"];
    CGPoint pointAsDict = [bundle pointNamed:@"pointAsDict"];
    CGPoint pointAsRedirect = [bundle pointNamed:@"pointAsRedirect"];
    
    GHAssertEquals(pointAsString.x, 1.0f, @"");
    GHAssertEquals(pointAsString.y, 2.0f, @"");
    
    GHAssertEquals(pointAsDict.x, 3.0f, @"");
    GHAssertEquals(pointAsDict.y, 4.0f, @"");
    
    GHAssertEquals(pointAsString, pointAsRedirect, @"");
}

- (void)testRects
{
    GHAssertTrue([bundle hasResourceNamed:@"rectAsString"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"rectAsDict"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"rectAsRedirect"], @"");
    
    CGRect rectAsString = [bundle rectNamed:@"rectAsString"];
    CGRect rectAsDict = [bundle rectNamed:@"rectAsDict"];
    CGRect rectAsRedirect = [bundle rectNamed:@"rectAsRedirect"];
    
    GHAssertEquals(rectAsString.origin.x, 1.0f, @"");
    GHAssertEquals(rectAsString.origin.y, 2.0f, @"");
    GHAssertEquals(rectAsString.size.width, 3.0f, @"");
    GHAssertEquals(rectAsString.size.height, 4.0f, @"");
    
    GHAssertEquals(rectAsDict.origin.x, 5.0f, @"");
    GHAssertEquals(rectAsDict.origin.y, 6.0f, @"");
    GHAssertEquals(rectAsDict.size.width, 7.0f, @"");
    GHAssertEquals(rectAsDict.size.height, 8.0f, @"");
    
    GHAssertEquals(rectAsString, rectAsRedirect, @"");
}

@end
