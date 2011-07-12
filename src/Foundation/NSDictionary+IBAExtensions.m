//
//  NSDictionary+IBHelper.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 18/05/11.
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

#import "NSDictionary+IBAExtensions.h"


@implementation NSDictionary (IBAExtensions)


/*!
 \brief     Returns the value associated with a given \a key; or \a defaultValue if no value is associated with the given \a key.
 */
- (id)ibaObjectForKey:(id)key default:(id)defaultValue
{
    id o = [self objectForKey:key];
    return o != nil ? o : defaultValue;   
}

/*!
 \brief     Get a string for the specified dictionary \a key.
 */
- (NSString *)ibaStringForKey:(id)key
{
    id o = [self objectForKey:key];
    return (NSString *)o;
}

/*!
 \brief     Returns the object associated with a given NSUInteger \a key.
 */
- (id)ibaObjectForUIntegerKey:(NSUInteger)key
{
    NSNumber* number = [NSNumber numberWithUnsignedInteger:key];
    return [self objectForKey:number];
}

/*!
 \brief     Returns the object associated with a given NSInteger \a key.
 */
- (id)ibaObjectForIntegerKey:(NSInteger)key
{
    NSNumber* number = [NSNumber numberWithInteger:key];
    return [self objectForKey:number];
}


@end
