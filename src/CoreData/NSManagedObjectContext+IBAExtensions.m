//
//  NSManagedObjectContext.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSManagedObjectContext+IBAExtensions.h"
#import <CoreData/CoreData.h>

@implementation NSManagedObjectContext (IBAExtensions)

- (NSArray *)executeFetchRequest:(NSFetchRequest*)request errorHandler:(void(^)(NSError *error))errorHandler
{
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error != nil && errorHandler != nil)
    {
        errorHandler(error);
    }
    
    return results;
}


@end
