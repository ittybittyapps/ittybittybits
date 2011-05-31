//
//  Factories.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 12/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//
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

#import "UIBarButtonItem+IBAFactories.h"


@implementation UIBarButtonItem (IBAFactories)

/*!
 \brief     Factory method that creates an autoreleased flexible space bar item.
 */
+ (UIBarButtonItem *)ibaFlexibleSpace 
{
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
}

/*!
 \brief     Factory method that creates an autoreleased fixed space bar item.
 */
+ (UIBarButtonItem *)ibaFixedSpaceWithWidth:(CGFloat)width
{
    UIBarButtonItem *item = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    item.width = width;
    return item;
}

@end
