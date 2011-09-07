//
//  IBACarouselView.h
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
#import "IBAEasing.h"

@class IBACarouselView;

@protocol IBACarouselViewDatasource <NSObject>

/*!
 \brief     Tells the data source to return the number of items to display in the carousel view.
 \param     carouselView        The carousel-view object reqesting this information.
 \return    The number of items in the carousel.
 */
- (NSUInteger)numberOfItemsInCarouselView:(IBACarouselView *)carouselView;

/*!
 \brief     Asks the data source for a view to display for the the specified item \a index.
 \param     carouselView    The carousel-view object requesting the view.
 \param     index           The index of the item to get the view for.
 \return    An object inheriting from UIView that the Carousel view can use for the specified index. An assertion is raised if you return nil.
*/
- (UIView *)carouselView:(IBACarouselView *)carouselView viewForItemAtIndex:(NSUInteger)index;

@end

/*!
 \brief     Provides a view that simulates a 360 degree carousel.  Flicking your finger spins the carousel left and right.  The views displayed within the carousel are obtained for a data-source object.
 */
@interface IBACarouselView : UIView

/*!
 \brief     The easing function to use when slowing down the throw velocity.  Defaults to IBACubicEaseOut.
 */
@property (nonatomic, assign) IBAEasingFunction easingFunction;

/*!
 \brief      The duration of a carousel throw.  Defaults to 2 seconds.
 */
@property (nonatomic, assign) NSTimeInterval throwDuration;

/*!
 \brief      A factor to multiply the throw velocity with.  Values higher than one increase velocity; lower values decrease velocity. Defaults to 0.5.
 */
@property (assign, nonatomic) CGFloat throwVelocityFactor;

/*!
 \brief      The minimum velocity (in radians per second) a throw must exceed in order to spin the carousel. Default is 5 degrees per second (as measured in radians).
 */
@property (nonatomic, assign) CGFloat minimumThrowVelocity;

/*!
 \brief     The datasource that provides the views to display in the carousel.
 */
@property (nonatomic, assign) IBOutlet id<IBACarouselViewDatasource> dataSource;

- (void) spinWithVelocity:(CGFloat)velocity 
              forDuration:(NSTimeInterval)duration;

- (void) stopSpin;

@end
