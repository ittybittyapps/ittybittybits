//
//  NSObject+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 7/07/11.
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

#import "NSObject+IBAExtensions.h"

@implementation NSObject (IBAExtensions)

/*!
 \brief     Registers \ anObserver to receive KVO notifications for the specified \a keyPaths relative to the receiver.
 \details   Neither the receiver, nor anObserver, are retained.
 
 \param     anObserver
 The object to register for KVO notifications. The observer must implement the key-value observing method observeValueForKeyPath:ofObject:change:context:.
 
 \param     keyPaths
 The key paths, relative to the receiver, of the properties to observe. This value must not be nil.
 
 \param     options
 A combination of the NSKeyValueObservingOptions values that specifies what is included in observation notifications.
 
 \param     context
 Arbitrary data that is passed to anObserver in observeValueForKeyPath:ofObject:change:context:.
 
 \sa        ibaRemoveObserver:forKeyPaths:
 */
- (void)ibaAddObserver:(NSObject *)anObserver forKeyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options context:(void *)context
{
    for (NSString *keyPath in keyPaths)
    {
        [self addObserver:anObserver forKeyPath:keyPath options:options context:context];
    }
}

/*!
 \brief     Stops a given object from receiving change notifications for the properties specified by a given keyPaths relative to the receiver.
 \param      anObserver
 The object to remove as an observer.
 
 \param     keyPaths
 The key-paths, relative to the receiver, for which anObserver is registered to receive KVO change notifications.
 
 \sa        ibaAddObserver:forKeyPaths:options:context:
 */
- (void)ibaRemoveObserver:(NSObject *)anObserver forKeyPaths:(NSArray *)keyPaths
{
    for (NSString *keyPath in keyPaths)
    {
        [self removeObserver:anObserver forKeyPath:keyPath];
    }
}

@end
