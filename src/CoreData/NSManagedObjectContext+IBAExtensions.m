//
//  NSManagedObjectContext.m
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

#import <CoreData/CoreData.h>

#import "NSManagedObjectContext+IBAExtensions.h"
#import "NSFetchRequest+IBAExtensions.h"

#import "../Foundation/IBAErrors.h"

@implementation NSManagedObjectContext (IBAExtensions)

- (NSUInteger)ibaCountForFetchRequest:(NSFetchRequest*)request errorHandler:(IBAErrorHandler)errorHandler
{
    NSError *error = nil;
    NSUInteger count = [self countForFetchRequest:request error:&error];
    if (count == NSNotFound && errorHandler)
    {
        errorHandler(error);
    }
    
    return count;
}

- (NSArray *)ibaExecuteFetchRequest:(NSFetchRequest*)request errorHandler:(IBAErrorHandler)errorHandler
{
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (results == nil && errorHandler)
    {
        errorHandler(error);
    }
    
    return results;
}

- (NSArray *)ibaExecuteFetchRequestForEntity:(NSString *)entityName 
                            withErrorHandler:(IBAErrorHandler)errorHandler 
                                forPredicate:(id)stringOrPredicate, ...
{
    va_list variadicArguments;
    va_start(variadicArguments, stringOrPredicate);

    NSFetchRequest* request = [NSFetchRequest ibaFetchRequestForEntity:entityName 
                                                             inContext:self
                                                         withPredicate:stringOrPredicate 
                                                                  args:variadicArguments];
    
    return [self ibaExecuteFetchRequest:request errorHandler:errorHandler];
}

- (BOOL)ibaSaveWithErrorHandler:(IBAErrorHandler)errorHandler
{
    NSError *error = nil;
    
    BOOL result = [self save:&error];
    
    if (result == NO && errorHandler)
    {
        errorHandler(error);
    }
    
    return result;
}

/*!
 \brief     Delete the entities matching the specified predicate.
 \param     entityName      The name of the entities to delete.
 \param     errorHandler    The error handler to invoke if the delete operation fails.
 \param     stringOrPredicate   The predicate instance or string predicate to match with.
 */
- (void)ibaDeleteEntitiesNamed:(NSString *)entityName 
              withErrorHandler:(IBAErrorHandler)errorHandler 
             matchingPredicate:(id)stringOrPredicate, ...
{
    va_list args;
    va_start(args, stringOrPredicate);
    NSFetchRequest *request = [NSFetchRequest ibaFetchRequestForEntity:entityName
                                                             inContext:self
                                                         withPredicate:stringOrPredicate 
                                                                  args:args];
    va_end(args);
    
    [request setIncludesPropertyValues:NO];
    [request setIncludesSubentities:NO];
    
    NSArray *a = [self ibaExecuteFetchRequest:request errorHandler:errorHandler];
    if (a)
    {
        for (NSManagedObject *o in a) 
        {
            [self deleteObject:o];
        }
    }
}

@end
