//
//  NSManagedObjectContext.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/06/11.
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

#import "../Foundation/IBAErrors.h"

@interface NSManagedObjectContext (IBAExtensions)

- (NSUInteger)ibaCountForFetchRequest:(NSFetchRequest*)request 
                         errorHandler:(IBAErrorHandler)errorHandler;

- (NSArray *)ibaExecuteFetchRequest:(NSFetchRequest*)request 
                       errorHandler:(IBAErrorHandler)errorHandler;

- (NSArray *)ibaExecuteFetchRequestForEntity:(NSString *)entityName 
                            withErrorHandler:(IBAErrorHandler)errorHandler 
                                forPredicate:(id)stringOrPredicate, ...;

- (BOOL)ibaSaveWithErrorHandler:(IBAErrorHandler)errorHandler;

- (void)ibaDeleteEntitiesNamed:(NSString *)entityName 
              withErrorHandler:(IBAErrorHandler)errorHandler 
             matchingPredicate:(id)stringOrPredicate, ...;

@end
