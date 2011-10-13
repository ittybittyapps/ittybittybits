//
//  IBAGeocoder.h
//
//  Originally created by Sam Vermette on 07.02.11.
//  Copyright (c) 2011 Sam Vermette. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Modified by Oliver Jones on 2011/05/19.
//  Modifications Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
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
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "../Foundation/IBAFoundation.h"

@protocol IBAGeocoderDelegate;

IBA_EXTERN NSString *kIBAGeocoderErrorDomain;

typedef enum {
    kIBAGeocoderErrorCodeUnknown = 9000,
    kIBAGeocoderErrorCodeOverQueryLimit = 9001,
    kIBAGeocoderErrorCodeRequestDenied = 9002,
    kIBAGeocoderErrorCodeInvalidRequest = 9003
} IBAGeocoderErrorCode;

@interface IBAGeocoder : NSObject {

}

@property (nonatomic, assign) id<IBAGeocoderDelegate> delegate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithAddress:(NSString *)address inRegion:(MKCoordinateRegion)region;
- (id)initWithAddress:(NSString *)address inCountry:(NSString *)country;
- (id)initWithRequestParams:(NSString *)params;

- (void)start;

@end

@protocol IBAGeocoderDelegate <NSObject>

- (void)geocoder:(IBAGeocoder *)geocoder didFindPlacemarks:(NSArray *)placemarks;
- (void)geocoder:(IBAGeocoder *)geocoder didFailWithError:(NSError *)error;

@end

