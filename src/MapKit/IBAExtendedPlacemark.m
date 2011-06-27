//
//  IBAExtendedPlacemark.m
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

#import "IBAExtendedPlacemark.h"
#import "../Foundation/IBACommon.h"
#import <AddressBook/AddressBook.h>

static NSString *kCoordinateLatitudeEncoderKey = @"coordinate.latitude";
static NSString *kCoordinateLongitudeEncoderKey = @"cooridinate.longitude";
static NSString *kAddressDictionaryEncoderKey = @"addressDictionary";
static NSString *kLocationTypeEncoderKey = @"locationType";

static NSString *kViewportCenterLatitudeEncoderKey = @"viewport.center.latitude";
static NSString *kViewportCenterLongitudeEncoderKey = @"viewport.center.longitude";
static NSString *kViewportSpanLatitudeDeltaEncoderKey = @"viewport.span.latitudeDelta";
static NSString *kViewportSpanLongitudeDeltaEncoderKey = @"viewport.span.longitudeDelta";

static NSString *kBoundsCenterLatitudeEncoderKey = @"bounds.center.latitude";
static NSString *kBoundsCenterLongitudeEncoderKey = @"bounds.center.longitude";
static NSString *kBoundsSpanLatitudeDeltaEncoderKey = @"bounds.span.latitudeDelta";
static NSString *kBoundsSpanLongitudeDeltaEncoderKey = @"bounds.span.longitudeDelta";

@implementation IBAExtendedPlacemark

IBA_SYNTHESIZE(locationType, bounds, viewport);

- (NSString *)thoroughfare
{
    NSString *thoroughfare = [super thoroughfare];
    NSString *street = [[super addressDictionary] valueForKey:(NSString *)kABPersonAddressStreetKey];
    
    if (thoroughfare == nil && street != nil)
    {
        return street;
    }
    
    return thoroughfare;
}

/*!
 \brief     Returns an object initialized from data in a given unarchiver. (required)
 \param     decoder     An unarchiver object.
 \return    self, initialized using the data in decoder.
*/
- (id)initWithCoder:(NSCoder *)decoder
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([decoder decodeDoubleForKey:kCoordinateLatitudeEncoderKey],
                                                                   [decoder decodeDoubleForKey:kCoordinateLongitudeEncoderKey]);
    
    NSDictionary *addressDictionary = [decoder decodeObjectForKey:kAddressDictionaryEncoderKey];
    
    if ((self = [super initWithCoordinate:coordinate addressDictionary:addressDictionary]))
    {
        self.locationType = [decoder decodeIntForKey:kLocationTypeEncoderKey];
        self.viewport = MKCoordinateRegionMake(CLLocationCoordinate2DMake([decoder decodeDoubleForKey:kViewportCenterLatitudeEncoderKey], 
                                                                          [decoder decodeDoubleForKey:kViewportCenterLongitudeEncoderKey]), 
                                               MKCoordinateSpanMake([decoder decodeDoubleForKey:kViewportSpanLatitudeDeltaEncoderKey], 
                                                                    [decoder decodeDoubleForKey:kViewportSpanLongitudeDeltaEncoderKey]));
        
        self.bounds = MKCoordinateRegionMake(CLLocationCoordinate2DMake([decoder decodeDoubleForKey:kBoundsCenterLatitudeEncoderKey], 
                                                                        [decoder decodeDoubleForKey:kBoundsCenterLongitudeEncoderKey]), 
                                             MKCoordinateSpanMake([decoder decodeDoubleForKey:kBoundsSpanLatitudeDeltaEncoderKey], 
                                                                  [decoder decodeDoubleForKey:kBoundsSpanLongitudeDeltaEncoderKey]));
    }

    return self;
}


/*!
 \brief     Encodes the receiver using a given archiver. (required)
 \param     encoder     An archiver object.
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.coordinate.latitude forKey:kCoordinateLatitudeEncoderKey];
    [encoder encodeDouble:self.coordinate.longitude forKey:kCoordinateLongitudeEncoderKey];

    [encoder encodeObject:self.addressDictionary forKey:kAddressDictionaryEncoderKey];
    [encoder encodeInt:self.locationType forKey:kLocationTypeEncoderKey];
    
    [encoder encodeDouble:self.viewport.center.latitude forKey:kViewportCenterLatitudeEncoderKey];
    [encoder encodeDouble:self.viewport.center.longitude forKey:kViewportCenterLongitudeEncoderKey];
    [encoder encodeDouble:self.viewport.span.latitudeDelta forKey:kViewportSpanLatitudeDeltaEncoderKey];
    [encoder encodeDouble:self.viewport.span.longitudeDelta forKey:kViewportSpanLongitudeDeltaEncoderKey];

    [encoder encodeDouble:self.bounds.center.latitude forKey:kBoundsCenterLatitudeEncoderKey];
    [encoder encodeDouble:self.bounds.center.longitude forKey:kBoundsCenterLongitudeEncoderKey];
    [encoder encodeDouble:self.bounds.span.latitudeDelta forKey:kBoundsSpanLatitudeDeltaEncoderKey];
    [encoder encodeDouble:self.bounds.span.longitudeDelta forKey:kBoundsSpanLongitudeDeltaEncoderKey];
}

/*!
 \brief     Convert a string to a location type.
 */
+ (IBAExtendedPlacemarkLocationType) locationTypeForString:(NSString *)locationType
{
    if ([locationType caseInsensitiveCompare:@"ROOFTOP"] == NSOrderedSame)
    {
        return IBAExtendedPlacemarkLocationTypeRooftop;
    }
    
    if ([locationType caseInsensitiveCompare:@"RANGE_INTERPOLATED"] == NSOrderedSame)
    {
        return IBAExtendedPlacemarkLocationTypeRangeInterpolated;
    }
    
    if ([locationType caseInsensitiveCompare:@"GEOMETRIC_CENTER"] == NSOrderedSame)
    {
        return IBAExtendedPlacemarkLocationTypeGeometricCenter;
    }
    
    if ([locationType caseInsensitiveCompare:@"APPROXIMATE"] == NSOrderedSame)
    {
        return IBAExtendedPlacemarkLocationTypeApproximate;
    }
    
    return IBAExtendedPlacemarkLocationTypeUnknown;
}

/*!
 \brief     Convert a dictionary to a coordinate region.
 /*/
+ (MKCoordinateRegion)coordinateRegionForDictionary:(NSDictionary *)dictionary
{
    NSDictionary *northeast = [dictionary valueForKey:@"northeast"];
    NSDictionary *southwest = [dictionary valueForKey:@"southwest"];
    
    CLLocationCoordinate2D northeastCoordinate = CLLocationCoordinate2DMake([[northeast valueForKey:@"lat"] doubleValue], 
                                                                            [[northeast valueForKey:@"lng"] doubleValue]);

    CLLocationCoordinate2D southwestCoordinate = CLLocationCoordinate2DMake([[southwest valueForKey:@"lat"] doubleValue], 
                                                                            [[southwest valueForKey:@"lng"] doubleValue]);


    MKMapPoint northeastPoint = MKMapPointForCoordinate(northeastCoordinate);
    MKMapPoint southwestPoint = MKMapPointForCoordinate(southwestCoordinate);

    MKMapRect rect = MKMapRectMake(northeastPoint.y, southwestPoint.x, northeastPoint.x - southwestPoint.x, southwestPoint.y - northeastPoint.y);
    
    return MKCoordinateRegionForMapRect(rect);
}

@end
