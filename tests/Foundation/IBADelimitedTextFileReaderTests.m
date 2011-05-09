//
//  IBADelimitedTextFileReaderTests.m
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

#import "IBADelimitedTextFileReaderTests.h"
#import "IBADelimitedTextFileReader.h"

@interface IBADelimitedTextFileReaderTestsDelegateHelper : NSObject<IBADelimitedTextFileReaderDelegate>
{
}

@property (nonatomic, retain) NSArray* columnHeaders;
@property (nonatomic, retain) NSMutableArray* records;

@end

@implementation IBADelimitedTextFileReaderTestsDelegateHelper

@synthesize columnHeaders;
@synthesize records;

- (id) init
{
    if ((self = [super init]))
    {
        self.records = [NSMutableArray array];
    }
    return self;
}

- (void) dealloc
{
    self.columnHeaders = nil;
    self.records = nil;
    
    [super dealloc];
}

- (void) didReadRecord:(NSDictionary*)record
{
    [self.records addObject:record];
}

- (void) didReadColumnHeaders:(NSArray*)theColumnHeaders;
{
    self.columnHeaders = theColumnHeaders;
}

@end

@implementation IBADelimitedTextFileReaderTests

+ (NSInputStream*) inputStreamWithCharacters:(const char*)data 
{
    NSData* testData = [[NSData alloc] initWithBytes:data length:(sizeof(char) * strlen(data))];
    
    NSInputStream* inputStream = [[[NSInputStream alloc] initWithData:testData] autorelease];
    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [testData release];
    
    return inputStream;
}

+ (void)closeInputStream:(NSInputStream*)stream
{
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream close];
}

// Run before each test method
- (void)setUp {}

// Run after each test method
- (void)tearDown {}

// Run before the tests are run for this class
- (void)setUpClass {}

// Run before the tests are run for this class
- (void)tearDownClass {}

- (void)testReadOfTabDelimitedDataWithColumnHeaders
{
    const char* testData = "A\tB\tC\n1\t2\t3\n4\t5\t6\n";
    
    IBADelimitedTextFileReader* reader = [[[IBADelimitedTextFileReader alloc] initWithFieldDelimiter:@"\t" 
                                                                                    recordDelimiter:@"\n" 
                                                                                   hasColumnHeaders:YES] autorelease];
    
    NSInputStream* stream = [[self class] inputStreamWithCharacters:testData];
    IBADelimitedTextFileReaderTestsDelegateHelper* helper = [[IBADelimitedTextFileReaderTestsDelegateHelper new] autorelease];
    [reader readRecordsFromStream:stream delegate:helper];
    
    
    GHAssertNotNil(helper.columnHeaders, @"");    
    GHAssertEquals([helper.columnHeaders count], 3u, @"");
    GHAssertEqualStrings([helper.columnHeaders objectAtIndex:0], @"A", @"");
    GHAssertEqualStrings([helper.columnHeaders objectAtIndex:1], @"B", @"");
    GHAssertEqualStrings([helper.columnHeaders objectAtIndex:2], @"C", @"");
    
    GHAssertNotNil(helper.records, @"");    
    GHAssertEquals([helper.records count], 2u, @"");
    
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:0]], @"1", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:1]], @"2", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:2]], @"3", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:@"A"], @"1", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:@"B"], @"2", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:@"C"], @"3", @"");

    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:[NSNumber numberWithInt:0]], @"4", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:[NSNumber numberWithInt:1]], @"5", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:[NSNumber numberWithInt:2]], @"6", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:@"A"], @"4", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:@"B"], @"5", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:@"C"], @"6", @"");

    [[self class] closeInputStream:stream];
}

