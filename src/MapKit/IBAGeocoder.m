//
//  IBAGeocoder.m
//
//  Created by Sam Vermette on 07.02.11.
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

#import "IBAGeocoder.h"
#import "../Foundation/IBAFoundation.h"

#import "JSONKit.h"

static NSString *kDefaultGeocoderURL = @"http://maps.googleapis.com/maps/api/geocode/json?sensor=true&";

static NSString *kIBAGeocoderErrorDomain = @"IBAGeocoderErrorDomain";

typedef enum {
    kIBAGeocoderErrorCodeUnknown = 9000,
    kIBAGeocoderErrorCodeOverQueryLimit = 9001,
    kIBAGeocoderErrorCodeRequestDenied = 9002,
    kIBAGeocoderErrorCodeInvalidRequest = 9003
} IBAGeocoderErrorCode;

@interface IBAGeocoderError : NSError
{
}

+ (BOOL) requestStatusIsError:(NSString *)status;
+ (id)errorWithStatus:(NSString *)status;
- (id)initWithStatus:(NSString *)status;

@end

@interface IBAGeocoder ()

@property (nonatomic, retain) NSURL *requestURL;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection *rConnection;

@end

@implementation IBAGeocoder
 
IBA_SYNTHESIZE(delegate, responseData, rConnection, request, requestURL);

#pragma mark -

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate 
{
    NSString *params = [NSString stringWithFormat:@"latlng=%f,%f", coordinate.latitude, coordinate.longitude];
    return [self initWithRequestParams:params];
}

- (id)initWithAddress:(NSString *)address inRegion:(MKCoordinateRegion)region 
{
    NSString *params = [NSString stringWithFormat:@"address=%@&bounds=%f,%f|%f,%f",
                        address,
                        region.center.latitude-(region.span.latitudeDelta/2.0),
                        region.center.longitude-(region.span.longitudeDelta/2.0),
                        region.center.latitude+(region.span.latitudeDelta/2.0),
                        region.center.longitude+(region.span.longitudeDelta/2.0)];
    
    return [self initWithRequestParams:params];
}


- (id)initWithAddress:(NSString *)address inCountry:(NSString *)country;
{
	NSString *urlParams = [NSString stringWithFormat:@"address=%@&region=%@", address, country];
    return [self initWithRequestParams:urlParams];
}

