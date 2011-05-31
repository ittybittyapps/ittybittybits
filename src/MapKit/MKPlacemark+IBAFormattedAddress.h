//
//  MKPLacemark+IBAFormattedAddress.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 31/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MKPlacemark (IBAFormattedAddress)

- (NSString *)ibaStreetName;
- (NSString *)ibaStreetAddress;
- (NSString *)ibaFormattedAddress;

@end
