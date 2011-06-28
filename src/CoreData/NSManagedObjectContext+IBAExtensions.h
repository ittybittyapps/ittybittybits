//
//  NSManagedObjectContext.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (IBAExtensions)

- (NSArray *)executeFetchRequest:(NSFetchRequest*)request errorHandler:(void(^)(NSError *error))errorHandler;

@end
