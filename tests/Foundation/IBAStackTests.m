//
//  IBAStackTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 25/08/11.
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

#import "IBAStackTests.h"
#import "IBAStack.h"

@implementation IBAStackTests

// Run before each test method
- (void)setUp {}

// Run after each test method
- (void)tearDown {}

// Run before the tests are run for this class
- (void)setUpClass {}

// Run before the tests are run for this class
- (void)tearDownClass {}

- (void)testInit
{
    GHAssertNotNil([[[IBAStack alloc] init] autorelease], @"stack should not be nil");
}

- (void)testStack
{
    GHAssertNotNil([IBAStack stack], @"stack should not be nil");
}

- (void)testStackWithCapacity
{
    GHAssertNotNil([IBAStack stackWithCapacity:10], @"stack should not be nil");
}

- (void)testInitWithCapacity
{
    GHAssertNotNil([[[IBAStack alloc] initWithCapacity:10] autorelease], @"stack should not be nil");
}

- (void)testPushPop
{
    IBAStack *stack = [[[IBAStack alloc] init] autorelease];
    
    [stack pushObject:@"A"];
    [stack pushObject:@"B"];
    
    GHAssertEqualStrings([stack popObject], @"B", @"stack should not be LIFO");
    GHAssertEqualStrings([stack popObject], @"A", @"stack should not be LIFO");
}

- (void)testIsEmpty
{
    IBAStack *stack = [[[IBAStack alloc] init] autorelease];
    
    GHAssertTrue([stack isEmpty], @"stack should be empty");
        
    [stack pushObject:@"A"];
    
    GHAssertFalse([stack isEmpty], @"stack should not be empty");    
}

- (void)testCount
{
    IBAStack *stack = [[[IBAStack alloc] init] autorelease];
    
    GHAssertEquals([stack count], 0u, @"stack should be empty");
    
    [stack pushObject:@"A"];
    
    GHAssertEquals([stack count], 1u, @"stack should have one element");

    [stack pushObject:@"B"];
    GHAssertEquals([stack count], 2u, @"stack should have two elements");
    
    [stack popObject];

    GHAssertEquals([stack count], 1u, @"stack should have one element");
    
    [stack popObject];
    
    GHAssertEquals([stack count], 0u, @"stack should be empty");
}

- (void)testPopAllObjects
{
    IBAStack *stack = [[[IBAStack alloc] init] autorelease];
    
    [stack pushObject:@"A"];
    [stack pushObject:@"B"];
    GHAssertEquals([stack count], 2u, @"stack should have two elements");
    
    NSArray *objects = [stack popAllObjects];
    
    GHAssertEquals([stack count], 0u, @"stack should be empty");
    
    GHAssertEquals([objects count], 2u, @"array should contain two objects");
    
    GHAssertEqualStrings([objects objectAtIndex:0], @"B", @"First array member should be B");
    GHAssertEqualStrings([objects objectAtIndex:1], @"A", @"Second array member should be A");
}

- (void)testPeekObject
{
    IBAStack *stack = [[[IBAStack alloc] init] autorelease];
    
    [stack pushObject:@"A"];
    [stack pushObject:@"B"];
    GHAssertEquals([stack count], 2u, @"stack should have two elements");
        
    GHAssertEqualStrings([stack peekObject], @"B", @"stack top object should be B");    
}

- (void)testForeachLoop
{
    IBAStack *stack = [[[IBAStack alloc] init] autorelease];
    
    [stack pushObject:@"A"];
    [stack pushObject:@"B"];
    GHAssertEquals([stack count], 2u, @"stack should have two elements");
    
    NSMutableArray *a = [NSMutableArray array];
    for (NSString *s in stack) 
    {
        [a addObject:s];
    }
    
    GHAssertEqualStrings([a objectAtIndex:0], @"B", @"Iteration should decend stack");
    GHAssertEqualStrings([a objectAtIndex:1], @"A", @"Iteration should decend stack");
}

@end
