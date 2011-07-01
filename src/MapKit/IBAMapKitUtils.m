//
//  IBAMapKitUtils.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/06/11.
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

#import "IBAMapKitUtils.h"

const MKCoordinateRegion IBAMKCoordinateRegionNull = { { INFINITY, INFINITY }, { 0.0, 0.0 } };

/*!
 \brief     Retuns a MKCoordinateRegion that covers the specified \a number of \a coordinates.
 \return    A MKCoordinateRegion that covers the specified \a number of \a coordinates.  MKCoordinateRegionNull if \a number of coordinates is less than 1.
 */
MKCoordinateRegion IBAMKCoordinateRegionWithCoordinates(CLLocationCoordinate2D * coordinates, NSUInteger number)
{
    MKCoordinateRegion region = IBAMKCoordinateRegionNull;
    if(number > 0)
    {
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

        MKCoordinateSpan span = MKCoordinateSpanMake(fabs(topLeft.latitude - botRight.latitude), 
                                                     fabs(botRight.longitude - topLeft.longitude));
        
        region = MKCoordinateRegionMake(centre, span);
    }
    
    return region;
}

/*!
 \brief     Returns YES if the specified \a region is "null".
 */
BOOL IBAMKCoordinateRegionIsNull(MKCoordinateRegion region)
{
    return isinf(region.center.latitude) || isinf(region.center.longitude);
}

/*!
 \brief     Returns YES if the specified \a region is "null" or empty.
 */
BOOL IBAMKCoordinateRegionIsEmpty(MKCoordinateRegion region)
{
    return IBAMKCoordinateRegionIsNull(region) || (region.span.latitudeDelta == 0.0 && region.span.longitudeDelta == 0.0);
}

/*!
 \brief     Returns a debug description string for the \a region.
 */
NSString *IBAMKCoordinateRegionDebugDescription(MKCoordinateRegion region)
{
    return [NSString stringWithFormat:@"{center: {%f,%f}, span: {%f,%f}}", 
            region.center.latitude, 
            region.center.longitude,
            region.span.latitudeDelta,
            region.span.longitudeDelta];
}