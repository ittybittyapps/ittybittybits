//
//  UIColor+IBAExtensions.m
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

#import "UIColor+IBAExtensions.h"
#import "../Foundation/IBAFoundation.h"

@implementation UIColor (IBAExtensions)

#pragma mark -
#pragma mark Class Methods

/*!
 \brief     Get the UIColor instance that corresponds to the specified \a cssColorName.
 \returns   A UIColor instance for the specified \a cssColorName if one exists; otherwise nil.
 */
+ (UIColor *)ibaColorWithCSSName:(NSString *)cssColorName 
{
    static NSDictionary *colorNameCache;   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorNameCache = [[NSDictionary alloc] initWithObjectsAndKeys:
#       define X(x, y) IBAUIColorFromRGB(x), @#y,
#           include "IBACSSColors.x"
#       undef X
                          nil];
    });
    
    UIColor *cachedColor = [colorNameCache objectForKey:[cssColorName lowercaseString]];
    if (cachedColor)
    {
        // We return a copy to avoid clients from over releasing members of the cache dictionary.
        return [UIColor colorWithCGColor:cachedColor.CGColor];
    }
    
    return nil;
}


/*!
 \brief     Create an autoreleased UIColor instance from the specified RGB value.
 Example:
 \code
 UIColor *color = [UIColor ibaColorWithRGBHex: 0x333333];
 \endcode
 */

+ (UIColor *)ibaColorWithRGBHex:(uint32_t)hex
{
    int32_t r = (hex >> 16) & 0xFF;
    int32_t g = (hex >> 8) & 0xFF;
    int32_t b = (hex) & 0xFF;

    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

/*!
 \brief
 Create an autorleased UIColor instance from the specified HTML style hex string.
 Example:
 \code
 UIColor *color = [UIColor ibaColorWithHTMLHEx:@"#cccccc"];
 \endcode
 \return
 An auto-released UIColor instance for the specified HTML \a hexString.
 */
+ (UIColor *)ibaColorWithHTMLHex:(NSString *)hexString
{
    NSScanner * scanner = [NSScanner scannerWithString:hexString];
    
    uint32_t value;
    scanner.scanLocation = [hexString hasPrefix:@"#"] ? 1 : 0;
    if ([scanner scanHexInt:&value])
    {
        return [UIColor ibaColorWithRGBHex:value];
    }
    
    return nil;
}

+ (UIColor *)ibaColorWithCSSRGB:(NSString *)cssRGBString
{
    NSString *pattern = @"rgb(a)?\\(([\\d\\.]+)(%)?,\\s*([\\d\\.]+)(%)?,\\s*([\\d\\.]+)(%)?(,\\s*([\\d\\.]+)(%)?)?\\)";
    NSError *error = nil;
    NSRegularExpression *regex = [[[NSRegularExpression alloc] initWithPattern:pattern 
                                                                      options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines 
                                                                        error:&error] autorelease];
    
    if (regex && error == nil)
    {    
        __block NSString *red = nil;
        __block NSString *green = nil;
        __block NSString *blue = nil;
        __block NSString *alpha = nil;
        __block BOOL redIsPercent = NO;
        __block BOOL greenIsPercent = NO;
        __block BOOL blueIsPercent = NO;
        __block BOOL alphaIsPercent = NO;
        
        [regex enumerateMatchesInString:cssRGBString 
                                options:0 
                                  range:NSMakeRange(0, [cssRGBString length]) 
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags IBA_UNUSED flags, BOOL *stop) {
                                 
                                 NSRange alphaExpectedRange = [result rangeAtIndex:1];
                                 NSRange redRange = [result rangeAtIndex:2];
                                 NSRange redPercentRange = [result rangeAtIndex:3];
                                 NSRange greenRange = [result rangeAtIndex:4];
                                 NSRange greenPercentRange = [result rangeAtIndex:5];
                                 NSRange blueRange = [result rangeAtIndex:6];
                                 NSRange bluePercentRange = [result rangeAtIndex:7];
                                 NSRange alphaRange = [result rangeAtIndex:9];
                                 NSRange alphaPercentRange = [result rangeAtIndex:10];
                                 
                                 red = [cssRGBString substringWithRange:redRange];
                                 green = [cssRGBString substringWithRange:greenRange];
                                 blue = [cssRGBString substringWithRange:blueRange];
 
                                 if (alphaExpectedRange.location != NSNotFound)
                                 {    
                                     alpha = alphaRange.location != NSNotFound ? [cssRGBString substringWithRange:alphaRange] : @"1.0";
                                 }
                                 
                                 redIsPercent = redPercentRange.location != NSNotFound;
                                 greenIsPercent = greenPercentRange.location != NSNotFound;
                                 blueIsPercent = bluePercentRange.location != NSNotFound;
                                 alphaIsPercent = alphaPercentRange.location != NSNotFound;
                                 
                                 *stop = YES;
                             }];
        
        if (red && green && blue)
        {
            return [UIColor colorWithRed:[red floatValue]/(redIsPercent ? 100.0f : 255.0f)
                                   green:[green floatValue]/(greenIsPercent ? 100.0f : 255.0f)
                                    blue:[blue floatValue]/(blueIsPercent ? 100.0f : 255.0f)
                                   alpha:(alpha ? [alpha floatValue]/(alphaIsPercent ? 100.0f : 1.0f) : 1.0f)];
        }
    }
    else
    {
        IBALogError(@"failed to create regular expression with pattern: %@. Error: %@", pattern, error);
    }
    
    return nil;
}

