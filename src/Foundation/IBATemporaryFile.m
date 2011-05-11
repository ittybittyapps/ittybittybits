//
//  IBAFileUtils.m
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

#import "IBATemporaryFile.h"
#import "IBADebug.h"
#import "IBACommon.h"

@implementation IBATemporaryFile

@synthesize handle;
@synthesize filepath;

/*!
 \brief     Create a temporary file instance given the specified filename template.
 \param     filenameTemplate    
            The filename template in the form of "tmp.XXXXXX", the X characters will be replaced with random characters.  Note that no characters can come after the X characters in the template.
 \return    The allocated instance (autoreleased).
 */
+ (IBATemporaryFile *)temporaryFileWithTemplate:(NSString *)filenameTemplate
{
    return [[[self alloc] initWithFilenameTemplate:filenameTemplate] autorelease];
}


/*!
 \brief     Initialize the instance with the specified filename template.
 \details   Once the instance has been initialized the handle property will be non-nil and a temporary file will have been created matching the specified template.
 \param     filenameTemplate    The filename template in the form of "tmp.XXXXXX", the X characters will be replaced with random characters. Note that no characters can come after the X characters in the template.
 */
- (id)initWithFilenameTemplate:(NSString *)filenameTemplate
{
    IBAAssertNotNilOrEmptyString(filenameTemplate);
    
    if ((self = [super init]))
    {
        NSString *tempFileTemplate = [NSTemporaryDirectory() stringByAppendingPathComponent:filenameTemplate];
        const char *tempFileTemplateCString = [tempFileTemplate fileSystemRepresentation];
                                         
        // create a buffer with space for the temp filename (and the null terminator)
        size_t bufferSize = strlen(tempFileTemplateCString) + 1;
        char* tempFileNameCString = (char*)malloc(bufferSize);
        strlcpy(tempFileNameCString, tempFileTemplateCString, bufferSize);
        
        int fileDescriptor = mkstemp(tempFileNameCString);
        NSAssert1(fileDescriptor != -1, @"Failed to create temporary file: %s", tempFileNameCString);
        
        filepath = [[NSString stringWithCString:tempFileNameCString encoding:NSUTF8StringEncoding] retain];
        free(tempFileNameCString);

        handle = [[NSFileHandle alloc] initWithFileDescriptor:fileDescriptor];
    }
    
    return self;
}

/*!
 \brief     Deallocate the instance.
 */
- (void)dealloc
{
    NSError* error = nil;
    if ([[NSFileManager defaultManager] removeItemAtPath:filepath error:&error] == NO)
    {
        NSLog(@"Failed to remove temporary file '%@': %@", filepath, [error localizedDescription]);
    }

    IBA_RELEASE(filepath);
    IBA_RELEASE(handle);
        
    [super dealloc];
}

@end