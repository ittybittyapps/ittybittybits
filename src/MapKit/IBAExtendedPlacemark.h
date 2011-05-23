//
//  IBAExtendedPlacemark.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 23/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

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
