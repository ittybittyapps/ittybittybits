//
//  NSMutableDictionary+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 11/07/11.
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

#import "NSMutableDictionary+IBAExtensions.h"
#import "NSNumber+IBAExtensions.h"

@implementation NSMutableDictionary (IBAExtensions)

- (void)ibaSetObject:(id)object forUIntegerKey:(NSUInteger)key
{
    [self setObject:object forKey:IBAUIntegerToNumber(key)];
}

- (void)ibaSetObject:(id)object forIntegerKey:(NSInteger)key
{
    [self setObject:object forKey:IBAIntegerToNumber(key)];
}

/*!
 \brief     Returns the value associated with a given key.  If no value exists in the dictionary for the specified \a key the \a factory block is invoked and the retured result is added to the dictionary for \a key.
 \return    The value associated with \a key, or the result of invoking the \a factory if no value is associated with \a key.
 */
- (id)ibaObjectForKey:(id)key setDefaultUsingBlock:(IBAObjectFactory)factory
{
    id o = [self objectForKey:key];
    if (o == nil)
    {
        o = factory();
        [self setObject:o forKey:key];
    }
    
    return o;
}


@end
