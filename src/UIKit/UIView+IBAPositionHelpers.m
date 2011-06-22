//
//  UIView+IBAPositionHelpers.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 22/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "UIView+IBAPositionHelpers.h"


@implementation UIView (IBAPositionHelpers)

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

@end
