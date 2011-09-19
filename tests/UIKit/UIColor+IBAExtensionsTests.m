//
//  UIColor+IBAExtensionsTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 17/07/11.
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

#import "UIColor+IBAExtensionsTests.h"

#import "UIColor+IBAExtensions.h"

@implementation UIColor_IBAExtensionsTests


// Run before each test method
- (void)setUp {}

// Run after each test method
- (void)tearDown {}

// Run before the tests are run for this class
- (void)setUpClass {}

// Run before the tests are run for this class
- (void)tearDownClass {}

- (void)testIbaColorSpace
{
    UIColor *c = [UIColor whiteColor];
    
    CGColorSpaceRef csref = c.ibaColorSpace;
    
    GHAssertNotNULL(csref, @"color space can not be NULL");
}

- (void)testIbaColorSpaceModel
{
    UIColor *c = [UIColor whiteColor];
    
    CGColorSpaceModel csModel = c.ibaColorSpaceModel;

    GHAssertEquals(csModel,  kCGColorSpaceModelMonochrome, @"color space model is not %d", kCGColorSpaceModelMonochrome);
    
    c = [UIColor redColor];
    
    csModel = c.ibaColorSpaceModel;

    GHAssertEquals(csModel, kCGColorSpaceModelRGB, @"color space model is not %d", kCGColorSpaceModelRGB);
}

- (void)testIbaAlpha
{
    UIColor *c = [UIColor whiteColor];
    
    CGFloat alpha = c.ibaAlpha;
    
    GHAssertEquals(alpha, 1.0f, @"alpha %f does not equal 1.0", alpha);
}

- (void)testIbaColorWithCSSName
{
    // mmmm, chocolate
    UIColor *c = [UIColor ibaColorWithCSSName:@"chocolate"];
    
    GHAssertNotNil(c, @"color for 'chocolate' can not be nil");
    
    c = [UIColor ibaColorWithCSSName:@"Chocolate"];

    GHAssertNotNil(c, @"color for 'Chocolate' can not be nil");
    
    c = [UIColor ibaColorWithCSSName:@"NotChocolate"];
    
    GHAssertNil(c, @"color for 'NotChocolate' should be nil");
}

- (void)testIbaColorWithRGBHex
{
    UIColor *c = [UIColor ibaColorWithRGBHex:0x333333];
    
    GHAssertNotNil(c, @"color can not be nil");
}

- (void)testIbaColorWithHTMLHex
{
    UIColor *c1 = [UIColor ibaColorWithHTMLHex:@"#332211"];
    
    GHAssertNotNil(c1, @"color should not be nil");
    GHAssertEquals(c1.ibaRed, 0x33/255.0f, @"red component should be %d", 0x33/255.0f);
    GHAssertEquals(c1.ibaGreen, 0x22/255.0f, @"red component should be %d", 0x22/255.0f);
    GHAssertEquals(c1.ibaBlue, 0x11/255.0f, @"red component should be %d", 0x11/255.0f);
    
    UIColor *c2 = [UIColor ibaColorWithHTMLHex:@"443322"];
    
    GHAssertNotNil(c2, @"color should not be nil");
    GHAssertEquals(c2.ibaRed, 0x44/255.0f, @"red component should be %d", 0x44/255.0f);
    GHAssertEquals(c2.ibaGreen, 0x33/255.0f, @"red component should be %d", 0x33/255.0f);
    GHAssertEquals(c2.ibaBlue, 0x22/255.0f, @"red component should be %d", 0x22/255.0f);
}

