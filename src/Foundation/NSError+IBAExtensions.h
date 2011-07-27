//
//  NSError+IBAExtensions.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 20/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (IBAExtensions)

+ (NSError *)ibaErrorWithDomain:(NSString *)domain 
                           code:(NSInteger)errorCode 
           localizedDescription:(NSString *)description;

@end
