//
//  IBADelimitedTextFileReader.m
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

#import "IBADelimitedTextFileReader.h"
#import "IBADebug.h"
#import "IBAInputStreamLineReader.h"

@interface IBADelimitedTextFileReader ()
@property (nonatomic, retain) NSArray* columnNames;
@end

@implementation IBADelimitedTextFileReader

#pragma mark -
#pragma mark Class Methods

/////////////////////////////////////////////////////////////////////////////////////////////////
+ (IBADelimitedTextFileReader*) tabDelimitedTextFileReaderWithColumnHeaders:(BOOL)hasColumnHeaders
{
    return [[[IBADelimitedTextFileReader alloc] initWithFieldDelimiter:@"\t" 
                                                       recordDelimiter:@"\n" 
                                                      hasColumnHeaders:hasColumnHeaders] autorelease];
}

#pragma mark -
#pragma mark Instance Methods

@synthesize hasColumnHeaders;
@synthesize recordDelimiter;
@synthesize fieldDelimiter;
@synthesize columnNames;

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init
{
    if ((self = [super init]))
    {
        self.hasColumnHeaders = NO;
        self.fieldDelimiter = @"\t";
        self.recordDelimiter = @"\n";
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithFieldDelimiter:(NSString*)aFieldDelimiter 
              recordDelimiter:(NSString*)aRecordDelimiter
             hasColumnHeaders:(BOOL)fileHasColumnHeaders
{
    if ((self = [self init]))
    {
        self.fieldDelimiter = aFieldDelimiter;
        self.recordDelimiter = aRecordDelimiter;
        self.hasColumnHeaders = fileHasColumnHeaders;
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
    self.fieldDelimiter = nil;
    self.recordDelimiter = nil;
    [super dealloc];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) readRecordsFromStream:(NSInputStream*)stream 
                      delegate:(id<IBADelimitedTextFileReaderDelegate>)delegate
{
    IBAAssertNotNil(stream);
    IBAAssertNotNil(delegate);
    
    IBAInputStreamLineReader* lineReader = [[IBAInputStreamLineReader alloc] initWithStream:stream];
    
    NSInteger lineCount = 0;
    NSString* line = nil;
    NSUInteger columnCount = [self.columnNames count];
    
    while ([lineReader readLine:&line] > 0)
    {
        NSArray* fields = [line componentsSeparatedByString:self.fieldDelimiter];
        NSUInteger fieldCount = [fields count];
        if(lineCount == 0 && self.hasColumnHeaders)
        {
            self.columnNames = fields;
            columnCount = [self.columnNames count];
            [delegate didReadColumnHeaders:self.columnNames];
        }
        else
        {
            NSMutableDictionary* record = [[NSMutableDictionary alloc] init];
            for (NSUInteger i = 0; i < fieldCount; ++i)
            {
                id fieldValue = [fields objectAtIndex:i];
                [record setObject:fieldValue forKey:[NSNumber numberWithUnsignedInteger:i]];
                if (i < columnCount)
                {
                    [record setObject:fieldValue forKey:[self.columnNames objectAtIndex:i]];
                }
            }
            
            [delegate didReadRecord:record];
            [record release];
        }
        
        ++lineCount;
    }
    
    [lineReader release];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) readRecordsFromFile:(NSString*)path 
                    delegate:(id<IBADelimitedTextFileReaderDelegate>)delegate;
{
    IBAAssertNotNilOrEmptyString(path);

    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    NSData* fileData = [NSData dataWithContentsOfMappedFile:path];
    NSInputStream* stream = [[NSInputStream alloc] initWithData:fileData];
    [stream scheduleInRunLoop:runLoop forMode:NSDefaultRunLoopMode];
    [stream open];

    [self readRecordsFromStream:stream delegate:delegate];
    
    [stream removeFromRunLoop:runLoop forMode:NSDefaultRunLoopMode];
    [stream close];
    [stream release];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) readRecordsFromFile:(NSString*)path
                  usingBlock:(IBADelimitedTextFileReaderDidReadRecordBlock)block
{
    IBADelimitedTextFileReaderDelegateBlockAdapter* adapter = [[IBADelimitedTextFileReaderDelegateBlockAdapter alloc] initWithDidReadRecordBlock:block];
    
    [self readRecordsFromFile:path delegate:adapter];
    [adapter release];
}


@end
