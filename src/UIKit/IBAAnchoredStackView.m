//
//  IBAAnchoredStackView.m
//  IttyBittyBits
//
//  Created by Sam Page on 23/11/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "IBAAnchoredStackView.h"

@interface IBAAnchoredStackView()
{
@private
	IBAAnchoredStackViewAnchor defaultAnchor;
    CGFloat offsetTop;
	CGFloat offsetBottom;
	CGFloat offsetLeft;
	CGFloat offsetRight;
	CGFloat occupiedWidth;
	CGFloat occupiedHeight;
	CGFloat frameWidth;
	CGFloat frameHeight;
}
@end

@implementation IBAAnchoredStackView
@synthesize minimumSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		defaultAnchor = IBAAnchoredStackViewTop;
        offsetTop = 0.0f;
		offsetBottom = 0.0f;
		offsetLeft = 0.0f;
		offsetRight = 0.0f;
		frameWidth = 0.0f;
		frameHeight = 0.0f;
		minimumSize = CGSizeMake(0.0f, 0.0f);
    }
    return self;
}

- (void)addSubview:(UIView *)view
{
	[self addSubview:view anchorTo:defaultAnchor padding:0.0f];
}

- (void)addSubview:(UIView *)view anchorTo:(IBAAnchoredStackViewAnchor)anchor
{
	[self addSubview:view anchorTo:anchor padding:0.0f];
}

- (void)addSubview:(UIView *)view anchorTo:(IBAAnchoredStackViewAnchor)anchor padding:(CGFloat)padding
{
	CGPoint centerPoint;
	
	switch (anchor) {
		case IBAAnchoredStackViewLeft:
			// TODO: Code me
			break;
		case IBAAnchoredStackViewRight:
			// TODO: Code me
			break;
		case IBAAnchoredStackViewBottom:
			occupiedHeight += view.frame.size.height + padding;
			occupiedWidth = view.frame.size.width > frameWidth ? view.frame.size.width : frameWidth;		
			centerPoint = CGPointMake(view.center.x, frameHeight - (view.frame.size.height / 2.0f) - offsetBottom - padding);
			offsetBottom += (view.frame.size.height + padding);
			[view setCenter:centerPoint];
			break;
		case IBAAnchoredStackViewTop:
			default:
			occupiedHeight += view.frame.size.height + padding;
			occupiedWidth = view.frame.size.width > frameWidth ? view.frame.size.width : frameWidth;	
			centerPoint = CGPointMake(view.center.x, view.center.y + offsetTop + padding);
			offsetTop += (view.frame.size.height + padding);
			[view setCenter:centerPoint];		
			break;
	}
	
	frameWidth = occupiedWidth > minimumSize.width ? occupiedWidth : minimumSize.width;
	frameHeight = occupiedHeight > minimumSize.height ? occupiedHeight : minimumSize.height;
	
	[self setFrame:CGRectMake(self.frame.origin.x, 
							  self.frame.origin.y, 
							  frameWidth, 
							  frameHeight)];
	
	[super addSubview:view];
}

@end
