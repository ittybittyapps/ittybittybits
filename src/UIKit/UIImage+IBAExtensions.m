//
//  UIImage+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 19/08/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "UIImage+IBAExtensions.h"

@implementation UIImage (IBAExtensions)

+ (UIImage *)ibaImageWithContentsOfFile:(NSString *)imageBaseName scale:(CGFloat)scale
{
    NSString *filename = imageBaseName;
    if (scale > 1.0)
    {
        NSString *filenameWithoutExtension = [imageBaseName stringByDeletingPathExtension];
        
        NSString *filenameForScale = [NSString stringWithFormat:@"%@@%.0fx%@", 
                                      filenameWithoutExtension, 
                                      floorf(scale), 
                                      [imageBaseName substringFromIndex:[filenameWithoutExtension length]]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filenameForScale])
        {
            filename = filenameForScale;
        }
    }
    
    return [UIImage imageWithContentsOfFile:filename];
}

@end
