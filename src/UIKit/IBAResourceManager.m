//
//  IBAResourceManager.m
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

#import "IBAResourceManager.h"
#import "IBAResourceBundle.h"

#import "../Foundation/IBAFoundation.h"

@implementation IBAResourceManager
{
    IBAStack *bundleStack;
}

IBA_SYNTHESIZE_SINGLETON_FOR_CLASS(IBAResourceManager, sharedInstance);

- (id)init
{
    if ((self = [super init]))
    {
        bundleStack = [[IBAStack alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    IBA_RELEASE(bundleStack);
    
    [super dealloc];
}

- (void)pushResourceBundle:(IBAResourceBundle *)bundle
{
    [bundleStack pushObject:bundle];
}

- (void)popResourceBundle
{
    [bundleStack popObject];
}

- (UIColor *)colorNamed:(NSString *)name
{
    for (IBAResourceBundle *bundle in bundleStack) 
    {
        if ([bundle hasResourceNamed:name])
        {
            return [bundle colorNamed:name];
        }
    }
    
    return nil;
}

- (UIImage *)imageNamed:(NSString *)name
{
    for (IBAResourceBundle *bundle in bundleStack) 
    {
        if ([bundle hasResourceNamed:name])
        {
            return [bundle imageNamed:name];
        }
    }
    
    return nil;
}

- (UIFont *)fontNamed:(NSString *)name
{
    for (IBAResourceBundle *bundle in bundleStack) 
    {
        if ([bundle hasResourceNamed:name])
        {
            return [bundle fontNamed:name];
        }
    }
    
    return nil;
}

- (CGSize)sizeNamed:(NSString *)name
{
    for (IBAResourceBundle *bundle in bundleStack) 
    {
        if ([bundle hasResourceNamed:name])
        {
            return [bundle sizeNamed:name];
        }
    }
    
    return CGSizeZero;
}

- (CGRect)rectNamed:(NSString *)name
{
    for (IBAResourceBundle *bundle in bundleStack) 
    {
        if ([bundle hasResourceNamed:name])
        {
            return [bundle rectNamed:name];
        }
    }
    
    return CGRectZero;
}

- (CGPoint)pointNamed:(NSString *)name
{
    for (IBAResourceBundle *bundle in bundleStack) 
    {
        if ([bundle hasResourceNamed:name])
        {
            return [bundle pointNamed:name];
        }
    }
    
    return CGPointZero;
}

@end
