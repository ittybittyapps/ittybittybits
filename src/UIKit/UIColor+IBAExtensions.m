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

@end
