//
//  IBAFlipButton.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/08/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    IBAFlipButtonDirectionFromLeft,
    IBAFlipButtonDirectionFromRight
} IBAFlipButtonDirection;

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

@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) IBAFlipButtonDirection flipDirection;
@property (nonatomic, assign) BOOL flipped;

- (void)setFlipped:(BOOL)flipped animated:(BOOL)animated;

@end
