//
//  IBAFlipViewController.m
//  IttyBittyBits
//
//  Created by Jason Morrissey on 20/10/11.
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

#import "IBAFlipViewController.h"

@implementation IBAFlipViewController

IBA_SYNTHESIZE(flipped,
               frontViewCoordinator,
               backViewCoordinator,
               animateBlockDuringFlip);

- (void)dealloc
{
    IBA_RELEASE_PROPERTY(frontViewCoordinator,
                         backViewCoordinator,
                         animateBlockDuringFlip);
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.frontViewCoordinator.view.frame = self.view.bounds;
    self.backViewCoordinator.view.frame = self.view.bounds;
    
    id<IBAFlipViewSideProtocol> frontFacingCoordinator = (self.flipped) ? self.backViewCoordinator : self.frontViewCoordinator;
    [self.view addSubview:frontFacingCoordinator.view];
}

#pragma mark - View Management

- (void)viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    id<IBAFlipViewSideProtocol> frontFacingCoordinator = (self.flipped) ? self.backViewCoordinator : self.frontViewCoordinator;
    if ([frontFacingCoordinator respondsToSelector:@selector(flipSideWillAppear)])
        [frontFacingCoordinator flipSideWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    id<IBAFlipViewSideProtocol> frontFacingCoordinator = (self.flipped) ? self.backViewCoordinator : self.frontViewCoordinator;
    if ([frontFacingCoordinator respondsToSelector:@selector(flipSideWillDisappear)])
        [frontFacingCoordinator flipSideWillDisappear];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    id<IBAFlipViewSideProtocol> frontFacingCoordinator = (self.flipped) ? self.backViewCoordinator : self.frontViewCoordinator;
    if ([frontFacingCoordinator respondsToSelector:@selector(flipSideDidAppear)])
        [frontFacingCoordinator flipSideDidAppear];
}

#pragma mark - Flip Management

- (void)switchViews
{
    id<IBAFlipViewSideProtocol> frontFacingCoordinator = (self.flipped) ? self.backViewCoordinator : self.frontViewCoordinator;
    id<IBAFlipViewSideProtocol> backFacingCoordinator = (self.flipped) ? self.frontViewCoordinator : self.backViewCoordinator;
    
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionTransitionFlipFromLeft;
    
    if ([frontFacingCoordinator respondsToSelector:@selector(flipSideWillDisappear)])
        [frontFacingCoordinator flipSideWillDisappear];
    if ([backFacingCoordinator respondsToSelector:@selector(flipSideWillAppear)])
        [backFacingCoordinator flipSideWillAppear];
    
    [UIView transitionWithView:self.view duration:0.75 options:animationOptions animations:^{
        [frontFacingCoordinator.view removeFromSuperview];
        [self.view addSubview:backFacingCoordinator.view];
        IBA_RUN_BLOCK(self.animateBlockDuringFlip);
    } completion:^(BOOL IBA_UNUSED finished) {
        if ([backFacingCoordinator respondsToSelector:@selector(flipSideDidAppear)])
            [backFacingCoordinator flipSideDidAppear];
    }];
    
    self.flipped = !self.flipped;
}

@end
