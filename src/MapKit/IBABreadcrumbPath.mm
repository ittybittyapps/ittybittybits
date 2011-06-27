//
//  BreadCrumbPath.mm
//  CustomFleet
//
//  Created by Oliver Jones on 27/06/11.
//  Copyright 2011 GE Capital Australia & New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <vector>

#import "BreadCrumbPath.hh"


#define MINIMUM_DELTA_METERS 5.0

@interface BreadcrumbPathInternal : NSObject
{
@private
    pthread_rwlock_t rwLock;
@public
    std::vector<MKMapPoint> mapPoints;
}

- (id)initWithCenterCoordinate:(CLLocationCoordinate2D)coord;

@end

@implementation BreadcrumbPathInternal

- (id)initWithCenterCoordinate:(CLLocationCoordinate2D)coord
{
    if ((self = [super init]))
    {
        pthread_rwlock_init(&rwLock, NULL);

        mapPoints.push_back(MKMapPointForCoordinate(coord));
    }
    
    return self;
}

- (void)dealloc
{
    pthread_rwlock_destroy(&rwLock);
    [super dealloc];
}

- (void)lockForReading
{
    pthread_rwlock_rdlock(&rwLock);
}

- (void)unlockForReading
{
    pthread_rwlock_unlock(&rwLock);
}

- (MKMapRect)addCoordinate:(CLLocationCoordinate2D)coord
{
    pthread_rwlock_wrlock(&rwLock);
    
    // Convert a CLLocationCoordinate2D to an MKMapPoint
    MKMapPoint newPoint = MKMapPointForCoordinate(coord);
    MKMapPoint prevPoint = mapPoints.back();
    
    // Get the distance between this new point and the previous point.
    CLLocationDistance metersApart = MKMetersBetweenMapPoints(newPoint, prevPoint);
    MKMapRect updateRect = MKMapRectNull;
    
    if (metersApart > MINIMUM_DELTA_METERS)
    {
        NSLog(@"Added mappoint: %f, %f", newPoint.x, newPoint.y);
        mapPoints.push_back(newPoint);
        
        // Compute MKMapRect bounding prevPoint and newPoint
        double minX = MIN(newPoint.x, prevPoint.x);
        double minY = MIN(newPoint.y, prevPoint.y);
        double maxX = MAX(newPoint.x, prevPoint.x);
        double maxY = MAX(newPoint.y, prevPoint.y);
        
        updateRect = MKMapRectMake(minX, minY, maxX - minX, maxY - minY);
        NSLog(@"updateRect: x:%f, y:%f, w:%f, h:%f", 
              updateRect.origin.x, 
              updateRect.origin.y, 
              updateRect.size.width, 
              updateRect.size.height);
    }
    else
    {
        NSLog(@"Map points not min %fm apart (%fm)", MINIMUM_DELTA_METERS, metersApart);
    }
    
    pthread_rwlock_unlock(&rwLock);
    
    return updateRect;
}

@end


@implementation BreadcrumbPath


- (id)initWithCenterCoordinate:(CLLocationCoordinate2D)coord
{
    if ((self = [super init]))
    {
        internal = [[BreadcrumbPathInternal alloc] initWithCenterCoordinate:coord];
        
        // bite off up to 1/4 of the world to draw into.
        MKMapSize size = MKMapSizeMake(MKMapSizeWorld.width/4.0, MKMapSizeWorld.height / 4.0);
        MKMapPoint origin = MKMapPointForCoordinate(coord);
        origin.x -= MKMapSizeWorld.width / 8.0;
        origin.y -= MKMapSizeWorld.height / 8.0;
        
        boundingMapRect = MKMapRectIntersection(MKMapRectMake(origin.x, origin.y, size.width, size.height), 
                                                MKMapRectMake(0, 0, MKMapSizeWorld.width, MKMapSizeWorld.height));
    }
    
    return self;
}

- (void)dealloc
{
    IBA_RELEASE(internal);
    
    [super dealloc];
}

- (CLLocationCoordinate2D)coordinate
{
    [internal lockForReading];
    CLLocationCoordinate2D coord = MKCoordinateForMapPoint(internal->mapPoints[0]);
    [internal unlockForReading];
    
    return coord;
}

- (MKMapRect)boundingMapRect
{
    return boundingMapRect;
}

- (MKMapRect)addCoordinate:(CLLocationCoordinate2D)coord
{
    return [internal addCoordinate:coord];
}

- (std::vector<MKMapPoint>) mapPoints
{
    [internal lockForReading];
    std::vector<MKMapPoint> r(internal->mapPoints);
    [internal unlockForReading];

    return r;
}

@end