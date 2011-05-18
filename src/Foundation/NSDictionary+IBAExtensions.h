//
//  NSDictionary+IBHelper.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 18/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (IBAExtensions)

- (id)objectForKey:(id)key default:(id)defaultValue;
- (NSString *)stringForKey:(id)key;
- (id)objectForUIntegerKey:(NSUInteger)key;
- (id)objectForIntegerKey:(NSInteger)key;

@end
