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
#import "IBAExtendedPlacemark.h"

#import "JSONKit.h"

static NSString const *kDefaultGeocoderURL = @"http://maps.googleapis.com/maps/api/geocode/json?sensor=true&";

NSString *kIBAGeocoderErrorDomain = @"IBAGeocoderErrorDomain";

@interface IBAGeocoderError : NSError

+ (BOOL)requestStatusIsError:(NSString *)status;
+ (id)errorWithStatus:(NSString *)status;
- (id)initWithStatus:(NSString *)status;

@end

@interface IBAGeocoder ()

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@property (nonatomic, retain) NSURL *requestURL;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, assign) BOOL cancelled;

- (void)startConnection;
- (void)setupRequest;

@end

@implementation IBAGeocoder

IBA_SYNTHESIZE(delegate, responseData, connection, request, requestURL, cancelled);

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

- (id)initWithAddress:(NSString *)address inCountry:(NSString *)country
{
    IBAAssertNotNilOrEmptyString(address);
    
    NSString *urlParams = (country && [country ibaNotBlank]) ? [NSString stringWithFormat:@"address=%@&region=%@", address, country] : [NSString stringWithFormat:@"address=%@", address];
	 
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

/*!
 \brief     Deallocates the memory occupied by the receiver.
 */
- (void)dealloc 
{
    IBA_NIL_PROPERTY(delegate);
    IBA_RELEASE_PROPERTY(requestURL);
    IBA_RELEASE_PROPERTY(request);
    IBA_RELEASE_PROPERTY(responseData);
    IBA_RELEASE_PROPERTY(connection);
    
	[super dealloc];
}

#pragma mark - Private Methods

- (void)setupRequest
{
    self.request = [NSURLRequest requestWithURL:self.requestURL];
    self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
    self.responseData = [NSMutableData data];
}

- (void)startConnection
{
    if ([self.delegate respondsToSelector:@selector(geocoderWillBeginFindingPlacemarks:)])
    {
        [self.delegate geocoderWillBeginFindingPlacemarks:self];
    }
    
    [self.connection start];
}

#pragma mark -

/*!
 \brief     Start the asynchronous geocoding request.
 */
- (void)start 
{	
    if (self.cancelled)
    {
        [NSException raise:NSInternalInconsistencyException format:@"A cancelled request can not be started."];
    }
    
    IBALogDebug(@"%@ -> Start Request: %@", self.class, self.requestURL);
    
	[self setupRequest];
    [self startConnection];
}

/*!
 \brief     Cancels a geocoding request.
 \details   A cancelled geocoding request will not invoke any delegate methods after it has been canceled.  The underlying network request is also canceled.
 */
- (void)cancel
{
    IBALogDebug(@"%@ -> Cancelling Request: %@", self.class, self.requestURL);
    [self.connection cancel];
    self.cancelled = YES;
    
    if ([self.delegate respondsToSelector:@selector(geocoderWasCancelled:)])
    {
        [self.delegate geocoderWasCancelled:self];
    }
}

#pragma mark -
#pragma mark NSURLConnectionDelegate Protocol Methods

/*!
 Sent as a connection loads data incrementally.
 */
- (void)connection:(NSURLConnection *)IBA_UNUSED connection didReceiveData:(NSData *)data 
{	
	[self.responseData appendData:data];
}

/*!
 Sent when a connection fails to load its request successfully.
 */
- (void)connection:(NSURLConnection *)IBA_UNUSED connection didFailWithError:(NSError *)error 
{	
    if (self.cancelled)
    {
        return;
    }
    
	IBALogDebug(@"IBAGeocoder -> Failed with error: %@, (%@)", [error localizedDescription], [[self.request URL] absoluteString]);
	    
    [self.delegate geocoder:self didFailWithError:error];
}

/*!
 Sent when a connection has finished loading successfully.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    if (self.cancelled)
    {
        return;
    }
    
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
    else
    {
        for (NSDictionary *result in results)
        {
            NSDictionary *addressDict = [result valueForKey:@"address_components"];                        
            NSMutableDictionary *formattedAddressDict = [NSMutableDictionary new];
            
            for(NSDictionary *component in addressDict) 
            {
                NSArray *types = [component valueForKey:@"types"];
                
                if ([types containsObject:@"street_number"] || [types containsObject:@"route"])
                {
                    NSString *streetAddress = nil;
                    
                    if ([types containsObject:@"street_number"])
                    {
                        NSString *streetNumber = [component valueForKey:@"long_name"];
                        NSString *streetName = [formattedAddressDict valueForKey:(NSString*)kABPersonAddressStreetKey];
                        
                        streetAddress = streetName ? [streetNumber stringByAppendingFormat:@" %@", streetName] : streetNumber;
                    }
                    
                    if ([types containsObject:@"route"])
                    {
                        NSString *streetNumber = [formattedAddressDict valueForKey:(NSString*)kABPersonAddressStreetKey];
                        NSString *streetName = [component valueForKey:@"long_name"];
                        
                        streetAddress = streetNumber ? [streetNumber stringByAppendingFormat:@" %@", streetName] : streetName;
                    }
                    
                    [formattedAddressDict setValue:streetAddress forKey:(NSString*)kABPersonAddressStreetKey];
                }
                
                if ([types containsObject:@"locality"])
                {
                    [formattedAddressDict setValue:[component valueForKey:@"long_name"] forKey:(NSString*)kABPersonAddressCityKey];
                }
                
                if ([types containsObject:@"administrative_area_level_1"])
                {
                    [formattedAddressDict setValue:[component valueForKey:@"long_name"] forKey:(NSString*)kABPersonAddressStateKey];
                }
                
                if ([types containsObject:@"postal_code"])
                {
                    [formattedAddressDict setValue:[component valueForKey:@"long_name"] forKey:(NSString*)kABPersonAddressZIPKey];
                }
                
                if ([types containsObject:@"country"]) 
                {
                    [formattedAddressDict setValue:[component valueForKey:@"long_name"] forKey:(NSString*)kABPersonAddressCountryKey];
                    [formattedAddressDict setValue:[component valueForKey:@"short_name"] forKey:(NSString*)kABPersonAddressCountryCodeKey];
                }
            }
            
            NSDictionary *geometry = [result valueForKey:@"geometry"];
            NSDictionary *coordinateDict = [geometry valueForKey:@"location"];
            NSString *locationType = [geometry valueForKey:@"location_type"];
            NSDictionary *viewport = [geometry valueForKey:@"viewport"];
            NSDictionary *bounds = [geometry valueForKey:@"bounds"];
            
            float lat = [[coordinateDict valueForKey:@"lat"] floatValue];
            float lng = [[coordinateDict valueForKey:@"lng"] floatValue];
            
            IBAExtendedPlacemark *placemark = [[IBAExtendedPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng) 
                                                                             addressDictionary:formattedAddressDict];
            
            placemark.locationType = [IBAExtendedPlacemark locationTypeForString:locationType];
            placemark.viewport = [IBAExtendedPlacemark coordinateRegionForDictionary:viewport];
            placemark.bounds = [IBAExtendedPlacemark coordinateRegionForDictionary:bounds];
            
            [formattedAddressDict release];
            
            IBALogDebug(@"IBAGeocoder -> Found Placemark: %@", placemark);
            [placemarks addObject:placemark];
            
            [placemark release];
        }
        
        [self.delegate geocoder:self didFindPlacemarks:[NSArray arrayWithArray:placemarks]];
    }
    
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
