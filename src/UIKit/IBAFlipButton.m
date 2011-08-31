//
//  IBAFlipButton.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/08/11.
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

#import "IBAFlipButton.h"
#import "../Foundation/IBAFoundation.h"

@interface IBAFlipButton ()
- (id)commonInitialization NS_RETURNS_RETAINED;
- (void)touchUpInside:(id)sender forEvent:(UIEvent *)event;
@end

@implementation IBAFlipButton
{
    UIControlState customState;
}

IBA_SYNTHESIZE(animationDuration, flipDirection);

#pragma mark - Private Methods

- (id)commonInitialization
{
    self.animationDuration = 0.25;
    self.flipDirection = IBAFlipButtonDirectionFromLeft;
    customState = 0;
    
    [self addTarget:self action:@selector(touchUpInside:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)touchUpInside:(id)sender forEvent:(UIEvent *)event
{
    [self setFlipped:!self.flipped animated:YES];
}

#pragma mark - Public Methods

+ (IBAFlipButton *)flipButton
{
    // Is 44x44 reasonable default frame rect for a button?  Sounds good to me.
    return [self flipButtonWithFrame:CGRectMake(0, 0, 44, 44)];
}

+ (IBAFlipButton *)flipButtonWithFrame:(CGRect)frame
{
    return [[[self alloc] initWithFrame:frame] autorelease];
}

/*!
 \brief     Initializes and returns a newly allocated view object with the specified frame rectangle.
 \param     frame       The frame rectangle for the view, measured in points.
 \return    An initialized view object or nil if the object couldn't be created.
 */
- (id)initWithFrame:(CGRect)frame
{
    return [[super initWithFrame:frame] commonInitialization];
}

/*!
 \brief     Returns an object initialized from data in a given unarchiver. (required)
 \param     decoder     An unarchiver object.
 \return    self, initialized using the data in decoder.
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [[super initWithCoder:aDecoder] commonInitialization];
}

/*!
 \brief     A bit field that indicates the state of the receiver. 
 */
-(UIControlState)state
{
    return [super state] | customState;
}

- (BOOL)flipped
{
    return IBA_HAS_FLAG([self state], IBAFlipButtonControlStateFlipped);
}

/*!
 \brief     Sets a boolean value that indicates whether the control is flipped.
 \param     A boolean value that indicates whether the control is flipped.
 */
- (void)setFlipped:(BOOL)flipped
{
    [self setFlipped:flipped animated:NO];
}

/*!
 \brief     Sets a boolean value that indicates whether the control is flipped.
 \param     A boolean value that indicates whether the control is flipped.
 \param     A boolean value that indicates whether the control should animated the state change.
 */
- (void)setFlipped:(BOOL)flipped animated:(BOOL)animated
{
    // save the change in state to a block so we can reuse the logic later.
    IBAAction flipState = ^{
        customState = IBA_SET_FLAG(customState, IBAFlipButtonControlStateFlipped, flipped);
    };
    
    if (animated)
    {
        // do the flip animation
        [UIView transitionWithView:self
                          duration:self.animationDuration
                           options:(self.flipDirection == IBAFlipButtonDirectionFromLeft ?  UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight) | UIViewAnimationOptionAllowAnimatedContent
                        animations:^{
                            flipState();
                        }
                        completion:nil];
    }
    else
    {
        flipState();
    }
}

@end
