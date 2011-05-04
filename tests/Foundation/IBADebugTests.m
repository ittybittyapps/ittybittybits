//
//  IBADebugTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 4/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "IBADebugTests.h"
#import "IBADebug.h"

@implementation IBADebugTests

// Run before each test method
- (void)setUp {}

// Run after each test method
- (void)tearDown {}

// Run before the tests are run for this class
- (void)setUpClass {}

// Run before the tests are run for this class
- (void)tearDownClass {}

- (void)testDLog
{
    DLog(@"Something");
    
#ifndef NDEBUG
    GHAssertThrows(ALog(@"Something else"), @"");
#endif
    
}
@end
