//
//  UIView+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 22/06/11.
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

#import "UIView+IBAExtensions.h"

@implementation UIView (IBAExtensions)

- (CGFloat)ibaLeft 
{
    return self.frame.origin.x;
}

- (void)setIbaLeft:(CGFloat)x 
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (CGFloat)ibaTop 
{
    return self.frame.origin.y;
}


- (void)setIbaTop:(CGFloat)y 
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGFloat)ibaRight 
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setIbaRight:(CGFloat)right 
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ibaBottom 
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setIbaBottom:(CGFloat)bottom 
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

/*!
 \brief     Returns the frame height of the view.
 */
- (CGFloat)ibaWidth
{
    return self.frame.size.width;
}

/*!
 \brief     Sets the frame width of the view.
 */
- (void)setIbaWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

/*!
 \brief     Returns the frame height of the view.
 */
- (CGFloat)ibaHeight
{
    return self.frame.size.height;
}

/*!
 \brief     Sets the frame height of the view.
 */
- (void)setIbaHeight:(CGFloat)height 
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

/*!
 \brief     Sets the view to be hidden or shown with an alpha fade in/out transition of the specified \a duration.
 \param     hidden      YES to hide the view; NO to show the view.
 \param     duration    The duration in seconds of the alpha fade in/out transition.
 */
- (void)ibaSetHidden:(BOOL)hidden withAlphaTransistionDuration:(CGFloat)duration
{
    [self ibaSetHidden:hidden withAlphaTransistionDuration:duration completion:nil];    
}

/*!
 \brief     Sets the view to be hidden or shown with an alpha fade in/out transition of the specified \a duration.
 \param     hidden      YES to hide the view; NO to show the view.
 \param     duration    The duration in seconds of the alpha fade in/out transition.
 \param     completion  A block to invoke when the animation is complete.
 */
- (void)ibaSetHidden:(BOOL)hidden withAlphaTransistionDuration:(CGFloat)duration completion:(void (^)(BOOL finished))completion
{
    void (^setHidden)() = ^{
        self.hidden = hidden;
    };
    
    CGFloat newAlpha = hidden ? 0 : 1;
    if (hidden == NO)
    {
        setHidden();
    }
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         self.alpha = newAlpha;
                     } completion:^(BOOL finished) {
                         if (hidden)
                         {
                             setHidden();
                         }
                         
                         if (completion)
                         {
                             completion(finished);
                         }
                     }];
}

@end