- (id)initWithRequestParams:(NSString *)params
{
    if ((self = [super init]))
    {
        NSString *fullURL = [kDefaultGeocoderURL stringByAppendingString:[params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        self.requestURL = [NSURL URLWithString:fullURL];
    }
    
    return self;
}

- (void)dealloc 
{
    self.delegate = nil;
    self.requestURL = nil;
	self.request = nil;	
	self.responseData = nil;
    self.rConnection = nil;
    
	[super dealloc];
}

#pragma mark -

/*!
 \brief     Start the asynchronous geocoding request.
 */
- (void)start 
{	
    IBALogDebug(@"%@ -> Start Request: %@", [self class], self.requestURL);
    
	self.request = [NSURLRequest requestWithURL:self.requestURL];
    self.rConnection = [NSURLConnection connectionWithRequest:self.request delegate:self];
 	self.responseData = [NSMutableData data];
    
    [self.rConnection start];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate Protocol Methods

/*!
 Sent as a connection loads data incrementally.
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{	
	[self.responseData appendData:data];
}

/*!
 Sent when a connection has finished loading successfully.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    NSMutableArray *placemarks = [NSMutableArray array];
	NSError *jsonError = nil;
	NSDictionary *responseDict = [self.responseData objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&jsonError];
	
    NSString *status = [responseDict valueForKey:@"status"];
    NSArray* results = [responseDict valueForKey:@"results"];
    
    IBALogDebug(@"IBAGeocoder -> Response Status: %@", status);
    
    if(jsonError != nil || responseDict == nil || results == nil)
    {
		[self connection:connection didFailWithError:jsonError];
		return;
	}
    
    if ([IBAGeocoderError requestStatusIsError:status])
    {
        IBAGeocoderError *error = [IBAGeocoderError errorWithStatus:status];
        
        [self connection:connection didFailWithError:error];
    }
    
    for (NSDictionary *result in results)
    {
        NSDictionary *addressDict = [result valueForKey:@"address_components"];
        NSDictionary *coordinateDict = [[result valueForKey:@"geometry"] valueForKey:@"location"];
        
        float lat = [[coordinateDict valueForKey:@"lat"] floatValue];
        float lng = [[coordinateDict valueForKey:@"lng"] floatValue];
        
        NSMutableDictionary *formattedAddressDict = [NSMutableDictionary new];
        
        for(NSDictionary *component in addressDict) 
        {
            NSArray *types = [component valueForKey:@"types"];
            
            if([types containsObject:@"street_number"])
                [formattedAddressDict setValue:[component valueForKey:@"long_name"] forKey:(NSString*)kABPersonAddressStreetKey];
            
            if([types containsObject:@"route"])
                [formattedAddressDict setValue:[[formattedAddressDict valueForKey:(NSString*)kABPersonAddressStreetKey] stringByAppendingFormat:@" %@",[component valueForKey:@"long_name"]] forKey:(NSString*)kABPersonAddressStreetKey];
            
            if([types containsObject:@"locality"])
                [formattedAddressDict setValue:[component valueForKey:@"long_name"] forKey:(NSString*)kABPersonAddressCityKey];
            
            if([types containsObject:@"administrative_area_level_1"])
                [formattedAddressDict setValue:[component valueForKey:@"long_name"] forKey:(NSString*)kABPersonAddressStateKey];
            
            if([types containsObject:@"postal_code"])
                [formattedAddressDict setValue:[component valueForKey:@"long_name"] forKey:(NSString*)kABPersonAddressZIPKey];
            
            if([types containsObject:@"country"]) {
                [formattedAddressDict setValue:[component valueForKey:@"long_name"] forKey:(NSString*)kABPersonAddressCountryKey];
                [formattedAddressDict setValue:[component valueForKey:@"short_name"] forKey:(NSString*)kABPersonAddressCountryCodeKey];
            }
        }
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng) 
                                                       addressDictionary:formattedAddressDict];
        [formattedAddressDict release];
        
        IBALogDebug(@"IBAGeocoder -> Found Placemark: %@", placemark);
        [placemarks addObject:placemark];

        [placemark release];
    }
    
    [self.delegate geocoder:self didFindPlacemarks:[NSArray arrayWithArray:placemarks]];
}

/*!
 Sent when a connection fails to load its request successfully.
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{	
	IBALogDebug(@"IBAGeocoder -> Failed with error: %@, (%@)", [error localizedDescription], [[self.request URL] absoluteString]);
	
	[self.delegate geocoder:self didFailWithError:error];
}

@end

#pragma mark -

@implementation IBAGeocoderError

+ (id) errorWithStatus:(NSString *)status
{
    return [[[self alloc] initWithStatus:status] autorelease];
}

+ (BOOL) requestStatusIsError:(NSString *)status
{
    return ([status isEqualToString:@"OK"] || [status isEqualToString:@"ZERO_RESULTS"]) == NO;
}

- (IBAGeocoderErrorCode)codeForStatus:(NSString *)status
{
    if ([status isEqualToString:@"OVER_QUERY_LIMIT"])
    {
        return kIBAGeocoderErrorCodeOverQueryLimit;
    }
    
    if ([status isEqualToString:@"REQUEST_DENIED"])
    {
        return kIBAGeocoderErrorCodeRequestDenied;
    }
    
    if ([status isEqualToString:@"INVALID_REQUEST"])
    {
        return kIBAGeocoderErrorCodeInvalidRequest;
    }
    
    return kIBAGeocoderErrorCodeUnknown;
}

- (id)initWithStatus:(NSString *)status
{
    IBAGeocoderErrorCode code = [self codeForStatus:status];
    
    if ((self = [super initWithDomain:kIBAGeocoderErrorDomain code:code userInfo:nil]))
    {
    }
    
    return self;
}

- (NSString *)localizedDescription
{
    switch (self.code) {
        case kIBAGeocoderErrorCodeInvalidRequest:
            return IBALocalizedString(@"Invalid request.");
        case kIBAGeocoderErrorCodeOverQueryLimit:
            return IBALocalizedString(@"Too many queries. Over limit.");
        case kIBAGeocoderErrorCodeRequestDenied:
            return IBALocalizedString(@"Request denied.");
        default:
            return IBALocalizedString(@"Unknown error");
    }
}

@end
