//
//  NSString+IBAWhitespace.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 10/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//  Copyright 2006-2008 Google Inc.
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

/*!
 \def       IBAIsNilOrEmptyString
 \brief     Returns a value indicating whether the specified \a string is nil or empty.
 \return    YES if the \a string is nil or empty; otherwise NO.
 */
#define IBAIsNilOrEmptyString(string) ((string) == nil || [@"" isEqualToString:(string)])

@interface NSString (IBAExtensions)

- (NSString *)ibaStringByTrimmingWhitespaceAndNewline;
- (NSString *)ibaStringByCompressingWhitespaceAndNewlineTo:(NSString *)seperator;
- (BOOL)ibaNotBlank;

- (NSString *)ibaURLEncoded;

- (NSString *)ibaStringByEscapingForHTML;
- (NSString *)ibaStringByEscapingForAsciiHTML;
- (NSString *)ibaStringByUnescapingFromHTML;

@end
