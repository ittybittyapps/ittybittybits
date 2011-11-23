//
//  IBAAnchoredStackView.h
//  IttyBittyBits
//
//  Created by Sam Page on 23/11/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	IBAAnchoredStackViewLeft,
	IBAAnchoredStackViewRight,
	IBAAnchoredStackViewBottom,
	IBAAnchoredStackViewTop,
} IBAAnchoredStackViewAnchor;

@interface IBAAnchoredStackView : UIView

@property (nonatomic, assign) CGSize minimumSize;

- (void)addSubview:(UIView *)view anchorTo:(IBAAnchoredStackViewAnchor)anchor;
- (void)addSubview:(UIView *)view anchorTo:(IBAAnchoredStackViewAnchor)anchor padding:(CGFloat)padding;

@end
