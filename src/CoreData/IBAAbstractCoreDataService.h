//
//  IBAAbstractCoreDataService.h
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

- (BOOL)        shouldDataService:(IBAAbstractCoreDataService *)dataService
          mergeChangesFromContext:(NSManagedObjectContext*)context;

- (void)              dataService:(IBAAbstractCoreDataService *)dataService
  didMergeSavedChangesFromContext:(NSManagedObjectContext*)context;
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
