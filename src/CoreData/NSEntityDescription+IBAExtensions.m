//
//  NSEntityDescription+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSEntityDescription+IBAExtensions.h"


@implementation NSEntityDescription (IBAExtensions)

- (NSAttributeDescription*) ibaAttributeByName:(NSString *)name
{
    NSDictionary *attributes = [self attributesByName];
    return [attributes objectForKey:name];
}

@end
