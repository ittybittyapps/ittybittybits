//
//  IBAResourceBundle.m
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

#import "IBAResourceBundle.h"
#import "../Foundation/IBAFoundation.h"

#import "UIColor+IBAExtensions.h"

static NSString * const kSizeWidthKey = @"width";
static NSString * const kSizeHeightKey = @"height";
static NSString * const kPointXKey = @"x";
static NSString * const kPointYKey = @"y";
static NSString * const kRectSizeKey = @"size";
static NSString * const kRectOriginKey = @"origin";
static NSString * const kStructElementSeparators = @"\t ,|:;";

@implementation IBAResourceBundle
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
        
        NSString *resourcePlistPath = [bundle pathForResource:@"Resources" ofType:@"plist"];
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
    UIColor *color = nil;
    if ([self hasResourceNamed:name])
    {
        color = (UIColor  *)[cache objectForKey:name];
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
                
                // Handle property redirects.
                if ([colorAsString hasPrefix:@"$"])
                {
                    color = [self colorNamed:[colorAsString substringFromIndex:1]];
                }
                else
                {
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
            }
            
            [cache setObject:color forKey:name];
        }
    }
    
    return color;
}

- (UIImage *)imageNamed:(NSString *)name
{
    return nil;
}

- (CGSize)sizeNamed:(NSString *)name
{
    CGSize size = CGSizeZero;
    if ([self hasResourceNamed:name])
    {
        NSValue *value = [cache objectForKey:name];
        if (value == nil)
        {
            id resource = [resources valueForKey:name];
            if ([resource isKindOfClass:[NSDictionary class]])
            {
                if (CGSizeMakeWithDictionaryRepresentation((CFDictionaryRef)resource, &size) == NO)
                {
                    IBALogError(@"Failed to make CGSize from dictionary representation for resource named '%@'.", name);
                    size = CGSizeZero;
                }
            }
            else if ([resource isKindOfClass:[NSString class]])
            {
                size = [resource hasPrefix:@"$"] ? [self sizeNamed:[resource substringFromIndex:1]] : CGSizeFromString((NSString *)resource);
            }
            
            value = [NSValue valueWithBytes:&size objCType:@encode(CGSize)];
            [cache setObject:value forKey:name cost:sizeof(CGSizeZero)];
        }
        else
        {
            [value getValue:&size];
        }
    }
    
    return size;
}

- (CGRect)rectNamed:(NSString *)name
{
    CGRect rect = CGRectZero;
    
    if ([self hasResourceNamed:name])
    {
        NSValue *value = [cache objectForKey:name];
        if (value == nil)
        {
            id resource = [resources valueForKey:name];
            if ([resource isKindOfClass:[NSDictionary class]])
            {
                if (CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)resource, &rect) == NO)
                {
                    IBALogError(@"Failed to make CGRect from dictionary representation for resource named '%@'.", name);
                    rect = CGRectZero;
                }
            }
            else if ([resource isKindOfClass:[NSString class]])
            {
                rect =  [resource hasPrefix:@"$"] ? [self rectNamed:[resource substringFromIndex:1]] : CGRectFromString((NSString *)resource);
            }
            
            value = [NSValue valueWithBytes:&rect objCType:@encode(CGRect)];
            [cache setObject:value forKey:name cost:sizeof(CGRect)];
        }
        else
        {
            [value getValue:&rect];
        }
    }

    return rect;
}

- (CGPoint)pointNamed:(NSString *)name
{
    if ([self hasResourceNamed:name])
    {
        CGPoint point = CGPointZero;
        
        NSValue *value = [cache objectForKey:name];
        if (value == nil)
        {
            id resource = [resources valueForKey:name];
            if ([resource isKindOfClass:[NSDictionary class]])
            {
                if (CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)resource, &point) == NO)
                {
                    IBALogError(@"Failed to make CGPoint from dictionary representation for resource named '%@'.", name);
                    point = CGPointZero;
                }
            }
            else if ([resource isKindOfClass:[NSString class]])
            {
                point = [resource hasPrefix:@"$"] ? [self pointNamed:[resource substringFromIndex:1]] : CGPointFromString((NSString *)resource);
            }
            
            value = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
            [cache setObject:value forKey:name cost:sizeof(CGPoint)];
        }
        else
        {
            [value getValue:&point];
        }
        
        return point;
    }

    return CGPointZero;
}

- (UIFont *)fontNamed:(NSString *)font
{
    return nil;
}

- (BOOL)hasResourceNamed:(NSString *)name
{
    return [resources valueForKey:name] != nil;
    // TODO: deal with files.
}

@end
