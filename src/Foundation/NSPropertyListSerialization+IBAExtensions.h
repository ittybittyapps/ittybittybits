//
//  NSPropertyListSerialization+IBAExtensions.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 23/09/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
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

#import <Foundation/Foundation.h>
#import "IBACommon.h"

typedef enum {
    IBAPropertyListSerializationErrorLoadFailed
} IBAPropertyListSerializationErrorCodes;

IBA_EXTERN NSString * const IBAPropertyListSerializationErrorDomain;

@interface NSPropertyListSerialization (IBAExtensions)
+ (NSDictionary *)ibaDictionaryFromPropertyList:(NSString *)plistPath error:(NSError **)error;
+ (NSDictionary *)ibaDictionaryFromPropertyListData:(NSData *)data error:(NSError **)error;
@end
