//
//  IBAResourceBundle+UIKitTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/08/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
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

#import "IBAResourceBundle+UIKitTests.h"
#import "IttyBittyBits.h"

@implementation IBAResourceBundle_UIKitTests
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
    GHAssertTrue([bundle hasResourceNamed:@"colorPattern"], @"");
    
    UIColor *colorHex = [bundle colorNamed:@"colorHex"];
    UIColor *colorNumber = [bundle colorNamed:@"colorNumber"];
    UIColor *colorCSSRGB = [bundle colorNamed:@"colorCSSRGB"];
    UIColor *colorCSSName = [bundle colorNamed:@"colorCSSName"];
    UIColor *colorRedirect = [bundle colorNamed:@"colorRedirect"];
    UIColor *colorPattern = [bundle colorWithPatternNamed:@"colorPattern"];
    
    GHAssertNotNil(colorHex, @"");
    GHAssertNotNil(colorNumber, @"");
    GHAssertNotNil(colorCSSRGB, @"");
    GHAssertNotNil(colorCSSName, @"");
    GHAssertNotNil(colorRedirect, @"");
    GHAssertNotNil(colorPattern, @"");
    
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

- (void)testImages
{
    GHAssertTrue([bundle hasResourceNamed:@"imageTest"], @"");
    
    UIImage *image = [bundle imageNamed:@"imageTest"];
    GHAssertNotNil(image, @"");
    
    GHAssertEquals(image.scale, [[UIScreen mainScreen] scale], @"image scale should equal screen scale");
}

- (void)testFonts
{
    GHAssertTrue([bundle hasResourceNamed:@"fontAsDict"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"fontAsString"], @"");
    GHAssertTrue([bundle hasResourceNamed:@"fontAsRedirect"], @"");
    
    UIFont *fontAsDict = [bundle fontNamed:@"fontAsDict"];
    UIFont *fontAsString = [bundle fontNamed:@"fontAsString"];
    UIFont *fontAsRedirect = [bundle fontNamed:@"fontAsRedirect"];
    
    GHAssertNotNil(fontAsDict, @"");
    GHAssertNotNil(fontAsString, @"");
    GHAssertEqualObjects(fontAsDict, fontAsRedirect, @"");
}

@end
