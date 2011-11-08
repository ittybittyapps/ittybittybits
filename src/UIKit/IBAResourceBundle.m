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

@interface IBAResourceBundle ()
+ (NSArray *)imageExtensions;
- (NSString *)resolveResourceName:(NSString *)name;
@end

@implementation IBAResourceBundle
{
    NSBundle *bundle;
    NSCache *cache;
    NSDictionary *resources;
}

+ (NSArray *)imageExtensions
{
    static NSArray *extensions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        extensions = IBA_NSARRAY(@"png", @"PNG", @"jpg", @"JPG", @"jpeg", @"JPEG");
    });
    
    return extensions;
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

- (NSString *)resolveResourceName:(NSString *)name
{
    int count = 0;
    do {
        id object = [resources objectForKey:name];
        if (object && [object isKindOfClass:[NSString class]])
        {
            if ([object hasPrefix:@"$"])
            {
                name = [object substringFromIndex:1];
            }
            else
            {
                name = object;
                break;
            }
        }
    }
    while (++count < 100);
        
    if (count >= 100)
    {
        IBALogError(@"Broke out of possible resource redirection loop for resource named: %@", name);
    }

    return name;
}

- (BOOL)hasResourceNamed:(NSString *)name
{
    return [resources objectForKey:[self resolveResourceName:name]] != nil;
}

- (NSString *)stringNamed:(NSString *)name
{
    NSString *string = nil;
    name = [self resolveResourceName:name];
    if (name)
    {
        string = (NSString  *)[cache objectForKey:name];
        if (string == nil)
        {
            id resource = [resources valueForKey:name];
            if ([resource isKindOfClass:[NSString class]])
            {
                string = resource;
            }
            else
            {
                string = [resource description];
            }

            [cache setObject:string forKey:name cost:[string lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]];
        }
    }
    
    return string;
}

- (NSData *)dataNamed:(NSString *)name
{
    NSData *data = nil;
    name = [self resolveResourceName:name];
    if (name)
    {
        id resource = [resources objectForKey:name];
        if ([resource isKindOfClass:[NSData class]])
        {
            data = resource;
        }
        else if ([resource isKindOfClass:[NSString class]])
        {
            NSString *path = [bundle pathForResource:resource ofType:nil];
            if (path)
            {
                data = [NSData dataWithContentsOfMappedFile:path];
            }
            else
            {
                IBALogError(@"Unable to load NSData resource named '%@' from file: %@", name, path);
            }
        }
    }
    
    return data;
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
            NSString *path = [bundle pathForResource:formattedPath ofType:ext];    
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

- (CGSize)sizeNamed:(NSString *)name
{
    CGSize size = CGSizeZero;    
    name = [self resolveResourceName:name];
    if (name)
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
                size = CGSizeFromString((NSString *)resource);
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
    name = [self resolveResourceName:name];
    if (name)
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
                rect =  CGRectFromString((NSString *)resource);
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
    CGPoint point = CGPointZero;
    name = [self resolveResourceName:name];
    if (name)
    {
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
                point = CGPointFromString((NSString *)resource);
            }
            
            value = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
            [cache setObject:value forKey:name cost:sizeof(CGPoint)];
        }
        else
        {
            [value getValue:&point];
        }
    }

    return point;
}

@end
