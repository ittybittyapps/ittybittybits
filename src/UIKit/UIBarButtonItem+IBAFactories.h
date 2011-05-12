//
//  Factories.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 12/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIBarButtonItem (Factories)

+ (UIBarButtonItem *)flexibleSpace;
+ (UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width;

@end
