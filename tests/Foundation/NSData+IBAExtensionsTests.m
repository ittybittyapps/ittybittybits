//
//  NSData+IBAExtensionsTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 6/10/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
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

#import "NSData+IBAExtensionsTests.h"
#import "NSData+IBAExtensions.h"

@implementation NSData_IBAExtensionsTests

static const char *kRawData = "1234567890123456789009876543210987654321qwertyuiopasdfghjklzxcvbnmnbvcxzlkjhgfdsapoiuytrewq";
static const char *kEncodedData = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAwOTg3NjU0MzIxMDk4NzY1NDMyMXF3ZXJ0eXVpb3Bhc2RmZ2hqa2x6eGN2Ym5tbmJ2Y3h6bGtqaGdmZHNhcG9pdXl0cmV3cQ==";

- (void)testNewBase64Encode
{
    size_t outputLength;
    char *output = IBANewBase64Encode(kRawData, strlen(kRawData), false, &outputLength);
    
    GHAssertEqualCStrings(kEncodedData, output, @"encoded output should be same as reference encoded data");
    GHAssertEquals(strlen(kEncodedData), outputLength, @"length of encoded output should be same as length of reference encoded data");
    IBA_FREE(output);
}

- (void)testNewBase64Decode
{
    size_t outputLength;
    void *output = IBANewBase64Decode(kEncodedData, UINT_MAX, &outputLength);
    char *string = (char *)calloc(1, outputLength + 1); // +1 for null term
    memcpy(string, output, outputLength);
    
    GHAssertEqualCStrings(kRawData, string, @"decoded output should be same as reference raw data");
    GHAssertEquals(strlen(kRawData), outputLength, @"length of decoded output should be same as length of reference raw data");
    IBA_FREE(output);
}

//
//- (void)testBase64EncodedString
//{
//    
//}

@end
