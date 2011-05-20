//
//  UISearchBar+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 20/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "UISearchBar+IBAExtensions.h"


@implementation UISearchBar (IBAExtensions)

/*!
 \brief     Gets the Cancel button from the UISearchBar's view hierarchy.
 */
- (UIButton *) ibaCancelButton
{
    for (UIView *v in self.subviews) 
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            UIButton *b = (UIButton *)v;
            return b;
        }
    }
    
    return nil;
}

@end
