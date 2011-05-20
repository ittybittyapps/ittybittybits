//
//  MKReverseGeocoder+IBABlocks.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 20/05/11.
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

#import "MKReverseGeocoder+IBABlocks.h"

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import <MapKit/MapKit.h>

#import "../Foundation/IBACommon.h"

static char kIBAMKReverseGeocoderDelegateKey = 'D';

@interface IBAMKReverseGeocoderBlockDelegate : NSObject<MKReverseGeocoderDelegate>
{
}

@property (nonatomic, copy) IBAReverseGeocoderBlock block;

- (id)initWithBlock:(IBAReverseGeocoderBlock)block;

@end

@implementation IBAMKReverseGeocoderBlockDelegate

IBA_SYNTHESIZE(block);

- (id)initWithBlock:(IBAReverseGeocoderBlock)block
{
    if ((self = [super init]))
    {
        self.block = block;
    }
    
    return self;
}

- (void)dealloc
{
    self.block = nil;
    [super dealloc];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    self.block(placemark, nil);
    [geocoder release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    self.block(nil, error);
    [geocoder release];
}

@end

@implementation MKReverseGeocoder (IBABlocks)

/*!
 \brief     Start the reverse geocoding process with the delegate callbacks handled by the specified \a block.
 \param     The block that will be invoked when the gecoding process succeeds or fails.
 */
- (void) ibaStartUsingBlock:(IBAReverseGeocoderBlock)block
{
    IBAMKReverseGeocoderBlockDelegate *delegate = [[IBAMKReverseGeocoderBlockDelegate alloc] initWithBlock:block];
    
    objc_setAssociatedObject(self, &kIBAMKReverseGeocoderDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN);

    self.delegate = delegate;
    [self start];
    [delegate release];
    
    [self retain];
}

@end
