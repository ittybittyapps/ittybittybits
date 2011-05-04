//
//  IBAFileUtils.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 4/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "IBATemporaryFile.h"
#import "IBADebug.h"

@implementation IBATemporaryFile

@synthesize handle;
@synthesize filepath;

/////////////////////////////////////////////////////////////////////////////////////////////////
+ (IBATemporaryFile*) temporaryFileWithTemplate:(NSString*)filenameTemplate
{
    return [[[self alloc] initWithFilenameTemplate:filenameTemplate] autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithFilenameTemplate:(NSString*)filenameTemplate
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

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
    NSError* error = nil;
    if ([[NSFileManager defaultManager] removeItemAtPath:filepath error:&error] == NO)
    {
        NSLog(@"Failed to remove temporary file '%@': %@", filepath, [error localizedDescription]);
    }

    [filepath release];
    filepath = nil;

    [handle release];
    handle = nil;
        
    [super dealloc];
}

@end