//
//  IBAFlipViewController.h
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

#import "IBAViewController.h"
#import "../Foundation/IBAFoundation.h"

@protocol IBAFlipViewSideProtocol <NSObject>
- (UIView *)view;
@optional
- (void)flipSideWillAppear;
- (void)flipSideWillDisappear;
- (void)flipSideDidAppear;
@end

@interface IBAFlipViewController : IBAViewController

IBA_PROPERTY(assign, BOOL flipped);

IBA_PROPERTY_STRONG(id<IBAFlipViewSideProtocol> frontViewCoordinator,
                    id<IBAFlipViewSideProtocol> backViewCoordinator);

- (void)switchViews;

@end
