//
//  IBAThemeBundle.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 25/08/11.
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

#import "IBAThemeBundle.h"
#import "../Foundation/IBAFoundation.h"

#import "UIColor+IBAExtensions.h"

@implementation IBAThemeBundle
{
    NSBundle *bundle;
    NSCache *cache;
    NSDictionary *resources;
}

/*!
 \brief     Initialize the theme bundle with a bundle of the specified \a name.
 */
- (id)initWithBundleName:(NSString*)name
{
    if ((self = [super init])) 
    {
        cache = [[NSCache alloc] init];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"bundle"];
        bundle = [[NSBundle bundleWithPath:path] retain];
        if (bundle == nil)
        {
            IBALogError(@"Unable to find bundle named '%@' (%@).", name, path);
        }
        
        NSString *resourcePlistPath = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"plist"];
        resources = [[NSDictionary dictionaryWithContentsOfFile:resourcePlistPath] retain];
        if (resources == nil)
        {
            IBALogError(@"Failed to load Resources.plist from bundle '%@'.", name);
        }
        
        if (bundle == nil || resources == nil)
        {
            IBA_RELEASE(self);
        }
    }
    
    return self;
}

/*
 Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    IBA_RELEASE(bundle);
    IBA_RELEASE(resources);
    IBA_RELEASE(cache);
    
    [super dealloc];
}

- (UIColor *)colorNamed:(NSString *)name
{
    if ([self hasColorNamed:name])
    {
        UIColor *color = (UIColor  *)[cache objectForKey:name];
        if (color == nil)
        {
            id<NSObject> colorResource = [resources valueForKey:name];
            if ([colorResource isKindOfClass:[NSNumber class]])
            {
                color = [UIColor ibaColorWithRGBHex:[((NSNumber*)colorResource) unsignedIntValue]];
            }
            else if ([colorResource isKindOfClass:[NSString class]])
            {
                NSString *colorAsString = (NSString *)colorResource;
                
                // try using HTML style string encoding first
                color = [UIColor ibaColorWithHTMLHex:colorAsString];
                if (color == nil)
                {
                    // try css rgb() style encoding now.
                    color = [UIColor ibaColorWithCSSRGB:colorAsString];
                    
                    if (color == nil)
                    {
                        // try matching against predefined CSS color names.
                        color = [UIColor ibaColorWithCSSName:colorAsString];
                    }
                }
            }
            
            [cache setObject:color forKey:name];
        }
        
        return color;
    }
    
    return nil;
}

- (UIImage *)imageNamed:(NSString *)name
{
    return nil;
}

- (CGSize)sizeNamed:(NSString *)name
{
    return CGSizeZero;
}

- (CGRect)rectNamed:(NSString *)name
{
    return CGRectZero;
}

- (CGPoint)pointNamed:(NSString *)name
{
    return CGPointZero;
}

- (UIFont *)fontNamed:(NSString *)font
{
    return nil;
}

- (BOOL)hasColorNamed:(NSString *)name
{
    return [resources valueForKey:name] != nil;
}

- (BOOL)hasImageNamed:(NSString *)name
{
    return NO;
}

- (BOOL)hasSizeNamed:(NSString *)name
{
    return NO;
}

- (BOOL)hasRectNamed:(NSString *)name
{
    return NO;
}

- (BOOL)hasPointNamed:(NSString *)name
{
    return NO;
}

- (BOOL)hasFontNamed:(NSString *)name
{
    return NO;
}

@end
