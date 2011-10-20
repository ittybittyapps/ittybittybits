//
//  NSPropertyListSerialization+IBAExtensions.m
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

#import "NSPropertyListSerialization+IBAExtensions.h"
#import "NSError+IBAExtensions.h"

NSString * const IBAPropertyListSerializationErrorDomain = @"com.ittybittyapps.extensions.NSPropertyListSerializationErrorDomain";

@implementation NSPropertyListSerialization (IBAExtensions)

/*!
 \brief     Returns a dictionary containing the contents of a property list.
 \param     plistPath       The file path of the property list to read.
 \param     format          The format of the property list.
 \param     error           Set if an error occurs.
 \return    A dictionary containing the contents of the property list file on success; otherwise nil.
 */
+ (NSDictionary *)ibaDictionaryFromPropertyList:(NSString *)plistPath format:(NSPropertyListFormat)format error:(NSError **)error
{
    NSString *errorDesc = nil;

    NSData *plistData = [NSData dataWithContentsOfMappedFile:plistPath];
    NSDictionary *temp = [NSPropertyListSerialization propertyListFromData:plistData
                                                          mutabilityOption:NSPropertyListImmutable
                                                                    format:&format
                                                          errorDescription:&errorDesc];
    if (temp == nil && error)
    {
        *error = [NSError ibaErrorWithDomain:IBAPropertyListSerializationErrorDomain 
                                        code:IBAPropertyListSerializationErrorLoadFailed 
                        localizedDescription:errorDesc];
    }
    
    IBA_RELEASE(errorDesc);
    return temp;
}

@end
