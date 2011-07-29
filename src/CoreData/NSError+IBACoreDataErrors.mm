//
//  NSError+IBACoreDataErrors.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

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
