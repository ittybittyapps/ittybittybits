//
//  IBAResourceBundle+UIKit.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 14/11/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
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

#import "IBAResourceBundle+UIKit.h"

#import "../Foundation/IBAFoundation.h"
#import "../Foundation/IBAResourceBundle+Internal.h"

#import "UIColor+IBAExtensions.h"

#import <objc/runtime.h>

@implementation IBAResourceBundle (UIKit)

+ (NSArray *)imageExtensions
{
    static NSArray *extensions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        extensions = [IBA_NSARRAY(@"png", @"PNG", @"jpg", @"JPG", @"jpeg", @"JPEG") retain];
    });
    
    return extensions;
}

- (UIImage *)imageNamed:(NSString *)name
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    UIImage *image = nil;
    NSString *resource = [self stringNamed:name];    
    resource = resource ? resource : name;
    
    if (resource)
    {
        NSArray *extentions = [[self class] imageExtensions];
        NSString *pathExt = [resource pathExtension];
        if (pathExt && [pathExt ibaNotBlank])
        {
            extentions = IBA_NSARRAY(pathExt);
        }
        
        NSString *pathWithoutExt = [resource stringByDeletingPathExtension];
        
        for (NSString *ext in extentions) 
        {
            NSString *formattedPath = [NSString stringWithFormat:@"%@%@", pathWithoutExt, (scale == 2.0 ? @"@2x" : @"")]; 
            NSString *path = [self.bundle pathForResource:formattedPath ofType:ext];    
            if (path)
            {
                image = [UIImage imageWithContentsOfFile:path];
            }
        }
    }
    
    return image;
}

- (UIColor *)colorNamed:(NSString *)name
{
    UIColor *color = nil;
    name = [self resolveResourceName:name];
    if (name)
    {
        color = (UIColor  *)[self.cache objectForKey:name];
        if (color == nil)
        {
            id<NSObject> colorResource = [self.resources valueForKeyPath:name];
            if ([colorResource isKindOfClass:[NSNumber class]])
            {
                color = [UIColor ibaColorWithRGBHex:[((NSNumber*)colorResource) unsignedIntValue]];
            }
            else if ([colorResource isKindOfClass:[NSString class]])
            {
                NSString *colorAsString = (NSString *)colorResource;
                
                // try matching against predefined CSS color names.
                color = [UIColor ibaColorWithCSSName:colorAsString];
                if (color == nil)
                {
                    // try css rgb() style encoding
                    color = [UIColor ibaColorWithCSSRGB:colorAsString];
                    if (color == nil)
                    {
                        // try using HTML style string encoding
                        color = [UIColor ibaColorWithHTMLHex:colorAsString];
                        if (color == nil)
                        {
                            IBALogError(@"Failed to load UIColor resource with name: %@", name);
                        }
                    }
                }
            }
            
            if (color)
            {
                [self.cache setObject:color forKey:name cost:class_getInstanceSize([UIColor class])];
            }
        }
    }
    
    return color;
}

- (UIColor *)colorWithPatternNamed:(NSString *)name
{
    UIColor *color = nil;
    name = [self resolveResourceName:name];
    if (name)
    {
        UIImage *pattern = [self imageNamed:name];
        if (pattern)
        {
            color = [UIColor colorWithPatternImage:pattern];
        }
        
        if (color)
        {
            [self.cache setObject:color forKey:name cost:class_getInstanceSize([UIColor class])];
        }
    }
    
    return color;
}

- (UIFont *)fontNamed:(NSString *)name
{
    UIFont *font = nil;
    name = [self resolveResourceName:name];
    if (name)
    {
        id resource = [self.resources valueForKeyPath:name];
        if ([resource isKindOfClass:[NSDictionary class]])
        {
            NSString *faceName = [self stringNamed:[NSString stringWithFormat:@"%@.face", name]];
            NSNumber *size = [self numberNamed:[NSString stringWithFormat:@"%@.size", name]];
            
            font = [UIFont fontWithName:faceName size:[size floatValue]];
        }
        else if ([resource isKindOfClass:[NSString class]])
        {
            font = [UIFont fontWithName:[self stringNamed:name] size:[UIFont systemFontSize]];
        }
    }
    
    return font;
}

@end
