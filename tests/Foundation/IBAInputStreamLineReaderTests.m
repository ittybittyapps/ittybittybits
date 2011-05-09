//
//  IBAInputStreamLineReaderTests.m
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


#import "IBAInputStreamLineReaderTests.h"
#import "IBAInputStreamLineReader.h"

@implementation IBAInputStreamLineReaderTests



+ (NSInputStream*) newInputStreamReaderWithCharacters:(const char*)data lineEnding:(NSString*)lineEnding encoding:(NSStringEncoding)encoding
{
    NSData* testData = [NSData dataWithBytes:data length:(sizeof(char) * strlen(data))];
    NSInputStream* inputStream = [[NSInputStream alloc] initWithData:testData];
    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    
    return [[IBAInputStreamLineReader alloc] initWithStream:inputStream 
                                            linesEndingWith:lineEnding
                                                   encoding:encoding];

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

- (void)testStreamReaderMultipleLines 
{
    IBAInputStreamLineReader* reader = [[[self class] newInputStreamReaderWithCharacters:"line1\nline2\n\nline4" 
                                                                              lineEnding:@"\n" 
                                                                                encoding:NSUTF8StringEncoding] autorelease];
    
    NSString* line = nil;
    
    GHAssertGreaterThan([reader readLine:&line], 0, @"");
    GHAssertEqualStrings(line, @"line1", @"");

    GHAssertGreaterThan([reader readLine:&line], 0, @"");
    GHAssertEqualStrings(line, @"line2", @"");

    GHAssertGreaterThan([reader readLine:&line], 0, @"");
    GHAssertEqualStrings(line, @"", @"");

    GHAssertGreaterThan([reader readLine:&line], 0, @"");
    GHAssertEqualStrings(line, @"line4", @"");

    GHAssertEquals([reader readLine:&line], 0, @"");    
    GHAssertNil(line, @"");    
    
}

- (void)testStreamReaderWindowsLineEndings
{
    IBAInputStreamLineReader* reader = [[[self class] newInputStreamReaderWithCharacters:"line1\r\nline2\r\n\r\nline4\r\n"
                                                                              lineEnding:@"\r\n" 
                                                                                encoding:NSUTF8StringEncoding] autorelease];
    
    NSString* line = nil;
    
    GHAssertGreaterThan([reader readLine:&line], 0, @"");
    GHAssertEqualStrings(line, @"line1", @"");
    
    GHAssertGreaterThan([reader readLine:&line], 0, @"");
    GHAssertEqualStrings(line, @"line2", @"");
    
    GHAssertGreaterThan([reader readLine:&line], 0, @"");
    GHAssertEqualStrings(line, @"", @"");
    
    GHAssertGreaterThan([reader readLine:&line], 0, @"");
    GHAssertEqualStrings(line, @"line4", @"");
    
    GHAssertEquals([reader readLine:&line], 0, @"");    
    GHAssertNil(line, @"");    
    
}

- (void)testStreamReaderSingleLineNoLineEnding
{
    IBAInputStreamLineReader* reader = [[[self class] newInputStreamReaderWithCharacters:"line1"
                                                                              lineEnding:@"\n" 
                                                                                encoding:NSUTF8StringEncoding] autorelease];
    
    NSString* line = nil;
    
    GHAssertGreaterThan([reader readLine:&line], 0, @"readLine should return 1 as there was data in the stream");
    GHAssertEqualStrings(line, @"line1", @"should return a line");
    
    GHAssertEquals([reader readLine:&line], 0, @"readLine should return 0 as there is no more data in stream");    
    GHAssertNil(line, @"returned line should be nil");   
   
    
}

- (void)testStreamReaderSingleLineWithLineEnding
{
    IBAInputStreamLineReader* reader = [[[self class] newInputStreamReaderWithCharacters:"line1\n"
                                                                              lineEnding:@"\n" 
                                                                                encoding:NSUTF8StringEncoding] autorelease];
    
    NSString* line = nil;
    
    GHAssertGreaterThan([reader readLine:&line], 0, @"readLine should return 1 as there was data in the stream");
    GHAssertEqualStrings(line, @"line1", @"should return a line");
    
    GHAssertEquals([reader readLine:&line], 0, @"readLine should return 0 as there is no more data in stream");    
    GHAssertNil(line, @"returned line should be nil");   
}

- (void)testStreamReaderEmptyLineNoLineEnding
{
    IBAInputStreamLineReader* reader = [[[self class] newInputStreamReaderWithCharacters:""
                                                                              lineEnding:@"\n" 
                                                                                encoding:NSUTF8StringEncoding] autorelease];
    
    NSString* line = nil;
    
    GHAssertEquals([reader readLine:&line], 0, @"readLine should return 0 as there is no data in stream");    
    GHAssertNil(line, @"returned line should be nil");
}

- (void)testStreamReaderEmptyLineWithLineEnding
{
    IBAInputStreamLineReader* reader = [[[self class] newInputStreamReaderWithCharacters:"\n"
                                                                              lineEnding:@"\n" 
                                                                                encoding:NSUTF8StringEncoding] autorelease];
    
    NSString* line = nil;
    
    GHAssertGreaterThan([reader readLine:&line], 0, @"readLine should return 1 as there was data in the stream");
    GHAssertEqualStrings(line, @"", @"returned line should be empty");
    
    GHAssertEquals([reader readLine:&line], 0, @"readLine should return 0 as there is no more data in stream");    
    GHAssertNil(line, @"returned line should be nil");
}

- (void)testStreamReaderWithALotOfLines
{
    NSMutableString* bigString = [NSMutableString stringWithCapacity:5*10*1000];
    for (int i = 0; i < 1000; ++i)
    {
        [bigString appendString:@"line\nline\nline\nline\nline\nline\nline\nline\nline\nline\n"];
    }
    
    IBAInputStreamLineReader* reader = [[[self class] newInputStreamReaderWithCharacters:[bigString UTF8String]
                                                                              lineEnding:@"\n" 
                                                                                encoding:NSUTF8StringEncoding] autorelease];
    
    NSString* line = nil;
    
    for (int i = 0; i < 10000; ++i)
    {
        GHAssertGreaterThan([reader readLine:&line], 0, @"readLine should return 1 as there was data in the stream");
        GHAssertEqualStrings(line, @"line", @"should return a line");
    }
    
    GHAssertEquals([reader readLine:&line], 0, @"readLine should return 0 as there is no more data in stream");    
    GHAssertNil(line, @"returned line should be nil");
}

@end
