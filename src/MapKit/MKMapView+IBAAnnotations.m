//
//  MKMapView+IBAAnnotations.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 16/05/11.
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

#import "MKMapView+IBAAnnotations.h"
#import "IBAMapKitUtils.h"

@implementation MKMapView (IBAAnnotations)

/*!
 \brief     Sets the region on the MKMapView so that all the specified \a annotations are visible.
 */
- (void)ibaSetRegionForAnnotations:(NSArray *)annotations
                          animated:(BOOL)animated
{
    NSUInteger count = [annotations count];
    if(count == 0)
        return;
    
    size_t index = 0;
    CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D) * count);
    for (id<MKAnnotation> annotation in annotations)
    {
        coordinates[index++] = annotation.coordinate;
    }
    
    [self ibaSetRegionForCoordinates:coordinates count:count animated:animated]; 
    
    free(coordinates);
}

/*!
 \brief     Sets the region on the MKMapView so that all the specified \a annotations and \a coordinate are visible.
 */
- (void)ibaSetRegionForAnnotations:(NSArray *)annotations
                          location:(CLLocationCoordinate2D)coordinate
                          animated:(BOOL)animated
 {
     NSUInteger count = [annotations count];
     
     CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D) * (count + 1));
     coordinates[0] = coordinate;

     size_t index = 1;
     for (id<MKAnnotation> annotation in annotations)
     {
         coordinates[index++] = annotation.coordinate;
     }
     
     [self ibaSetRegionForCoordinates:coordinates count:(count + 1) animated:animated]; 
     
     free(coordinates);
 }

/*!
 \brief     Sets the region on the MKMapView so that all the specified \a number of \a coordinates are visible.
 */
- (void)ibaSetRegionForCoordinates:(CLLocationCoordinate2D *)coordinates
                             count:(NSUInteger)number
                          animated:(BOOL)animated
{
    if(number == 0)
        return;
    
    MKCoordinateRegion region = IBAMKCoordinateRegionWithCoordinates(coordinates, number);
    if (IBAMKCoordinateRegionIsNull(region) == NO)
    {
        // Multiply the span by 1.1 to add a little extra space around the edges.
        region = MKCoordinateRegionMake(region.center,
                                        MKCoordinateSpanMake(region.span.latitudeDelta * 1.1, 
                                                             region.span.longitudeDelta * 1.1));

        region = [self regionThatFits:region];
        [self setRegion:region animated:animated];
    }
}

/*!
 \brief     Remove all the annotations from the MKMapView.
*/
- (void)ibaRemoveAllAnnotations
{
    // Not just passing in the annotations array just in case it modifies in place.  That would be a stupid thing for the framework to do, but hey - better safe than sorry.
    if (self.annotations && [self.annotations ibaIsEmpty] == NO)
    {
        NSArray *annotationsToRemove = [[NSArray alloc] initWithArray:self.annotations];
        [self removeAnnotations:annotationsToRemove];
        
        NSAssert([self.annotations count] == 0, @"No annotations should exist!");
        IBA_RELEASE(annotationsToRemove);
    }
}

/*!
 \brief     Remove all the overlays from the MKMapView.
 */
- (void)ibaRemoveAllOverlays
{
    // Not just passing in the overlays array just in case (it modifies in place).  That would be a stupid thing for the framework to do, but hey - better safe than sorry.

    if (self.overlays && [self.overlays ibaIsEmpty] == NO)
    {
        NSArray *overlaysToRemove = [[NSArray alloc] initWithArray:self.overlays];
        [self removeOverlays:overlaysToRemove];

        NSAssert([self.overlays count] == 0, @"No overlays should exist!");
        IBA_RELEASE(overlaysToRemove);
    }
}


@end
