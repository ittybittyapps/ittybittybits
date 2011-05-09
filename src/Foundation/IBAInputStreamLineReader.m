//
//  IBALineInputStream.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 9/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "IBAInputStreamLineReader.h"
#import "IBADebug.h"

// default page size is 4k, so use that for our buffers.
const size_t kBufferSize = 4096;

@interface IBAInputStreamLineReader ()

@property (nonatomic, assign) BOOL eofReached;
@property (nonatomic, assign) BOOL errorOccured;
@property (nonatomic, retain) NSInputStream* inputStream;
@property (nonatomic, retain) NSMutableString* characterBuffer;
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
@synthesize characterBuffer;
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
        self.characterBuffer = [[NSMutableString alloc] initWithCapacity:kBufferSize * 2];
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
    self.inputStream = nil;
    self.linesEndWith = nil;
    self.characterBuffer = nil;
    
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
    
    if ([self.characterBuffer length] > 0)
    {
        NSRange lineEnding = [self.characterBuffer rangeOfString:self.linesEndWith];
        if (lineEnding.location != NSNotFound || (lineEnding.location == NSNotFound && requireLineEnding == NO))
        {
            fetchedLine = [self.characterBuffer substringWithRange:NSMakeRange(0, MIN(lineEnding.location, [self.characterBuffer length]))];
        }
    }
    
    if (fetchedLine)
    {
        // remove the fetched line from the beginning of the buffer
        NSRange lineRange = NSMakeRange(0, MIN([self.characterBuffer length], [fetchedLine length] + [self.linesEndWith length]));
        [self.characterBuffer deleteCharactersInRange:lineRange];
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
        
        // convert the buffer to an NSString
        NSString* bufferAsString = [NSString stringWithCString:(const char*)buffer encoding:self.stringEncoding];
        
        // append the read string to the current line buffer
        [self.characterBuffer appendString:bufferAsString];
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
    return (self.eofReached || self.errorOccured) && [self.characterBuffer length] == 0;
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
