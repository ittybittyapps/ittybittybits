//
//  IBAAbstractCoreDataService.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 24/06/11.
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


#import "IBAAbstractCoreDataService.h"
#import "../Foundation/IBAFoundation.h"


@interface IBAAbstractCoreDataService ()

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSPersistentStoreCoordinator *)newPersistentStoreCoordinatorWithObjectModel:(NSManagedObjectModel *)model 
                                                                      storeURL:(NSURL*)storeURL;

- (void) handleUnresolvedError:(NSError *)error;
@end

@implementation IBAAbstractCoreDataService

IBA_SYNTHESIZE(defaultManagedObjectContext, 
               managedObjectModel, 
               persistentStoreCoordinator,
               delegate);

- (id) initWithObjectModelURL:(NSURL *)modelURL
                     storeURL:(NSURL *)storeURL
{
    if ((self = [super init]))
    {
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        IBA_PROPERTY_IVAR(managedObjectModel) = model;
        IBA_PROPERTY_IVAR(persistentStoreCoordinator) = [self newPersistentStoreCoordinatorWithObjectModel:model 
                                                                                                  storeURL:storeURL];
        IBA_PROPERTY_IVAR(defaultManagedObjectContext) = [self newManagedObjectContext];
    }
    
    return self;
}

/*!
 Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.delegate = nil;
    
    IBA_RELEASE_PROPERTY(defaultManagedObjectContext);
    IBA_RELEASE_PROPERTY(managedObjectModel);
    IBA_RELEASE_PROPERTY(persistentStoreCoordinator);
    
    [super dealloc];

}

/*!
 \brief     Subclasses should override this method to better handle unresolved errors.
 \details   The default implementation calls abort() and will crash the app.
 */
- (void) handleUnresolvedError:(NSError *)error
{
    IBALogCritical(@"Unresolved error %@, %@", error, [error localizedDescription]);
    NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    if (detailedErrors != nil && [detailedErrors count] > 0) 
    {
        for (NSError* detailedError in detailedErrors) 
        {
            IBALogCritical(@"  DetailedError: %@", [detailedError userInfo]);
        }
    }
    else {
        IBALogCritical(@"  %@", [error userInfo]);
    }
    
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
     */ 
    
    // FIXME: Not so much handling going on here.
    abort();
}

/*!
 \brief     Save the managed object context.
 */
- (void)save
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.defaultManagedObjectContext;
    if ([managedObjectContext hasChanges] && [managedObjectContext save:&error] == NO)
    {
        if ([self.delegate respondsToSelector:@selector(dataService:didFailToSaveManagedObjectContext:withError:)] == NO ||
            [self.delegate dataService:self didFailToSaveManagedObjectContext:managedObjectContext withError:error] == NO)
        {
            [self handleUnresolvedError:error];
        }
    }     
}

/*!
 \brief     Create a new object context tied to the service's persistent store.
 \details   Changes made to managed object contexts constructed from this factory will be automatically merged into the defaultManagedObjectContext associated with the Data Service upon save.
 */
- (NSManagedObjectContext *)newManagedObjectContext 
{
	NSManagedObjectContext *context = [NSManagedObjectContext new];
    context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    // Listen for changes in other managed object contexts
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(processManagedObjectContextDidSaveNotification:) 
                                                 name:NSManagedObjectContextDidSaveNotification 
                                               object:context];
    
	return context;
}

/*!
 \brief     Subclasses can override this this method to respond to errors adding the persistent store to the coordinator.
 \return    YES to retry creating the persistent store coordinator; otherwise NO.
 
 Typical reasons for an error here include:
 * The persistent store is not accessible;
 * The schema for the persistent store is incompatible with current managed object model.
 Check the error message to determine what the actual problem was.
 
 If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
 
 If you encounter schema incompatibility errors during development, you can reduce their frequency by:
 * Simply deleting the existing store:
 [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
 
 * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
 [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
 
 Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
 */
- (BOOL) shouldRetryAddingPersistentStoreForModel:(NSManagedObjectModel *)model 
                                         storeURL:(NSURL *)storeURL 
                                        withError:(NSError *)error
{
    [self handleUnresolvedError:error];
    return NO;
}

/*!
 \brief     Factory method to create a persistent store cooridinator with the specified \a model and \a storeURL.
 */
- (NSPersistentStoreCoordinator *)newPersistentStoreCoordinatorWithObjectModel:(NSManagedObjectModel *)model 
                                                                      storeURL:(NSURL*)storeURL
{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    BOOL retry = NO;
    do {
        NSError *error = nil;
        if ([coordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                      configuration:nil 
                                                URL:storeURL 
                                            options:nil 
                                              error:&error] == NO)
        {
            retry = [self shouldRetryAddingPersistentStoreForModel:model storeURL:storeURL withError:error];   
        }
    } while (retry);        
    
    return coordinator;
}

- (void)processManagedObjectContextDidSaveNotification:(NSNotification*)saveNotification
{
    BOOL shouldMerge = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldDataService:mergeChangesFromContext:)])
    {
        shouldMerge = [self.delegate shouldDataService:self mergeChangesFromContext:saveNotification.object];
    }
    
    if (shouldMerge)
    {
        // I don't think it is actually necessary to perform mergeChangesFromContextDidSaveNotification on the main thread but we do it anyway to be safe.
        [self.defaultManagedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) 
                                                           withObject:saveNotification 
                                                        waitUntilDone:YES];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataService:didMergeSavedChangesFromContext:)])
        {
            [self.delegate dataService:self didMergeSavedChangesFromContext:saveNotification.object];
        }
    }
}

@end
