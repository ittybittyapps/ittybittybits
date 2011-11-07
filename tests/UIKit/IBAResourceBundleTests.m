//
//  IBAResourceBundleTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/08/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

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

// Run before the tests are run for this class
- (void)setUpClass {}

// Run before the tests are run for this class
- (void)tearDownClass {}

- (void)testColors
{
    GHAssertTrue([bundle hasResourceNamed:@"colorHex"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"colorNumber"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"colorCSSRGB"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"colorCSSName"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"colorRedirect"], @"");
    
    UIColor *colorHex = [bundle colorNamed:@"colorHex"];
    UIColor *colorNumber = [bundle colorNamed:@"colorNumber"];
    UIColor *colorCSSRGB = [bundle colorNamed:@"colorCSSRGB"];
    UIColor *colorCSSName = [bundle colorNamed:@"colorCSSName"];
    UIColor *colorRedirect = [bundle colorNamed:@"colorRedirect"];
    
    GHAssertNotNil(colorHex, @"");
    GHAssertNotNil(colorNumber, @"");
    GHAssertNotNil(colorCSSRGB, @"");
    GHAssertNotNil(colorCSSName, @"");
    GHAssertNotNil(colorRedirect, @"");
    
    GHAssertEquals(colorHex.ibaRed, (CGFloat)(0x11/255.0), @"");
    GHAssertEquals(colorHex.ibaGreen, (CGFloat)(0x22/255.0), @"");
    GHAssertEquals(colorHex.ibaBlue, (CGFloat)(0x33/255.0), @"");
    
    GHAssertEquals(colorNumber.ibaRed, (CGFloat)(0x33/255.0), @"");
    GHAssertEquals(colorNumber.ibaGreen, (CGFloat)(0x11/255.0), @"");
    GHAssertEquals(colorNumber.ibaBlue, (CGFloat)(0x22/255.0), @"");
    
    GHAssertEquals(colorCSSRGB.ibaRed, (CGFloat)(22/255.0), @"");
    GHAssertEquals(colorCSSRGB.ibaGreen, (CGFloat)(33/255.0), @"");
    GHAssertEquals(colorCSSRGB.ibaBlue, (CGFloat)(44/255.0), @"");

    GHAssertEquals(colorCSSName.ibaRed, (CGFloat)(0x00/255.0), @"");
    GHAssertEquals(colorCSSName.ibaGreen, (CGFloat)(0x80/255.0), @"");
    GHAssertEquals(colorCSSName.ibaBlue, (CGFloat)(0x00/255.0), @"");
    
    GHAssertEquals(colorRedirect.ibaRed, colorHex.ibaRed, @"");
    GHAssertEquals(colorRedirect.ibaGreen, colorHex.ibaGreen, @"");
    GHAssertEquals(colorRedirect.ibaBlue, colorHex.ibaBlue, @"");
}

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
