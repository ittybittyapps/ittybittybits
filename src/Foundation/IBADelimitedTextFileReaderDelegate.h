//  IBADelimitedTestFileReaderDelegate.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 9/05/11.
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

#import <Foundation/Foundation.h>

@protocol IBADelimitedTextFileReaderDelegate

/*!
 \brief     Notifies the delegate that a record has been read.
 \param     record
 A dictionary of the record's fields.  The keys of this dictionary are the column numbers of the fields.  If the reader supports column headers the dictionary will also contain keys of mapping the column header names to values.
 */
- (void) didReadRecord:(NSDictionary*)record;
@optional

/*!
 \brief     Notifies the delegate that the column header record has been read.
 \param     columnHeaders
 An array of record column header/field names.
 */
- (void) didReadColumnHeaders:(NSArray*)columnHeaders;

@end//
