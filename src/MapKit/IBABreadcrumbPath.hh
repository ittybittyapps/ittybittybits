//
//  BreadCrumbPath.h
//  CustomFleet
//
//  Created by Oliver Jones on 27/06/11.
//  Copyright 2011 GE Capital Australia & New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <vector>

@class BreadcrumbPathInternal;

@interface BreadcrumbPath : NSObject <MKOverlay> {
@private
    BreadcrumbPathInternal *internal;
    MKMapRect boundingMapRect;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) MKMapRect boundingMapRect;
@property (nonatomic, readonly) std::vector<MKMapPoint> mapPoints;

- (id)initWithCenterCoordinate:(CLLocationCoordinate2D)coord;
- (MKMapRect)addCoordinate:(CLLocationCoordinate2D)coord;

@end
