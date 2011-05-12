//
//  Factories.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 12/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "UIBarButtonItem+IBAFactories.h"


@implementation UIBarButtonItem (IBAFactories)

/*!
 \brief     Factory method that creates an autoreleased flexible space bar item.
 */
+ (UIBarButtonItem *)flexibleSpace 
{
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
}

/*!
 \brief     Factory method that creates an autoreleased fixed space bar item.
 */
+ (UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width
{
    UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    item.width = width;
    return item;
}

@end
