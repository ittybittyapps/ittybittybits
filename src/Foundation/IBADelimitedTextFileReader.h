//
//  IBADelimitedTextFileReader.h
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

#import "IBADelimitedTextFileReaderDelegate.h"


/*!
 \brief     A simple reader for delimited text files.  
 This class implements a very simple delimited text file reader suitable for reading formats such as tab delimited text files.
 */
@interface IBADelimitedTextFileReader : NSObject {
    
}

/*!
 \brief     Factory method that creates a tab delimited text file reader.
 \details   The fieldDelimiter is set to the tab character (\\t) and the recordDelimiter set to the new-line character (\\n).
 \param     hasColumnHeaders
            A value indicating whether the file has a column header row as the first row of the file.
 */
+ (IBADelimitedTextFileReader*) tabDelimitedTextFileReaderWithColumnHeaders:(BOOL)hasColumnHeaders;

/*!
 \brief     Gets or sets a value indicating whether the first record of the delimited text file is the column headers.  Defaults to NO.
 */
@property (nonatomic, assign) BOOL hasColumnHeaders;

/*!
 \brief     Gets or sets the value to use as the record delimited.  Defaults to the new-line character.
 */
@property (nonatomic, retain) NSString* recordDelimiter;

/*!
 \brief     Gets or sets the value to use as the field delimiter.  Defaults to the tab character.
 */
@property (nonatomic, retain) NSString* fieldDelimiter;

/*!
 \brief     The default initializer.
 \details   Initializes a text file reader with new-line as the record delimiter and tab as the field delimiter.
 */
- (id) init;

/*!
 \brief     Initializes a text file reader instance with the specified \a fieldDelimiter and \a recordDelimiter.
 \param     fieldDelimiter
            The string to use as the field delimiter.
 \param     recordDelimiter
            The string to use as the record delimiter.
 \param     hasColumnHeaders
            A value indicating whether the first record of the file is used as the column headers.
 */
- (id) initWithFieldDelimiter:(NSString*)fieldDelimiter 
              recordDelimiter:(NSString*)recordDelimiter 
             hasColumnHeaders:(BOOL)hasColumnHeaders;

- (void) readRecordsFromStream:(NSInputStream*)stream 
                      delegate:(id<IBADelimitedTextFileReaderDelegate>)delegate;

- (void) readRecordsFromStream:(NSInputStream*)stream
                    usingBlock:(IBADelimitedTextFileReaderDidReadRecordBlock)block;

- (void) readRecordsFromFile:(NSString*)path 
                    delegate:(id<IBADelimitedTextFileReaderDelegate>)delegate;

- (void) readRecordsFromFile:(NSString*)path
                  usingBlock:(IBADelimitedTextFileReaderDidReadRecordBlock)block;

@end
