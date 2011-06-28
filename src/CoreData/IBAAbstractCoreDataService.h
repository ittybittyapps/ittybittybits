//
//  IBAAbstractCoreDataService.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 24/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IBAAbstractCoreDataService;

@protocol IBAAbstractCoreDataServiceDelegate <NSObject>

/*!
 \brief     Notifies the delegate that the \a context failed to save the managed object \a context.
 \param     dataService The IBAAbstractCoreDataService instance.
 \param     context     The NSManagedObjectContext instance that failed to save.
 \param     error       The error generated.
 \return    YES if the error was resolved/handled; NO if the IBAAbstractCoreDataService should perform its own default error handling.
 */
@optional
- (BOOL)              dataService:(IBAAbstractCoreDataService *)dataService
didFailToSaveManagedObjectContext:(NSManagedObjectContext*)context 
                        withError:(NSError*)error;
@end

@interface IBAAbstractCoreDataService : NSObject 
{
@private
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *defaultManagedObjectContext;
@property (nonatomic, assign) id<IBAAbstractCoreDataServiceDelegate> delegate;

- (id) initWithObjectModelURL:(NSURL *)modelURL
                     storeURL:(NSURL *)storeURL;

- (NSManagedObjectContext *)newManagedObjectContext;
- (void)save;

- (BOOL) shouldRetryAddingPersistentStoreForModel:(NSManagedObjectModel *)model 
                                         storeURL:(NSURL *)storeURL 
                                        withError:(NSError *)error;

- (void) handleUnresolvedError:(NSError *)error;
@end
