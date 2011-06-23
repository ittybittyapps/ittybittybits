//
//  IBACoreDataContextProvider.m
//  IttyBittyBits
//
//  Created by Sean Woodhouse on 22/06/11.
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

#import "IBACoreDataContextProvider.h"
#import "IBACommon.h"
#import "IBASynthesizeSingleton.h"
#import "IBALogger.h"

#define kCoreDataErrorTitle @"Application Error"
#define kCoreDataErrorClose @"Close Application"

@interface IBACoreDataContextProvider () 
@property (nonatomic, retain) NSArray *resourceBundles;
- (NSURL *)persistentStoreURL;
- (NSString *)persistentStorePath;
- (NSString *)applicationDocumentsDirectory;
- (void)mocSaveNotification:(NSNotification*)saveNotification;
- (void)enableFileProtectionAttributeOnPersistentStoreFile;
@end


@implementation IBACoreDataContextProvider

IBA_SYNTHESIZE_SINGLETON_FOR_CLASS(IBACoreDataContextProvider, sharedIBACoreDataContextProvider);

IBA_SYNTHESIZE(resourceBundles);
IBA_SYNTHESIZE(fileProtectionEnabled);

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	IBA_RELEASE_PROPERTY(managedObjectContext);
    IBA_RELEASE_PROPERTY(managedObjectModel);
    IBA_RELEASE_PROPERTY(persistentStoreCoordinator);
	
    [super dealloc];
}

- (id)init 
{
	return [self initWithResourceBundles:[NSArray array]];
}

- (id)initWithResourceBundles:(NSArray *)resourceBundles 
{
	if ((self = [super init])) 
    {
		self.resourceBundles = resourceBundles;
		
		// Listen for changes in other managed object contexts
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mocSaveNotification:) 
													 name:NSManagedObjectContextDidSaveNotification object:nil];
	}
	
	return self;
}

- (NSManagedObjectContext *)newManagedObjectContext 
{
	NSManagedObjectContext *context = nil;
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator: coordinator];
    }
	
	return context;
}


/*!
 \brief     Returns the managed object context for the application.
 \details   If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext 
{
    NSManagedObjectContext *context = managedObjectContext_;
	
	if (context == nil) {
        context = [self newManagedObjectContext];
		managedObjectContext_ = context;
    }
	
    return context;
}


/*!
 \brief     Returns the managed object model for the application.
 \details   If the model doesn't already exist, it is created by merging all of the models found in the application bundles.
 */
- (NSManagedObjectModel *)managedObjectModel
{	
    if (managedObjectModel_ == nil) {		
		NSMutableSet *allBundles = [[[NSMutableSet alloc] init] autorelease];
		NSArray *bundles = [NSBundle allBundles];
        [allBundles addObjectsFromArray:bundles];
		[allBundles addObjectsFromArray:self.resourceBundles];
        managedObjectModel_ = [[NSManagedObjectModel mergedModelFromBundles:[allBundles allObjects]] retain];
    }

    return managedObjectModel_;
}


- (NSString *)persistentStorePath
{
	// TODO make the store file path configurable
	return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL *)persistentStoreURL
{
	return [NSURL fileURLWithPath:[self persistentStorePath]];
}


/*!
 \brief     Returns the persistent store coordinator for the application.
 \details   If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{	
    if (persistentStoreCoordinator_ != nil) return persistentStoreCoordinator_;
	
	NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:nil error:&error])
    {
		[self handleCoreDataError:error];
    }
	
	if (self.fileProtectionEnabled)
    {
		[self enableFileProtectionAttributeOnPersistentStoreFile];
	}
	
    return persistentStoreCoordinator_;
}

/*!
 \brief     Enables or disables file protection for the Core Data database.
 \details   When this property is set to YES, if a persistentStore exists already, the File Protection attribute will be set. If the persistentStore doesn't exist yet, the attribute will be set when -persistentStoreCoordinator creates the store.
 */
- (void)setFileProtectionEnabled:(BOOL)enabled
{
	fileProtectionEnabled_ = enabled;
	if (fileProtectionEnabled_ && (persistentStoreCoordinator_ != nil))
    {
		[self enableFileProtectionAttributeOnPersistentStoreFile];
	}
}

- (void)enableFileProtectionAttributeOnPersistentStoreFile
{
	// If File Protection isn't available (because we are on an iOS version pre-4.0), bail
	if ([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] < 4) return;
		
	if (persistentStoreCoordinator_ != nil) 
    {
		NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
		NSError *error = nil;
		if (![[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:[self persistentStorePath] error:&error])
        {
			[self handleCoreDataError:error];
		}
	}
}	

- (void)handleCoreDataError:(NSError *)error
{
	IBALogError(@"CoreData error: %@", [error localizedDescription]);
	NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
	if (detailedErrors != nil && [detailedErrors count] > 0) 
    {
		for (NSError* detailedError in detailedErrors)
        {
			IBALogError(@"  DetailedError: %@", [detailedError userInfo]);
		}
	}
	else
    {
		IBALogError(@"  %@", [error userInfo]);
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kCoreDataErrorTitle 
													message:[error localizedDescription] 
												   delegate:nil 
										  cancelButtonTitle:kCoreDataErrorClose 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


- (void)deletePersistentStore
{
	NSError *error = nil;
	[self.persistentStoreCoordinator removePersistentStore:[[self persistentStoreCoordinator] persistentStoreForURL:[self persistentStoreURL]] error:&error];
	NSString *storePath = [self persistentStorePath];
	[[NSFileManager defaultManager] removeItemAtPath:storePath error:&error];
	
	IBA_RELEASE_PROPERTY(managedObjectContext);
	IBA_RELEASE_PROPERTY(persistentStoreCoordinator);
}


/**
 Returns the path to the application's Documents directory.
 */
/*!
 \brief     Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Merging changes from other NSManagedObjectContexts

- (void)mocSaveNotification:(NSNotification*)saveNotification
{
	if (saveNotification.object != self.managedObjectContext) 
    {
		// merge changes in to provider's managed object context (and make sure we do it in the main thread)
		[self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) 
													  withObject:saveNotification waitUntilDone:YES];	
	}
}

@end
