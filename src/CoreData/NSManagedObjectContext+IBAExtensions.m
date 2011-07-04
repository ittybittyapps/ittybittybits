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

#import "NSManagedObjectContext+IBAExtensions.h"
#import "NSFetchRequest+IBAExtensions.h"
#import <CoreData/CoreData.h>

@implementation NSManagedObjectContext (IBAExtensions)

- (NSUInteger)ibaCountForFetchRequest:(NSFetchRequest*)request errorHandler:(void(^)(NSError *error))errorHandler
{
    NSError *error = nil;
    NSUInteger count = [self countForFetchRequest:request error:&error];
    if (error != nil && errorHandler != nil)
    {
        errorHandler(error);
    }
    
    return count;
}

- (NSArray *)ibaExecuteFetchRequest:(NSFetchRequest*)request errorHandler:(void(^)(NSError *error))errorHandler
{
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error != nil && errorHandler != nil)
    {
        errorHandler(error);
    }
    
    return results;
}

- (NSArray *)ibaExecuteFetchRequestForEntity:(NSString *)entityName 
                            withErrorHandler:(void(^)(NSError *error))errorHandler 
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

- (BOOL)ibaSaveWithErrorHandler:(void(^)(NSError *error))errorHandler
{
    NSError *error = nil;
    
    BOOL result = [self save:&error];
    
    if (error != nil && errorHandler)
    {
        errorHandler(error);
    }
    
    return result;
}

@end
