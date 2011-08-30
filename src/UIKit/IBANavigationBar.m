//
//  IBANavigationBar.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 21/08/11.
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

#import "IBANavigationBar.h"
#import "../Foundation/IBAFoundation.h"

@implementation IBANavigationBar

IBA_SYNTHESIZE(landscapeBackgroundImage, portraitBackgroundImage);

/*!
 \brief     Draws the receiver’s image within the passed-in rectangle.
 \param     rect         The portion of the view’s bounds that needs to be updated.
 */
-(void)drawRect:(CGRect)rect
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation) && self.portraitBackgroundImage)
    {
        [self.portraitBackgroundImage drawInRect:rect];
    } 
    else if (UIInterfaceOrientationIsLandscape(orientation) && self.landscapeBackgroundImage)
    {
        [self.landscapeBackgroundImage drawInRect:rect];
    }
    else
    {
        [super drawRect:rect];
    }
}

/*!
 \brief     Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    IBA_RELEASE_PROPERTY(portraitBackgroundImage);
    IBA_RELEASE_PROPERTY(landscapeBackgroundImage);
    
    [super dealloc];
}

@end
