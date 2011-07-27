//
//  NSError+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 20/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSError+IBAExtensions.h"

@implementation NSError (IBAExtensions)

+ (NSError *)ibaErrorWithDomain:(NSString *)domain 
                           code:(NSInteger)errorCode 
           localizedDescription:(NSString *)description
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    return [[[NSError alloc] initWithDomain:domain code:errorCode userInfo:userInfo] autorelease];
}

@end
