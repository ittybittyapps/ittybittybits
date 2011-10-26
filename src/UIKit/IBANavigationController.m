//
//  IBANavigationController.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 18/10/11.
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

#import "IBANavigationController.h"

@implementation IBANavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *popped = [super popViewControllerAnimated:animated];
    if ([self.delegate respondsToSelector:@selector(navigationController:didPopViewController:animated:)])
    {
        [((id<IBANavigationControllerDelegate>)self.delegate) navigationController:self didPopViewController:popped animated:animated];
    }
    
    return popped;
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(viewController:willPresentModalViewController:animated:)])
    {
        [((id<IBAViewControllerDelegate>)self.delegate) viewController:self 
                                        willPresentModalViewController:modalViewController 
                                                              animated:animated];
    }
    
    [super presentModalViewController:modalViewController animated:animated];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    UIViewController *modalViewController = [self.modalViewController retain];
    [super dismissModalViewControllerAnimated:animated];
    
    if ([self.delegate respondsToSelector:@selector(viewController:didDismissModalViewController:animated:)])
    {
        [((id<IBAViewControllerDelegate>)self.delegate) viewController:self 
                                         didDismissModalViewController:modalViewController 
                                                              animated:animated];
    }
    
    [modalViewController release];
}

@end
