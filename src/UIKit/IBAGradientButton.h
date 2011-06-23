//
//  IBAGradientButton.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 23/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IBAGradientButton : UIButton 
{  
}

@property (copy) NSArray *colors;
@property (copy) NSArray *locations;
@property (assign) CGPoint startPoint;
@property (copy) NSString *type;

@end
