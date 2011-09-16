//
//  IBADisclosureControl.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 4/07/11.
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

#import "IBATableViewAccessory.h"
#import "../Foundation/IBAFoundation.h"

@implementation IBATableViewAccessory

IBA_SYNTHESIZE(accessoryColor, highlightedColor);

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
		self.backgroundColor = [UIColor clearColor];
        self.accessoryColor = [UIColor blackColor];
        self.highlightedColor = [UIColor whiteColor];
    }
    
    return self;
}

/*!
 Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    IBA_RELEASE_PROPERTY(accessoryColor);
    IBA_RELEASE_PROPERTY(highlightedColor);
    
    [super dealloc];
}

+ (id)accessoryWithColor:(UIColor *)color
{
	IBATableViewAccessory *ret = [[[IBATableViewAccessory alloc] initWithFrame:CGRectMake(0, 0, 11.0, 15.0)] autorelease];
	ret.accessoryColor = color;
    
	return ret;
}

/*!
 Draws the receiver’s image within the passed-in rectangle.
 */
- (void)drawRect:(CGRect)rect
{
	const CGFloat R = 4.5;
	CGContextRef ctxt = UIGraphicsGetCurrentContext();
    
	// (x,y) is the tip of the arrow
	CGFloat x = CGRectGetMaxX(self.bounds)-3.0f;
	CGFloat y = CGRectGetMidY(self.bounds);

	CGContextMoveToPoint(ctxt, x-R, y-R);
	CGContextAddLineToPoint(ctxt, x, y);
	CGContextAddLineToPoint(ctxt, x-R, y+R);
	CGContextSetLineCap(ctxt, kCGLineCapSquare);
	CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
	CGContextSetLineWidth(ctxt, 3);
    
	if (self.highlighted)
	{
		[self.highlightedColor setStroke];
	}
	else
	{
		[self.accessoryColor setStroke];
	}
    
	CGContextStrokePath(ctxt);
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
    
	[self setNeedsDisplay];
}

@end
