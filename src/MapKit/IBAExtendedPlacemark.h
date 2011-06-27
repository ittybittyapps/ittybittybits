//
//  IBAExtendedPlacemark.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 23/05/11.
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

#import <Foundation/Foundation.h>

/*!
 \brief     Identifies the accuracy of location that an IBAExtendedPlacemark has.
 */
typedef enum
{
    IBAExtendedPlacemarkLocationTypeUnknown = 0,
    
    /*! Indicates that the returned result is a precise geocode for which we have location information accurate down to street address precision, */
    IBAExtendedPlacemarkLocationTypeRooftop, 
    
    /*! Indicates that the returned result reflects an approximation (usually on a road) interpolated between two precise points (such as intersections). Interpolated results are generally returned when rooftop geocodes are unavailable for a street address. */
    IBAExtendedPlacemarkLocationTypeRangeInterpolated,
    
    /*! Indicates that the returned result is the geometric center of a result such as a polyline (for example, a street) or polygon (region). */
    IBAExtendedPlacemarkLocationTypeGeometricCenter,
    
    /*! Indicates that the returned result is approximate. */
    IBAExtendedPlacemarkLocationTypeApproximate
} IBAExtendedPlacemarkLocationType;

/*!
 \brief     Extension to MKPlacemark that provides additional information properties and is serializable via NSCoding.
 */
@interface IBAExtendedPlacemark : MKPlacemark<NSCoding>
{
}

@property (nonatomic, assign) IBAExtendedPlacemarkLocationType locationType;

/*!
 \brief     (Optional) Stores the bounding box which can fully contain the returned result. Note that these bounds may not match the recommended viewport. (For example, San Francisco includes the Farallon islands, which are technically part of the city, but probably should not be returned in the viewport.)
*/
@property (nonatomic, assign) MKCoordinateRegion bounds;

/*!
 \brief     Contains the recommended viewport for displaying the returned result, specified as two latitude,longitude values defining the southwest and northeast corner of the viewport bounding box. Generally the viewport is used to frame a result when displaying it to a user.
 */
@property (nonatomic, assign) MKCoordinateRegion viewport;

+ (IBAExtendedPlacemarkLocationType)locationTypeForString:(NSString *)locationType;
+ (MKCoordinateRegion)coordinateRegionForDictionary:(NSDictionary *)dictionary;

@end
