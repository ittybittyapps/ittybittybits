//
//  UIScrollView+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 23/06/11.
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

#import "UIScrollView+IBAExtensions.h"

#import "IBAUIKit.h"

@implementation UIScrollView (IBAExtensions)


/*!
 \brief     Adjusts the content and scrollIndicator insets for the specified \a coveringFrame.
 */
- (void)ibaAdjustInsetsForCoveringFrame:(CGRect)coveringFrame 
{
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect normalisedWindowBounds = IBACGRectForApplicationOrientation(keyWindow.bounds);
    CGRect normalisedTableViewFrame = IBACGRectForApplicationOrientation([self.superview convertRect:self.frame 
                                                                                              toView:keyWindow]);
    
    CGFloat height = (CGRectEqualToRect(coveringFrame, CGRectZero)) ? 0 : 
        coveringFrame.size.height - (normalisedWindowBounds.size.height - CGRectGetMaxY(normalisedTableViewFrame));
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, height, 0);

    [UIView animateWithDuration:0.3 
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations: ^{
                         self.contentInset = contentInsets;
                         self.scrollIndicatorInsets = contentInsets;
                     }
                     completion: ^(BOOL finished){
                     }];
}

@end