- (void)testReadOfTabDelimitedDataWithColumnHeadersNoEndOfFileNewLine
{
    const char* testData = "A\tB\tC\n1\t2\t3\n4\t5\t6";
    
    IBADelimitedTextFileReader* reader = [[[IBADelimitedTextFileReader alloc] initWithFieldDelimiter:@"\t" 
                                                                                     recordDelimiter:@"\n" 
                                                                                    hasColumnHeaders:YES] autorelease];
    
    NSInputStream* stream = [[self class] inputStreamWithCharacters:testData];
    IBADelimitedTextFileReaderTestsDelegateHelper* helper = [[IBADelimitedTextFileReaderTestsDelegateHelper new] autorelease];
    [reader readRecordsFromStream:stream delegate:helper];
    
    
    GHAssertNotNil(helper.columnHeaders, @"");    
    GHAssertEquals([helper.columnHeaders count], 3u, @"");
    GHAssertEqualStrings([helper.columnHeaders objectAtIndex:0], @"A", @"");
    GHAssertEqualStrings([helper.columnHeaders objectAtIndex:1], @"B", @"");
    GHAssertEqualStrings([helper.columnHeaders objectAtIndex:2], @"C", @"");
    
    GHAssertNotNil(helper.records, @"");    
    GHAssertEquals([helper.records count], 2u, @"");
    
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:0]], @"1", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:1]], @"2", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:2]], @"3", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:@"A"], @"1", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:@"B"], @"2", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:@"C"], @"3", @"");
    
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:[NSNumber numberWithInt:0]], @"4", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:[NSNumber numberWithInt:1]], @"5", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:[NSNumber numberWithInt:2]], @"6", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:@"A"], @"4", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:@"B"], @"5", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:@"C"], @"6", @"");
    
    [[self class] closeInputStream:stream];
}

- (void)testReadOfTabDelimitedDataWithoutColumnHeaders
{
    const char* testData = "1\t2\t3\n4\t5\t6\n";
    
    IBADelimitedTextFileReader* reader = [[[IBADelimitedTextFileReader alloc] initWithFieldDelimiter:@"\t" 
                                                                                     recordDelimiter:@"\n" 
                                                                                    hasColumnHeaders:NO] autorelease];
    
    NSInputStream* stream = [[self class] inputStreamWithCharacters:testData];
    IBADelimitedTextFileReaderTestsDelegateHelper* helper = [[IBADelimitedTextFileReaderTestsDelegateHelper new] autorelease];
    [reader readRecordsFromStream:stream delegate:helper];
    
    GHAssertNil(helper.columnHeaders, @"");    
    
    GHAssertNotNil(helper.records, @"");    
    GHAssertEquals([helper.records count], 2u, @"");
    
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:0]], @"1", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:1]], @"2", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:2]], @"3", @"");
    
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:[NSNumber numberWithInt:0]], @"4", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:[NSNumber numberWithInt:1]], @"5", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:[NSNumber numberWithInt:2]], @"6", @"");
    
    [[self class] closeInputStream:stream];
}

- (void)testReadOfTabDelimitedDataWithoutColumnHeadersJaggedRows
{
    const char* testData = "1\t2\t3\t4\n5\t6\n";
    
    IBADelimitedTextFileReader* reader = [[[IBADelimitedTextFileReader alloc] initWithFieldDelimiter:@"\t" 
                                                                                     recordDelimiter:@"\n" 
                                                                                    hasColumnHeaders:NO] autorelease];
    
    NSInputStream* stream = [[self class] inputStreamWithCharacters:testData];
    IBADelimitedTextFileReaderTestsDelegateHelper* helper = [[IBADelimitedTextFileReaderTestsDelegateHelper new] autorelease];
    [reader readRecordsFromStream:stream delegate:helper];
    
    GHAssertNil(helper.columnHeaders, @"");    
    
    GHAssertNotNil(helper.records, @"");    
    GHAssertEquals([helper.records count], 2u, @"");
    
    GHAssertEquals([[helper.records objectAtIndex:0] count], 4u, @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:0]], @"1", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:1]], @"2", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:2]], @"3", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:0] objectForKey:[NSNumber numberWithInt:3]], @"4", @"");
    
    GHAssertEquals([[helper.records objectAtIndex:1] count], 2u, @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:[NSNumber numberWithInt:0]], @"5", @"");
    GHAssertEqualStrings([[helper.records objectAtIndex:1] objectForKey:[NSNumber numberWithInt:1]], @"6", @"");
    
    [[self class] closeInputStream:stream];
}

@end
