//
//  NSMutableSet+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 25/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSMutableSet+IBAExtensions.h"

@implementation NSMutableSet (IBAExtensions)

/*!
 \brief     Removes all occurrences in the array of a given array if objects.
 \param     objects     An array of objects to remove.
 */
- (void)ibaRemoveObjectsInArray:(NSArray *)objects
{
    for (id o in objects) 
    {
        [self removeObject:o];
    }
}

@end
