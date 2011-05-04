//
//  IBAFileUtils.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 4/05/11.
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

/*!
 \brief     Encapsulates a the creation of removal of a temporary file.  The temporary file is created in the user's temporary directory.
 \sa        NSTemporaryDirectory()
 */
@interface IBATemporaryFile : NSObject 
{
}

/*!
 \brief     Create a temporary file instance given the specified filename template.
 \param     filenameTemplate    The filename template in the form of "tmp.XXXXXX", the X characters will be replaced with random characters.  No characters can come after the X characters.
 \return    The allocated instance (autoreleased).
 */
+ (IBATemporaryFile*) temporaryFileWithTemplate:(NSString*)filenameTemplate;

/*!
 \brief     Initialize the instance with the specified filename template.
 \details   Once the instance has been initialized the handle property will be non-nil and a temporary file will have been created matching the specified template.
 \param     filenameTemplate    The filename template in the form of "tmpXXXXXXsuffix", the X characters will be replaced with random characters.
 */
- (id) initWithFilenameTemplate:(NSString*)filenameTemplate;

/*!
 \brief     The open filehandle ready for reading/writing.
 \details   The file will be closed and deleted when this IBATemporaryFile instance is released.
 */
@property (nonatomic, readonly) NSFileHandle* handle;

/*!
 \brief     The fully qualified path to the temporary file.
 */
@property (nonatomic, readonly) NSString* filepath;

@end