//
//  NSError+IBACoreDataErrors.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/07/11.
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

#import "NSError+IBACoreDataErrors.h"
#import <CoreData/CoreData.h>

#import "../Foundation/IBAFoundation.h"

static NSInteger CoreDataValidationErrorCodes[] = {
    NSManagedObjectValidationError,
    NSValidationMultipleErrorsError,
    NSValidationMissingMandatoryPropertyError,
    NSValidationRelationshipLacksMinimumCountError,
    NSValidationRelationshipExceedsMaximumCountError,
    NSValidationRelationshipDeniedDeleteError,
    NSValidationNumberTooLargeError,
    NSValidationNumberTooSmallError,
    NSValidationDateTooLateError,
    NSValidationDateTooSoonError,
    NSValidationInvalidDateError,
    NSValidationStringTooLongError,
    NSValidationStringTooShortError,
    NSValidationStringPatternMatchingError
};

@implementation NSError (IBACoreDataErrors)

- (BOOL)ibaIsCoreDataValidationError
{
    return ([[self domain] isEqualToString:NSCocoaErrorDomain] && 
            IBAArrayContains(CoreDataValidationErrorCodes, [self code]));
}

- (NSArray *)ibaCoreDataValidationErrors
{
    if ([self ibaIsCoreDataValidationError])
    {
        return [[self userInfo] objectForKey:NSDetailedErrorsKey];
    }
    
    return [NSArray array];
}

- (NSArray *)ibaCoreDataValidationErrorsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSArray *validationErrors = [self ibaCoreDataValidationErrors];
    NSIndexSet *indexes = [validationErrors indexesOfObjectsPassingTest:predicate];
    return [validationErrors objectsAtIndexes:indexes];
}

@end
