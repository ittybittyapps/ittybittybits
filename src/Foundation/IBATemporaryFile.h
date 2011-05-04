//
//  IBAFileUtils.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 4/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

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