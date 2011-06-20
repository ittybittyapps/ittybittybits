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
#import <CoreLocation/CoreLocation.h>

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
    
    CLLocationCoordinate2D topLeft = CLLocationCoordinate2DMake(-90, 180);    
    CLLocationCoordinate2D botRight = CLLocationCoordinate2DMake(90, -180);
    
    for (NSUInteger i = 0; i < number; ++i)
    {
        CLLocationCoordinate2D c = coordinates[i];
        
        topLeft.longitude = fmin(topLeft.longitude, c.longitude);
        topLeft.latitude = fmax(topLeft.latitude, c.latitude);
        
        botRight.longitude = fmax(botRight.longitude, c.longitude);
        botRight.latitude = fmin(botRight.latitude, c.latitude);
    }
    
    CLLocationCoordinate2D centre = CLLocationCoordinate2DMake(topLeft.latitude - ((topLeft.latitude - botRight.latitude) * 0.5),
                                                               topLeft.longitude + ((botRight.longitude - topLeft.longitude) * 0.5));
    
    
    // Multiply the span by 1.1 to add a little extra space around the edges.
    MKCoordinateSpan span = MKCoordinateSpanMake(fabs(topLeft.latitude - botRight.latitude) * 1.1, 
                                                 fabs(botRight.longitude - topLeft.longitude) * 1.1);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(centre, span);
    
    region = [self regionThatFits:region];
    [self setRegion:region animated:animated];

}

/*!
 \brief     Remove all the annotations from the MKMapView.
*/
- (void)ibaRemoveAllAnnotations
{
    [self removeAnnotations:[self annotations]];
}

/*!
 \brief     Remove all the overlays from the MKMapView.
 */
- (void)ibaRemoveAllOverlays
{
    [self removeOverlays:[self overlays]];
}


@end
