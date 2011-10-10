//
//  NSString+IBAExtensionsTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 24/08/11.
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

#import "NSString+IBAExtensionsTests.h"
#import "NSString+IBAExtensions.h"

@implementation NSString_IBAExtensionsTests

// Run before each test method
- (void)setUp {}

// Run after each test method
- (void)tearDown {}

// Run before the tests are run for this class
- (void)setUpClass {}

// Run before the tests are run for this class
- (void)tearDownClass {}

- (void)testStringByTrimmingWhitespaceAndNewline
{
    GHAssertEqualStrings([@"\t\r\n\v test\r\t\n\v " ibaStringByTrimmingWhitespaceAndNewline], @"test", @"whitespace should be trimmed");
}

- (void)testStringByCompressingWhitespaceAndNewlineTo
{
    GHAssertEqualStrings([@"1\t\r\n\v 2\r\t\n\v 3" ibaStringByCompressingWhitespaceAndNewlineTo:@" "], @"1 2 3", @"whitespace should be compressed");
}

- (void)testNotBlank
{
    NSString *nilString = nil;
    GHAssertFalse([nilString ibaNotBlank], @"nil string should be considered blank");
    
    GHAssertFalse([@"" ibaNotBlank], @"empty string should be considered blank");

    GHAssertFalse([@" \r\n\v\t" ibaNotBlank], @"whitespace string should be considered blank");
    
    GHAssertTrue([@" \r\b\v\t  something" ibaNotBlank], @"non-whitespace should not be considered blank");
}

- (void)testURLEncoded
{
    GHAssertEqualStrings([@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`asdf" ibaURLEncoded], 
                         @"%3A%2F%3F%23%5B%5D%40%21%24%20%26%27%28%29%2A%2B%2C%3B%3D%22%3C%3E%25%7B%7D%7C%5C%5E%7E%60asdf",
                         @"URL characters should be escaped");
    
}

- (void)testStringByEscapingForHTML
{
    GHAssertEqualStrings([@"\"&'<>" ibaStringByEscapingForHTML], 
                         @"&quot;&amp;&apos;&lt;&gt;", 
                         @"should be HTML escaped");
    
    GHAssertEqualStrings([@"\u0152\u0153\u0160\u0161\u0178" ibaStringByEscapingForHTML], 
                         @"&OElig;&oelig;&Scaron;&scaron;&Yuml;", 
                         @"should be HTML escaped");
    
    GHAssertEqualStrings([@"\u02C6\u02DC" ibaStringByEscapingForHTML], 
                         @"&circ;&tilde;", 
                         @"should be HTML escaped");

    GHAssertEqualStrings([@"\u2002\u2003\u2009\u200C\u200D" ibaStringByEscapingForHTML],                          
                         @"&ensp;&emsp;&thinsp;&zwnj;&zwj;", 
                         @"should be HTML escaped");
                          
    GHAssertEqualStrings([@"\u200E\u200F\u2013\u2014" ibaStringByEscapingForHTML],
                         @"&lrm;&rlm;&ndash;&mdash;",
                         @"should be HTML escaped");
    
    GHAssertEqualStrings([@"\u2018\u2019\u201A\u201C" ibaStringByEscapingForHTML], 
                         @"&lsquo;&rsquo;&sbquo;&ldquo;",
                         @"should be HTML escaped");
    
    GHAssertEqualStrings([@"\u201D\u201E\u2020\u2021" ibaStringByEscapingForHTML], 
                         @"&rdquo;&bdquo;&dagger;&Dagger;",
                         @"should be HTML escaped");
    
    GHAssertEqualStrings([@"\u2030\u2039\u203A\u20AC" ibaStringByEscapingForHTML], 
                         @"&permil;&lsaquo;&rsaquo;&euro;",
                         @"should be HTML escaped");

}

// TODO: test ibaStringByEscapingForAsciiHTML;

- (void)testStringByUnescapingFromHTML
{
    GHAssertEqualStrings([@"test" ibaStringByUnescapingFromHTML],
                         @"test",
                         @"should be unchanged");
                          
    GHAssertEqualStrings([@"&quot;&amp;&apos;&lt;&gt;" ibaStringByUnescapingFromHTML], 
                         @"\"&'<>", 
                         @"should be unescaped");
    
    GHAssertEqualStrings([@"&OElig;&oelig;&Scaron;&scaron;&Yuml;" ibaStringByUnescapingFromHTML], 
                         @"\u0152\u0153\u0160\u0161\u0178",
                         @"should be HTML escaped");
    
    GHAssertEqualStrings([@"&circ;&tilde;" ibaStringByUnescapingFromHTML], 
                         @"\u02C6\u02DC", 
                         @"should be HTML escaped");
    
    GHAssertEqualStrings([@"&ensp;&emsp;&thinsp;&zwnj;&zwj;" ibaStringByUnescapingFromHTML], 
                         @"\u2002\u2003\u2009\u200C\u200D",
                         @"should be HTML escaped");
    
    GHAssertEqualStrings([@"&lrm;&rlm;&ndash;&mdash;" ibaStringByUnescapingFromHTML],
                         @"\u200E\u200F\u2013\u2014",
                         @"should be HTML escaped");
    
    GHAssertEqualStrings([@"&lsquo;&rsquo;&sbquo;&ldquo;" ibaStringByUnescapingFromHTML],
                         @"\u2018\u2019\u201A\u201C", 
                         @"should be HTML escaped");
    
    GHAssertEqualStrings([@"&rdquo;&bdquo;&dagger;&Dagger;" ibaStringByUnescapingFromHTML],
                         @"\u201D\u201E\u2020\u2021", 
                         @"should be HTML escaped");
    
    GHAssertEqualStrings([@"&permil;&lsaquo;&rsaquo;&euro;" ibaStringByUnescapingFromHTML],
                         @"\u2030\u2039\u203A\u20AC", 
                         @"should be HTML escaped");

    // Decimal sequences
    GHAssertEqualStrings([@"&#32;&#33;&#34;" ibaStringByUnescapingFromHTML],
                         @" !\"", 
                         @"should be HTML escaped");
    
    // Hex sequences
    GHAssertEqualStrings([@"&#x20;&#X21;&#x22;" ibaStringByUnescapingFromHTML],
                         @" !\"", 
                         @"should be HTML escaped");

    // TODO: more ascii characters
}

- (void)testObfuscateWithKey
{
    NSString *input = @"this string is what I want to obfuscate";
    NSString *key = @"this is my key";
    
    NSData *obfuscated = [input ibaObfuscateWithKey:key];
    
    GHAssertNotNil(obfuscated, @"obfuscated string should not be nil");
    
    NSString *obfuscatedAsString = [[[NSString alloc] initWithData:obfuscated encoding:NSMacOSRomanStringEncoding] autorelease];
    GHAssertFalse([input isEqualToString:obfuscatedAsString], @"input string should not equal obfuscated string");
    
    NSString *deobfuscated = [NSString ibaStringByDeobfuscateingData:obfuscated withKey:key];
    GHAssertEqualStrings(input, deobfuscated, @"input and deobfuscated strings should be equal");
}

@end
