//
//  NSFetchRequest+IBAExtensions.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSFetchRequest (IBAExtensions)

+ (id) newDictionaryFetchRequestForEntity:(NSString *)entityName inContext:(NSManagedObjectContext*)context;

@end
