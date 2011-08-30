//
//  IBANavigationBar.h
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

#import <UIKit/UIKit.h>

/*!
 \brief     Provides a subclass of UINavigationBar that renders a custom background image in the navigation bar area.
 
 \details   
 In order to use this class you need to specify IBANavigationBar as the custom class for the navigation bar in the XIB containing a UINavigationController.  You need to do this because UINavigationController instantiates its own navigation bar instance and the only way of injecting an alternative class to use is by specifying it in Interface Builder.
 
 Here is an example of its use in code:
 \code
 
    UIViewController *viewController = ...;
    UINib *navNib = [UINib nibWithNibName:@"NavigationController" bundle:nil];
    UINavigationController *navController = [navNib ibaInstantiateNavigationControllerWithRootViewController:viewController];
    navController.ibaNavigationBar.portraitBackgroundImage = ...;
 
 \endcode
 
 Note that this code uses additional IBA extension categories to make using this custom navigation bar easier.
 
 \sa    UINavigationController+IBAExtensions.h
 */
@interface IBANavigationBar : UINavigationBar

/*!
 \brief     When non-nil this image is used to draw the background of the navigation bar in portrait orientations.
 */
@property (nonatomic, retain) UIImage *portraitBackgroundImage;

/*!
 \brief     When non-nil this image is used to draw the background of the navigation bar in landscape orientations.
 */
@property (nonatomic, retain) UIImage *landscapeBackgroundImage;

@end
