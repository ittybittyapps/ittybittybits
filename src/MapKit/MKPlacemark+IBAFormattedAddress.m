//
//  MKPLacemark+IBAFormattedAddress.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 31/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "MKPLacemark+IBAFormattedAddress.h"
#import "../Foundation/NSString+IBAWhitespace.h"

@implementation MKPlacemark (IBAFormattedAddress)

/*!
 \brief     Formats the address information of a placemark into a string.
 \details   At present only formats an address in a western european style.
 */
- (NSString *)ibaFormattedAddress
{
    NSMutableArray *addressParts = [[NSMutableArray alloc] initWithCapacity:7];
    
    if (self.ibaStreetAddress) [addressParts addObject:self.ibaStreetAddress];
    if (self.locality) [addressParts addObject:self.locality];
    if (self.subLocality) [addressParts addObject:self.subLocality];
    if (self.administrativeArea) [addressParts addObject:self.administrativeArea];
    if (self.subAdministrativeArea) [addressParts addObject:self.subAdministrativeArea];
    if (self.postalCode) [addressParts addObject:self.postalCode];
    if (self.country) [addressParts addObject:self.country];
    
    NSString *formattedAddress = [addressParts componentsJoinedByString:@", "];
    [addressParts release];
    
    return formattedAddress;
    
}

/*!
 \brief     Gets the street name of a placemark.
 \details   There seems to be some sort of bug in iOS.  The thoroughfare property on MKPlacemark sometimes is nil but there is a street entry in the addressDictionary is set. This method will return the street if thoroughfare is nil.
 */
- (NSString *)ibaStreetName
{
    NSString *thoroughfare = self.thoroughfare;
    NSString *street = [self.addressDictionary valueForKey:(NSString *)kABPersonAddressStreetKey];
    
    if (thoroughfare == nil && street != nil)
    {
        return street;
    }
    
    return thoroughfare;
}

/*!
 \brief     Gets the street address of a placemark.  Ie, the house/building number and name.
 \details   Returns a string in the format "## StreetName".
 */
- (NSString *)ibaStreetAddress
{
    if (self.subThoroughfare || self.ibaStreetName)
    {
        return [NSString stringWithFormat:@"%@%@", 
                (IBAIsNilOrEmptyString(self.subThoroughfare) ? @"" : [self.subThoroughfare stringByAppendingString:@" "]), 
                self.ibaStreetName];
    }
    
    return nil;
}

@end
