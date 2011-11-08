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

- (void)pushResourceBundleNamed:(NSString *)bundleName
{
    IBAAssertNotNilOrEmptyString(bundleName);
    [self pushResourceBundle:[IBAResourceBundle bundleNamed:bundleName]];
}

- (void)pushResourceBundle:(IBAResourceBundle *)bundle
{
    IBAAssertNotNil(bundle);
    [bundleStack pushObject:bundle];
}

- (void)popResourceBundle
{
    [bundleStack popObject];
}

#define X(name, type, default) \
- (type)name##Named:(NSString *)name \
{ \
    for (IBAResourceBundle *bundle in bundleStack) \
    { \
        if ([bundle hasResourceNamed:name]) { \
            type resource = (type)[bundle name##Named:name]; \
            return resource; \
        } \
    } \
    return (default); \
}

X(color, UIColor *, nil)
X(image, UIImage *, nil)
X(size, CGSize, CGSizeZero)
X(rect, CGRect, CGRectZero)
X(point, CGPoint, CGPointZero)
X(string, NSString *, nil)
X(data, NSData *, nil)
#undef X

@end
