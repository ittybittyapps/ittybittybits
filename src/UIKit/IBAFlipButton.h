//
//  IBAFlipButton.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/08/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 The side of an IBAFlipButton.
 */
typedef enum 
{
    IBAFlipButtonSideFront,
    IBAFlipButtonSideBack
} IBAFlipButtonSide;

typedef enum
{
    IBAFlipButtonDirectionFromLeft,
    IBAFlipButtonDirectionFromRight
} IBAFlipButtonDirection;

/*!
 \brief     An IBAFlipButton is a button that has two sides.  When pressed it flips over exposing the back side.  When pressed again it flips over again presenting the front side.
 */
@interface IBAFlipButton : UIButton

+ (IBAFlipButton *)flipButton;
+ (IBAFlipButton *)flipButtonWithFrame:(CGRect)frame;

- (void)configureButtonsWithBlock:(void (^)(IBAFlipButtonSide side, UIButton *button))block;

@property (nonatomic, assign, readonly) IBAFlipButtonSide currentSide;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) IBAFlipButtonDirection flipDirection;

@end