- (void)testIbaColorWithCSSRGB
{
    UIColor *c1 = [UIColor ibaColorWithCSSRGB:@"rgb(1,2,3)"];
    
    GHAssertNotNil(c1, @"color should not be nil");
    GHAssertEquals(c1.ibaRed, 1.0f/255.0f, @"red component should be %f", 1/255.0f);
    GHAssertEquals(c1.ibaGreen, 2/255.0f, @"red component should be %f", 2/255.0f);
    GHAssertEquals(c1.ibaBlue, 3/255.0f, @"red component should be %f", 3/255.0f);
    
    UIColor *c2 = [UIColor ibaColorWithCSSRGB:@"RGB(3,4,5)"];
    
    GHAssertNotNil(c2, @"color should not be nil");
    GHAssertEquals(c2.ibaRed, 3/255.0f, @"red component should be %f", 3/255.0f);
    GHAssertEquals(c2.ibaGreen, 4/255.0f, @"red component should be %f", 4/255.0f);
    GHAssertEquals(c2.ibaBlue, 5/255.0f, @"red component should be %f", 5/255.0f);
    GHAssertEquals(c2.ibaAlpha, 1.0f, @"red component should be %f", 1.0f);
    
    UIColor *c3 = [UIColor ibaColorWithCSSRGB:@"rgba(3,4,5)"];
    
    GHAssertNotNil(c3, @"color should not be nil");
    GHAssertEquals(c3.ibaRed, 3/255.0f, @"red component should be %f", 3/255.0f);
    GHAssertEquals(c3.ibaGreen, 4/255.0f, @"red component should be %f", 4/255.0f);
    GHAssertEquals(c3.ibaBlue, 5/255.0f, @"red component should be %f", 5/255.0f);
    GHAssertEquals(c3.ibaAlpha, 1.0f, @"red component should be %f", 1.0f);

    UIColor *c4 = [UIColor ibaColorWithCSSRGB:@"rgba(3,4,5, 0.5)"];
    
    GHAssertNotNil(c4, @"color should not be nil");
    GHAssertEquals(c4.ibaRed, 3/255.0f, @"red component should be %f", 3/255.0f);
    GHAssertEquals(c4.ibaGreen, 4/255.0f, @"red component should be %f", 4/255.0f);
    GHAssertEquals(c4.ibaBlue, 5/255.0f, @"red component should be %f", 5/255.0f);
    GHAssertEquals(c4.ibaAlpha, 0.5f, @"red component should be %f", 0.5f);

    UIColor *c5 = [UIColor ibaColorWithCSSRGB:@"rgba(100%, 4, 5, 0.5)"];
    
    GHAssertNotNil(c5, @"color should not be nil");
    GHAssertEquals(c5.ibaRed, 1.0f, @"red component should be %f", 1.0f);
    GHAssertEquals(c5.ibaGreen, 4/255.0f, @"red component should be %f", 4/255.0f);
    GHAssertEquals(c5.ibaBlue, 5/255.0f, @"red component should be %f", 5/255.0f);
    GHAssertEquals(c5.ibaAlpha, 0.5f, @"red component should be %f", 0.5f);

    UIColor *c6 = [UIColor ibaColorWithCSSRGB:@"rgba(100%, 50%, 5, 0.5)"];
    
    GHAssertNotNil(c6, @"color should not be nil");
    GHAssertEquals(c6.ibaRed, 1.0f, @"red component should be %f", 1.0f);
    GHAssertEquals(c6.ibaGreen, 0.5f, @"red component should be %f", 0.5f);
    GHAssertEquals(c6.ibaBlue, 5/255.0f, @"red component should be %f", 5/255.0f);
    GHAssertEquals(c6.ibaAlpha, 0.5f, @"red component should be %f", 0.5f);
    
    UIColor *c7 = [UIColor ibaColorWithCSSRGB:@"rgba(100%, 60%, 75%, 50%)"];
    
    GHAssertNotNil(c7, @"color should not be nil");
    GHAssertEquals(c7.ibaRed, 1.0f, @"red component should be %f", 1.0f);
    GHAssertEquals(c7.ibaGreen, 0.6f, @"red component should be %f", 0.6f);
    GHAssertEquals(c7.ibaBlue, 0.75f, @"red component should be %f", 0.75f);
    GHAssertEquals(c7.ibaAlpha, 0.5f, @"red component should be %f", 0.5f);
}

@end
