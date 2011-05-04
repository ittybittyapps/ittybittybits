//
//  IBALogger.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 4/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "IBALoggerTests.h"
#import "IBALogger.h"
#import "IBATemporaryFile.h"

@implementation IBALoggerTests

// Run before each test method
- (void)setUp {}

// Run after each test method
- (void)tearDown {}

// Run before the tests are run for this class
- (void)setUpClass {
    tempLogFile = [[IBATemporaryFile temporaryFileWithTemplate:@"test.XXXXXXXX"] retain];
    [[IBALogger sharedLogger] addLogFile:tempLogFile.filepath];
}

// Run before the tests are run for this class
- (void)tearDownClass {
    [[IBALogger sharedLogger] removeLogFile:tempLogFile.filepath];

    [tempLogFile release];
    tempLogFile = nil;
}

- (void)testLogger 
{
    IBALogDebug(@"A debug log message => %d: %@", 1, @"one");
    IBALogInfo(@"A info log message => %d: %@", 2, @"two");
    IBALogNotice(@"A info log message => %d: %@", 3, @"three");
    IBALogWarning(@"A info log message => %d: %@", 4, @"four");
    IBALogError(@"A info log message => %d: %@", 5, @"five");
    IBALogCritical(@"A info log message => %d: %@", 6, @"six");
    IBALogAlert(@"A info log message => %d: %@", 7, @"seven");
    //IBALogEmergency(@"A info log message => %d: %@", 8, @"eight");
}

@end
