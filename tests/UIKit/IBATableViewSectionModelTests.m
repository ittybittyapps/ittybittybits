//
//  IBATableViewSectionModelTests.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 19/09/11.
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

#import "IBATableViewSectionModelTests.h"
#import "IBAFoundation.h"
#import "IBATableViewSectionModel.h"

@implementation IBATableViewSectionModelTests

// Run before each test method
- (void)setUp {}

// Run after each test method
- (void)tearDown {}

// Run before the tests are run for this class
- (void)setUpClass {}

// Run before the tests are run for this class
- (void)tearDownClass {}

- (void)testShouldCreateTableViewSectionModel
{
    IBATableViewSectionModel *m = [IBATableViewSectionModel tableViewSectionModel];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertNil(m.title, @"section title should be nil");
    GHAssertEquals(m.rowCount, (IBAIndexPathRowType)0, @"model rowCount should be zero");
}

- (void)testShouldCreateTableViewSectionModelWithNoRows
{
    IBATableViewSectionModel *m = [IBATableViewSectionModel tableViewSectionModelWithRows:[NSArray array]];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertNil(m.title, @"section title should be nil");
    GHAssertEquals(m.rowCount, (IBAIndexPathRowType)0, @"model rowCount should be zero");
}

- (void)testShouldCreateTableViewSectionModelWithTitle
{
    NSString *title = @"Title";
    IBATableViewSectionModel *m = [IBATableViewSectionModel tableViewSectionModelWithTitle:title];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertEqualStrings(m.title, title, @"title should be set");
    GHAssertEquals(m.rowCount, (IBAIndexPathRowType)0, @"model rowCount should be 0");
}

- (void)testShouldCreateTableViewSectionModelWithSomeRowsAndTitle
{
    NSArray *rows = IBA_NSARRAY(@"A", @"B");
    NSString *title = @"Title";
    
    IBATableViewSectionModel *m = [IBATableViewSectionModel tableViewSectionModelWithRows:rows title:title];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertEqualStrings(m.title, title, @"title should be set");
    GHAssertEquals(m.rowCount, IBANSUIntegerToIBAIndexPathRowType([rows count]), @"model rowCount should be %d", [rows count]);
}

- (void)testShouldInitTableViewSectionModelWithTitle
{
    NSString *title = @"Title";
    IBATableViewSectionModel *m = [[[IBATableViewSectionModel alloc] initWithTitle:title] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertEqualStrings(m.title, title, @"title should be set");
    GHAssertEquals(m.rowCount, (IBAIndexPathRowType)0, @"model rowCount should be 0");
}

- (void)testShouldInitTableViewSectionModelWithSomeRowsAndTitle
{
    NSArray *rows = IBA_NSARRAY(@"A", @"B");
    NSString *title = @"Title";
    
    IBATableViewSectionModel *m = [[[IBATableViewSectionModel alloc] initWithRows:rows title:title] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertEqualStrings(m.title, title, @"title should be set");
    GHAssertEquals(m.rowCount, IBANSUIntegerToIBAIndexPathRowType([rows count]), @"model rowCount should be %d", [rows count]);
}

- (void)testShouldInitTableViewSectionModelWithSomeRowsAndNoTitle
{
    NSArray *rows = IBA_NSARRAY(@"A", @"B");
    NSString *title = nil;
    
    IBATableViewSectionModel *m = [[[IBATableViewSectionModel alloc] initWithRows:rows title:title] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertNil(m.title, @"title should be nil");
    GHAssertEquals(m.rowCount, IBANSUIntegerToIBAIndexPathRowType([rows count]), @"model rowCount should be %d", [rows count]);
}

- (void)testShouldInitTableViewSectionModelWithNoRowsAndNoTitle
{
    NSArray *rows = nil;
    NSString *title = nil;
    
    IBATableViewSectionModel *m = [[[IBATableViewSectionModel alloc] initWithRows:rows title:title] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertNil(m.title, @"title should be nil");
    GHAssertEquals(m.rowCount, (IBAIndexPathRowType)0, @"model rowCount should be zero");
}


- (void)testShouldGetRowAtIndex
{
    NSArray *rows = IBA_NSARRAY(@"A", @"B");
    NSString *title = @"Title";
    
    IBATableViewSectionModel *m = [[[IBATableViewSectionModel alloc] initWithRows:rows title:title] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    
    GHAssertEqualStrings([m rowAtIndex:0], @"A", @"row at index 0 should be A");
    GHAssertEqualStrings([m rowAtIndex:1], @"B", @"row at index 0 should be B");
}

@end
