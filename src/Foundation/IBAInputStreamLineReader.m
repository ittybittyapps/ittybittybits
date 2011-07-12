//
//  IBALineInputStream.m
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

#import "IBAInputStreamLineReader.h"
#import "IBADebug.h"

// default page size is 4k, so use that for our buffers.
const size_t kBufferSize = 4096;

@interface IBAInputStreamLineReader ()

@property (nonatomic, assign) BOOL eofReached;
@property (nonatomic, assign) BOOL errorOccured;
@property (nonatomic, retain) NSInputStream* inputStream;
@property (nonatomic, retain) NSMutableData* lineBuffer;
@property (nonatomic, retain) NSString* linesEndWith;
@property (nonatomic, assign) NSStringEncoding stringEncoding;

- (NSInteger) getReturnCode;
- (BOOL) lineBufferIsEmptyAndEndOfFile;
- (void) readIntoLineBuffer;
- (NSString*) fetchLineFromLineBuffer:(BOOL)requireLineEnding;

@end

@implementation IBAInputStreamLineReader

@synthesize eofReached;
@synthesize errorOccured;
@synthesize inputStream;
@synthesize lineBuffer;
@synthesize linesEndWith;
@synthesize stringEncoding;

#pragma mark -
#pragma mark Class Methods

/////////////////////////////////////////////////////////////////////////////////////////////////
+ (id) readerWithInputStream:(NSInputStream*)inputStream 
        linesEndingWith:(NSString*)lineEnding 
               encoding:(NSStringEncoding)encoding
{
    return [[[self alloc] initWithStream:inputStream linesEndingWith:lineEnding encoding:encoding] autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
+ (id) readerWithInputStream:(NSInputStream*)inputStream
{
    return [[[self alloc] initWithStream:inputStream] autorelease];
}


#pragma mark - 
#pragma mark Instance Methods

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithStream:(NSInputStream*)anInputStream 
{
    return [self initWithStream:anInputStream linesEndingWith:@"\n" encoding:NSUTF8StringEncoding];
}


/////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithStream:(NSInputStream*)anInputStream 
      linesEndingWith:(NSString*)lineEnding 
             encoding:(NSStringEncoding)encoding;

{
    if ((self = [super init]))
    {
        self.eofReached = NO;
        self.errorOccured = NO;
        self.stringEncoding = encoding;
        self.inputStream = anInputStream;
        self.linesEndWith = lineEnding;
        self.lineBuffer = [[[NSMutableData alloc] initWithCapacity:kBufferSize * 2] autorelease];
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
    self.inputStream = nil;
    self.linesEndWith = nil;
    self.lineBuffer = nil;
    
    [super dealloc];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) readLine:(NSString**)line
{
    IBAAssertNotNil(line);
    
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    
    NSString* readLine = nil;
    
    if ([self lineBufferIsEmptyAndEndOfFile] == NO)
    {
        do {
            readLine = [self fetchLineFromLineBuffer:YES];
            if (readLine == nil)
            {
                [self readIntoLineBuffer];
                
                if (self.eofReached || self.errorOccured)
                {
                    // we're at the end of the file, use the remaining line buffer as the line (no line ending required).
                    readLine = [self fetchLineFromLineBuffer:NO];
                    break;
                }
            }
        } while (readLine == nil);
    }
    
    // copy the read line so that it is not released with the pool drain.
    *line = [readLine copy];
    
    [pool drain];
    
    // mark the returned line for autorelease.
    [*line autorelease];
    
    return *line ? 1 : [self getReturnCode];
}

#pragma mark -
#pragma mark Private Methods

/////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*) fetchLineFromLineBuffer:(BOOL)requireLineEnding
{
    NSString* fetchedLine = nil;
    
    if ([self.lineBuffer length] > 0)
    {
        NSString* bufferAsString = [[NSString alloc] initWithData:self.lineBuffer encoding:NSUTF8StringEncoding];
        NSRange lineEnding = [bufferAsString rangeOfString:self.linesEndWith];
        if (lineEnding.location != NSNotFound || (lineEnding.location == NSNotFound && requireLineEnding == NO))
        {
            fetchedLine = [bufferAsString substringWithRange:NSMakeRange(0, MIN(lineEnding.location, [bufferAsString length]))];
        }
        
        IBA_RELEASE(bufferAsString);
    }
    
    if (fetchedLine)
    {
        // remove the fetched line from the beginning of the line buffer
        NSUInteger fetchedLineBytes = [fetchedLine lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + [self.linesEndWith lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        CFRange lineRange = CFRangeMake(0, MIN([self.lineBuffer length], fetchedLineBytes));
        CFDataDeleteBytes((CFMutableDataRef)self.lineBuffer, lineRange);
    }
    
    return fetchedLine;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) readIntoLineBuffer
{
    if (self.eofReached || self.errorOccured)
    {
        return;
    }
        
    // The lineBuffer does not contain a substring terminated with lineEnding, so append more to the buffer.
    uint8_t buffer[kBufferSize];
   
    // read bufferSize - 1 to leave space for the null terminator.
    NSInteger bytesRead = [self.inputStream read:buffer maxLength:kBufferSize-1];
    if (bytesRead > 0){
        // null terminate the buffer
        buffer[bytesRead] = 0;

        // append the read data to the current character buffer
        [self.lineBuffer appendBytes:buffer length:bytesRead];
    }
    else
    {                    
        if (bytesRead == 0)
        {
            self.eofReached = YES;
        }
        else
        {
            self.errorOccured = YES;
        }
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) lineBufferIsEmptyAndEndOfFile
{
    return (self.eofReached || self.errorOccured) && [self.lineBuffer length] == 0;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) getReturnCode
{
    if (self.eofReached)
    {
        return 0;
    }
    
    if (self.errorOccured)
    {
        return -1;
    }
    
    return 1;
}

@end
