//
//  NSError+IBACoreDataErrors.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (IBACoreDataErrors)

- (BOOL)ibaIsCoreDataValidationError;
- (NSArray *)ibaCoreDataValidationErrors;
- (NSArray *)ibaCoreDataValidationErrorsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

@end
