//
//  IBAViewController.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/08/11.
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

#import "IBAViewController.h"
#import "../Foundation/IBAFoundation.h"

@implementation IBAViewController

/*!
 \brief     Basic factory method for IBAViewController subclasses.
 \return    Returns an autoreleased instance of the IBAViewController subclass.
 */
+ (id)controller
{
    return [[[self alloc] initWithNibName:[self nibName] bundle:[self bundle]] autorelease];
}

/*!
 \brief     Subclasses can override this method to return the name of the nib to load.
 \return    The name of the NIB to load.
 */
+ (NSString *)nibName
{
    return nil;
}

/*!
 \brief     Subclass can override this method to return the bundle to load the nib from.
 \return    The bundle to load the NIB from.
 */
+ (NSBundle *)bundle
{
    return nil;
}

IBA_SYNTHESIZE(delegate);

/*!
 \brief     Subclasses should override this method to release their views by clearing outlets that point to views in their view heirarchy (not by clearing self.view)
 \details   This method is called from both dealloc and viewDidUnload.
 */
- (void)releaseViews
{
}

/*
 Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    IBA_NIL_PROPERTY(delegate);
    [self releaseViews];
    [super dealloc];
}

/*!
 \brief     Called when the controller’s view is released from memory.
 \note      Subclasses should always call viewDidUnload on their super.
 */
- (void)viewDidUnload
{
    [self releaseViews];
    [super viewDidUnload];
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(viewController:willPresentModalViewController:animated:)])
    {
        [self.delegate viewController:self willPresentModalViewController:modalViewController animated:animated];
    }
    
    [super presentModalViewController:modalViewController animated:animated];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    UIViewController *modalViewController = [self.modalViewController retain];
    [super dismissModalViewControllerAnimated:animated];
    
    if ([self.delegate respondsToSelector:@selector(viewController:didDismissModalViewController:animated:)])
    {
        [self.delegate viewController:self didDismissModalViewController:modalViewController animated:animated];
    }
    
    [modalViewController release];
}

@end
