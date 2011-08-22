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
//
//  Portions:
//  Copyright (c) 2011, Kevin O'Neill
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
//  * Neither the name UsefulBits nor the names of its contributors may be used
//   to endorse or promote products derived from this software without specific
//   prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "UIView+IBAExtensions.h"
#import "UIGestureRecognizer+IBAExtensions.h"
#import "NSArray+IBAExtensions.h"

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
    if (self.hidden == hidden)
    {
        if (completion)
        {
            completion(YES);
        }
        return;
    }
    
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

/*!
 \brief     Sets the view to be hidden or shown with a slide transition to or from the specified \a direction.
 \details   The ultimate position of the view does not change.  It is returned to its original location after being hidden.
 */
- (void)ibaSetHidden:(BOOL)hidden withSlideTransistionDirection:(IBACompassDirection)direction duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion
{
    
    if (self.hidden == hidden)
    {
        if (completion)
        {
            completion(YES);
        }
        return;
    }
    
    CGFloat xTranslation = 0.0f;
    CGFloat yTranslation = 0.0f;
    CGRect screenBounds = self.window.screen.bounds;
    switch (direction) 
    {
        case IBACompassDirectionEast:
            xTranslation = screenBounds.size.width - self.ibaLeft;
            break;
        case IBACompassDirectionWest:
            xTranslation = -self.ibaRight;
            break;
        case IBACompassDirectionNorth:
            yTranslation = -self.ibaBottom;
            break;
        case IBACompassDirectionSouth:
            yTranslation = screenBounds.size.height - self.ibaTop;
            break;
            
        default:
            NSAssert(NO, @"Unknown compass direction!");
            return;
    }

    CGPoint offScreen = CGPointMake(self.center.x + xTranslation, self.center.y + yTranslation);
    CGPoint onScreen = self.center;
    CGPoint newCenter = hidden ? offScreen : onScreen;
    
    if (hidden == NO)
    {
        self.center = offScreen;
        self.hidden = hidden;
    }
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.center = newCenter;
                     } completion:^(BOOL finished) {
                         if (hidden)
                         {
                             self.hidden = hidden;
                             self.center = onScreen;
                         }
                         
                         if (completion)
                         {
                             completion(finished);
                         }
                     }];
}


- (void)ibaOnTap:(void (^) (id sender))action;
{
    [self ibaOnTaps:1 touches:1 action:action];
}

- (void)ibaOnDoubleTap:(void (^) (id sender))action;
{
    [self ibaOnTaps:2 touches:1 action:action];
}

- (void)ibaOnTaps:(NSUInteger)taps touches:(NSUInteger)touches action:(void (^) (id sender))action; 
{
    UITapGestureRecognizer *gesture = [UITapGestureRecognizer ibaGestureRecognizerWithActionBlock:^(UIGestureRecognizer* recognizer) {
        action([recognizer view]);
    }];
    
    [gesture setNumberOfTapsRequired:taps];
    [gesture setNumberOfTouchesRequired:touches];
    
    [[[self gestureRecognizers] ibaFilter:^BOOL(id gestureRecognizer) {
        return [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]
        && ((NSUInteger)[gestureRecognizer numberOfTouchesRequired] == touches)
        && ((NSUInteger)[gestureRecognizer numberOfTapsRequired] < taps);
    }] ibaEach:^(id tap_gesture_recognizer) {
        [gesture requireGestureRecognizerToFail:tap_gesture_recognizer];
    }];
    
    [self addGestureRecognizer:gesture];
    [gesture release];
}

- (void)ibaOnTap:(void (^) (id sender))action touches:(NSUInteger)touches; 
{
    [self ibaOnTaps:1 touches:touches action:action];
}

- (void)ibaOnDoubleTap:(void (^) (id sender))action touches:(NSUInteger)touches;
{
    [self ibaOnTaps:2 touches:touches action:action];
}


@end
