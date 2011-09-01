//
//  IBAFlipButton.h
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

#import <UIKit/UIKit.h>

/*!
 \brief     The type of flip to perform.
 */
typedef enum 
{
    
    IBAFlipButtonFlipTypeDefault,   //!< Flip the entire button over.
    IBAFlipButtonFlipTypeImageOnly  //!< Flip only the image on the button.
} IBAFlipButtonFlipType;

/*!
 \brief     The direction in which to flip the button.
 */
typedef enum
{
    IBAFlipButtonDirectionFromLeft,     //!< Flip from the left edge
    IBAFlipButtonDirectionFromRight     //!< Flip from the right edge
} IBAFlipButtonDirection;

/*!
 \brief     Additional UIControlStates for the IBAFlipButton.
 */
typedef enum
{
    IBAFlipButtonControlStateFlipped = ((1 << 16 ) & UIControlStateApplication)
} IBAFlipButtonControlState;

/*!
 \brief     An IBAFlipButton is a button that has two sides.  When pressed it flips over exposing the back side.  When pressed again it flips over again presenting the front side.
 */
@interface IBAFlipButton : UIButton

+ (IBAFlipButton *)flipButton;
+ (IBAFlipButton *)flipButtonWithFrame:(CGRect)frame;

@property (nonatomic, assign) IBAFlipButtonFlipType flipType;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) IBAFlipButtonDirection flipDirection;
@property (nonatomic, assign) BOOL flipped;

- (void)setFlipped:(BOOL)flipped animated:(BOOL)animated;

@end
