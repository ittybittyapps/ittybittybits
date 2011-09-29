//
//  NSIndexPath+UITableView+IBAExtensions.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 14/09/11.
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
#import "../Foundation/IBACommon.h"

#define IBA_NSINDEXPATH_ROW_IS_SIGNED defined(__IPHONE_5_0)
#define IBA_NSINDEXPATH_SECTION_IS_SIGNED defined(__IPHONE_5_0)

#if defined(__IPHONE_5_0)
// fucking iOS SDK bugs!
typedef NSInteger IBAIndexPathRowType;
typedef NSInteger IBAIndexPathSectionType;
#else
typedef NSUInteger IBAIndexPathRowType;
typedef NSUInteger IBAIndexPathSectionType;
#endif

#if IBA_NSINDEXPATH_ROW_IS_SIGNED
#   define IBANSUIntegerToIBAIndexPathRowType(value) IBANSUIntegerToNSInteger((value))
#   define IBAIndexPathRowTypeToNSUInteger(value) IBANSIntegerToNSUInteger((value))
#   define IBAIndexPathRowTypeToNSInteger(value) (value)
#else
#   define IBANSUIntegerToIBAIndexPathRowType(value) (value)
#   define IBAIndexPathRowTypeToNSUInteger(value) (value)
#   define IBAIndexPathRowTypeToNSInteger(value) IBANSUIntegerToNSInteger(value)
#endif

#if IBA_NSINDEXPATH_SECTION_IS_SIGNED
#   define IBANSUIntegerToIBAIndexPathSectionType(value) IBANSUIntegerToNSInteger(value)
#   define IBAIndexPathSectionTypeToNSUInteger(value) IBANSIntegerToNSUInteger(value)
#   define IBAIndexPathSectionTypeToNSInteger(value) (value)
#else
#   define IBANSUIntegerToIBAIndexPathSectionType(value) (value)
#   define IBAIndexPathSectionTypeToNSUInteger(value) (value)
#   define IBAIndexPathSectionTypeToNSInteger(value) IBANSUIntegerToNSInteger(value)
#endif

@interface NSIndexPath (UITableView_IBAExtension)

- (BOOL)ibaRowIsWithinBoundsOfArray:(NSArray *)array;

@end
