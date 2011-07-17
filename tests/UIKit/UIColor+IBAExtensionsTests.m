//
//  UIColor+IBAExtensionsTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 17/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

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



@end
