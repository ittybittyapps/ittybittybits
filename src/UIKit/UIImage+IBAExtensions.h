//
//  UIImage+IBAExtensions.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 19/08/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IBAExtensions)

+ (UIImage *)ibaImageWithContentsOfFile:(NSString *)imageBaseName scale:(CGFloat)scale;

@end
