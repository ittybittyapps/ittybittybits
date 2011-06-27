//
//  IBAAbstractCoreDataService.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 24/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface IBAAbstractCoreDataService : NSObject 
{
@private
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *defaultManagedObjectContext;

- (id) initWithObjectModelURL:(NSURL *)modelURL
                     storeURL:(NSURL *)storeURL;

- (NSManagedObjectContext *)newManagedObjectContext;
- (NSManagedObject *) insertNewObjectForEntityForName:(NSString *)entityName;
- (void)save;


@end
