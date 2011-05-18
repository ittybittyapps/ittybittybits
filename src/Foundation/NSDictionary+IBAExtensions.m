//
//  NSDictionary+IBHelper.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 18/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSDictionary+IBAExtensions.h"


@implementation NSDictionary (IBAExtensions)


/*!
 \brief     Returns the value associated with a given \a key; or \a defaultValue if no value is associated with the given \a key.
 */
- (id)objectForKey:(id)key default:(id)defaultValue
{
    id o = [self objectForKey:key];
    return o != nil ? o : defaultValue;   
}

/*!
 \brief     Get a string for the specified dictionary \a key.
 */
- (NSString *)stringForKey:(id)key
{
    id o = [self objectForKey:key];
    return (NSString *)o;
}

/*!
 \brief     Returns the object associated with a given NSUInteger \a key.
 */
- (id)objectForUIntegerKey:(NSUInteger)key
{
    NSNumber* number = [NSNumber numberWithUnsignedInteger:key];
    return [self objectForKey:number];
}

/*!
 \brief     Returns the object associated with a given NSInteger \a key.
 */
- (id)objectForIntegerKey:(NSInteger)key
{
    NSNumber* number = [NSNumber numberWithInteger:key];
    return [self objectForKey:number];
}


@end
