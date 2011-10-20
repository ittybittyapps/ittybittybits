//
//  IBAViewController.h
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

#import <UIKit/UIKit.h>

@class IBAViewController;

@protocol IBAViewControllerDelegate <NSObject>

@optional
/*!
 \brief     Called when the navigation controller presents a new view controller via presentModalViewController.
 */
- (void)viewController:(UIViewController *)viewController willPresentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;

/*!
 \brief     Called when the navigation controller dismisses a new view controller via dismissModalViewController.
 */
- (void)viewController:(UIViewController *)viewController didDismissModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;

@end

/*!
 \brief     A simple wrapper around UIViewController that provides some additional conveniences.  
 \details   This class is not meant to be instantiated directly, you should subclass it to define your own view controllers.
 */
@interface IBAViewController : UIViewController

+ (id)controller;
+ (NSString *)nibName;
+ (NSBundle *)bundle;

@property (nonatomic, assign) id<IBAViewControllerDelegate> delegate;

- (void)releaseViews;

- (void)pushToolbarItems:(NSArray *)items animated:(BOOL)animated;
- (void)popToolbarItemsAnimated:(BOOL)animated;

@end
