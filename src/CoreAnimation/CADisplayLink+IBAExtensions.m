//
//  CADisplayLink+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 7/09/11.
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

#import "CADisplayLink+IBAExtensions.h"
#import <objc/runtime.h>

static void *kAssociatedBlockKey = 0;

#pragma mark -
#pragma mark Private Interface

@interface CADisplayLink (IBAExtensionsPrivate)
+ (void)iba_executeBlockWithDisplayLink:(CADisplayLink *)displayLink;
@end

#pragma mark -
#pragma mark Private Implmention

@implementation CADisplayLink (IBAExtensionsPrivate)

+ (void)iba_executeBlockWithDisplayLink:(CADisplayLink *)displayLink
{
    IBADisplayLinkBlock block = (IBADisplayLinkBlock)objc_getAssociatedObject(displayLink, &kAssociatedBlockKey);
    if (block)
    {
        block(displayLink);
    }
}

@end

@implementation CADisplayLink (IBAExtensions)

/*!
 \brief     Returns a new display link.
 \param     block   A block to be called when the screen should be updated.
 \return    A newly constructed display link.
 */
+ (CADisplayLink *)ibaDisplayLinkWithBlock:(IBADisplayLinkBlock)block
{
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(iba_executeBlockWithDisplayLink:)];
    objc_setAssociatedObject(displayLink, &kAssociatedBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return displayLink;
}

@end
