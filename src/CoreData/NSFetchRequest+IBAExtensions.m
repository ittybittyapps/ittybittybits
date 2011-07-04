//
//  NSFetchRequest+IBAExtensions.m
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


#import "NSFetchRequest+IBAExtensions.h"
#import "NSEntityDescription+IBAExtensions.h"

#import <objc/runtime.h>

@implementation NSFetchRequest (IBAExtensions)

+ (id)ibaFetchRequestForEntity:(NSString *)entityName inContext:(NSManagedObjectContext*)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    [request setEntity:entity];
    [request setResultType:NSManagedObjectResultType];
    
    return request;
}


+ (id)ibaDictionaryFetchRequestForEntity:(NSString *)entityName inContext:(NSManagedObjectContext*)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    
    return request;
}

+ (id)ibaFetchRequestForEntity:(NSString *)entityName 
                     inContext:(NSManagedObjectContext *)context
                 withPredicate:(id)stringOrPredicate 
                          args:(va_list)variadicArguments
{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
    
    if (stringOrPredicate)
    {
        NSPredicate *predicate;
        if ([stringOrPredicate isKindOfClass:[NSString class]])
        {
            predicate = [NSPredicate predicateWithFormat:stringOrPredicate
                                               arguments:variadicArguments];
        }
        else
        {
            NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
                      @"Second parameter passed to %s is of unexpected class %@",
                      sel_getName(_cmd), class_getName([stringOrPredicate class]));
            predicate = (NSPredicate *)stringOrPredicate;
        }
        
        [request setPredicate:predicate];
    }
    
    return request;
}

+ (id)ibaFetchRequestForEntity:(NSString *)entityName 
                     inContext:(NSManagedObjectContext *)context
                 withPredicate:(id)stringOrPredicate, ...
{
    va_list variadicArguments;
    va_start(variadicArguments, stringOrPredicate);
    NSFetchRequest *request = [[self class] ibaFetchRequestForEntity:entityName 
                                                           inContext:context 
                                                       withPredicate:stringOrPredicate 
                                                                args:variadicArguments];
    va_end(variadicArguments);
    return request;
}


@end
