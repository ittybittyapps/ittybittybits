//
//  UIColor+IBAExtensions.h
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

#import <UIKit/UIKit.h>

/*!
 \brief     Create an autoreleased UIColor instance from the specified RGB value.
 Example:
 \code
 UIColor *color = IBAUIColorFromRGB(0x333333);
 \endcode
 \sa        UIColor#ibaColorWithRGBHex
 */
#define IBAUIColorFromRGB(rgbValue) [UIColor ibaColorWithRGBHex:(rgbValue)]

/*!
 \brief     Create an autoreleased UIColor instance from the specified RGB and alpha values.
 Example:
 \code
 UIColor *color = IBAUIColorFromRGBA(0x333300, 0.5f);
 \endcode
 */
#define IBAUIColorFromRGBA(rgbValue, alphaValue) [UIColor \
    colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0f \
    green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0f \
    blue:((float)((rgbValue) & 0xFF))/255.0f alpha:(alphaValue)]

@interface UIColor (IBAExtensions)

@property (nonatomic, assign, readonly) CGColorSpaceRef ibaColorSpace;
@property (nonatomic, assign, readonly) CGColorSpaceModel ibaColorSpaceModel;
@property (nonatomic, assign, readonly) CGFloat ibaAlpha;
@property (nonatomic, assign, readonly) CGFloat ibaRed;
@property (nonatomic, assign, readonly) CGFloat ibaGreen;
@property (nonatomic, assign, readonly) CGFloat ibaBlue;

- (void)ibaColorComponentsRed:(CGFloat*)outRed green:(CGFloat*)outGreen blue:(CGFloat*)outBlue;

+ (UIColor *)ibaColorWithCSSName:(NSString *)cssColorName;
+ (UIColor *)ibaColorWithRGBHex:(uint32_t)hex;
+ (UIColor *)ibaColorWithHTMLHex:(NSString *)hexString;
+ (UIColor *)ibaColorWithCSSRGB:(NSString *)cssRGBString;

@end
