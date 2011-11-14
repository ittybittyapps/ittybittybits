//
//  IBAResourceBundle+CoreGraphics.m
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

#import "IBAResourceBundle+CoreGraphics.h"
#import "IBAResourceBundle+Internal.h"

#import "../Foundation/IBALogger.h"

@implementation IBAResourceBundle (CoreGraphics)

- (CGSize)sizeNamed:(NSString *)name
{
    CGSize size = CGSizeZero;    
    name = [self resolveResourceName:name];
    if (name)
    {
        NSValue *value = [self.cache objectForKey:name];
        if (value == nil)
        {
            id resource = [self.resources valueForKey:name];
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
            [self.cache setObject:value forKey:name cost:sizeof(CGSizeZero)];
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
        NSValue *value = [self.cache objectForKey:name];
        if (value == nil)
        {
            id resource = [self.resources valueForKey:name];
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
            [self.cache setObject:value forKey:name cost:sizeof(CGRect)];
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
        NSValue *value = [self.cache objectForKey:name];
        if (value == nil)
        {
            id resource = [self.resources valueForKey:name];
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
            [self.cache setObject:value forKey:name cost:sizeof(CGPoint)];
        }
        else
        {
            [value getValue:&point];
        }
    }
    
    return point;
}

@end