#pragma mark -
#pragma mark Instance Methods

/*!
 \brief     Returns the color space associated with the receiver.   
 \return    The Quartz color space for the receiving UIColor.
 \sa        CGColorGetColorSpace
 */
- (CGColorSpaceRef)ibaColorSpace
{
    return CGColorGetColorSpace(self.CGColor);
}

/*!
 \brief    Returns the color space model of the receiver.
 \return   One of the constants described in “Color Space Models”.
 \sa       CGColorSpaceGetModel
 */
- (CGColorSpaceModel)ibaColorSpaceModel
{
    return CGColorSpaceGetModel(self.ibaColorSpace);
}

/*!
 \brief     Returns the value of the alpha component associated with a Quartz color.
 \return    An alpha intensity value in the range [0,1]. 
 \sa        CGColorGetAlpha
 */
- (CGFloat)ibaAlpha 
{
	return CGColorGetAlpha(self.CGColor);
}

/*!
 \brief         Returns the components of the receiving color instance.
 
 \param[out]    outRed     
 The red component value.
 
 \param[out]    outGreen
 The green component value.
 
 \param[out]    outBlue
 The blue component value.
 */
- (void)ibaColorComponentsRed:(CGFloat*)outRed green:(CGFloat*)outGreen blue:(CGFloat*)outBlue
{
    NSAssert(CGColorSpaceGetNumberOfComponents(self.ibaColorSpace) >= 3 && 
             (self.ibaColorSpaceModel == kCGColorSpaceModelMonochrome ||
              self.ibaColorSpaceModel == kCGColorSpaceModelRGB), 
             @"only RGB and Monochrome color spaces supported.");
    
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    if (outRed) *outRed = components[0];
    if (outGreen) *outGreen = components[1];
    if (outBlue) *outBlue = components[2];
}

/*!
 \brief     Returns the red component of the receiving color instance.
 */
- (CGFloat)ibaRed
{
    CGFloat component = 0.0f;
    [self ibaColorComponentsRed:&component green:NULL blue:NULL];
    return component;
}

/*!
 \brief     Returns the green component of the receiving color instance.
 */

- (CGFloat)ibaGreen
{
    CGFloat component = 0.0f;
    [self ibaColorComponentsRed:NULL green:&component blue:NULL];
    return component;
}

/*!
 \brief     Returns the blue component of the receiving color instance.
 */
- (CGFloat)ibaBlue
{
    CGFloat component = 0.0f;
    [self ibaColorComponentsRed:NULL green:NULL blue:&component];
    return component;
}


@end


