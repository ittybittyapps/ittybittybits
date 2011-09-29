//
//  IBATableViewModelTests.m
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

#import "IBATableViewModelTests.h"
#import "IBAFoundation.h"
#import "IBATableViewModel.h"

@implementation IBATableViewModelTests

// Run before each test method
- (void)setUp {}

// Run after each test method
- (void)tearDown {}

// Run before the tests are run for this class
- (void)setUpClass {}

// Run before the tests are run for this class
- (void)tearDownClass {}

- (void)testShouldCreateTableViewModel
{
    IBATableViewModel *m = [IBATableViewModel tableViewModel];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertEquals([m sectionCount], 0, @"model should contain no sections");
}

- (void)testShouldCreateTableViewModelWithSection
{
    IBATableViewSectionModel *s = [IBATableViewSectionModel tableViewSectionModel];
    IBATableViewModel *m = [IBATableViewModel tableViewModelWithSection:s];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertEquals([m sectionCount], 1, @"model should contain 1 section");
    GHAssertEquals([m numberOfRowsInSection:0], 0, @"model section should contain no rows");
}

- (void)testShouldCreateTableViewModelWithSections
{
    IBATableViewSectionModel *s1 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B")];
    IBATableViewSectionModel *s2 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B", @"C")];
    NSArray *sections = IBA_NSARRAY(s1, s2);
    IBATableViewModel *m = [IBATableViewModel tableViewModelWithSections:sections];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertEquals([m sectionCount], 2, @"model should contain 2 sections");
    GHAssertEquals([m numberOfRowsInSection:0], 2, @"model section 0 should contain 2 rows");
    GHAssertEquals([m numberOfRowsInSection:1], 3, @"model section 1 should contain 3 rows");
}

- (void)testShouldCreateTableViewModelWithSectionTitles
{
    IBATableViewModel *m = [IBATableViewModel tableViewModelWithSectionTitles:IBA_NSARRAY(@"A", @"B")];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertEquals([m sectionCount], 2, @"model should contain 2 sections");
    GHAssertEqualStrings([m sectionAtIndex:0].title, @"A", @"model section 0 title should be 'A'");
    GHAssertEqualStrings([m sectionAtIndex:1].title, @"B", @"model section 1 title should be 'B'");
}

- (void)testShouldInitTableViewModelWithSection
{
    IBATableViewSectionModel *s = [IBATableViewSectionModel tableViewSectionModel];
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSection:s] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertEquals([m sectionCount], 1, @"model should contain 1 section");
    GHAssertEquals([m numberOfRowsInSection:0], 0, @"model section should contain no rows");
}

- (void)testShouldInitTableViewModelWithNoSection
{
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSection:nil] autorelease];
    GHAssertEquals([m sectionCount], 0, @"model should contain no sections");
}

- (void)testShouldInitTableViewModelWithNoSections
{
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSections:nil] autorelease];
    GHAssertEquals([m sectionCount], 0, @"model should contain no sections");
}

- (void)testShouldInitTableViewModelWithSections
{
    IBATableViewSectionModel *s1 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B")];
    IBATableViewSectionModel *s2 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B", @"C")];
    NSArray *sections = IBA_NSARRAY(s1, s2);
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSections:sections] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertEquals([m sectionCount], 2, @"model should contain 1 section");
    GHAssertEquals([m numberOfRowsInSection:0], 2, @"model section 0 should contain 2 rows");
    GHAssertEquals([m numberOfRowsInSection:1], 3, @"model section 1 should contain 3 rows");
}

- (void)testShouldInitTableViewModelWithSectionTitles
{
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSectionTitles:IBA_NSARRAY(@"A", @"B")] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    GHAssertEquals([m sectionCount], 2, @"model should contain 2 sections");
    GHAssertEqualStrings([m sectionAtIndex:0].title, @"A", @"model section 0 title should be 'A'");
    GHAssertEqualStrings([m sectionAtIndex:1].title, @"B", @"model section 1 title should be 'B'");
}

#ifdef DEBUG
- (void)testShouldAssertOnAddingNilSection
{
    IBATableViewModel *m = [IBATableViewModel tableViewModel];
    GHAssertThrows([m addSection:nil], @"should throw assert");
}
#endif

- (void)testShouldAddSection
{
    IBATableViewSectionModel *s = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B")];
    IBATableViewModel *m = [IBATableViewModel tableViewModel];
    [m addSection:s];
    
    GHAssertEquals([m sectionCount], 1, @"section count should be 1");
    GHAssertEquals([m sectionAtIndex:0], s, @"section at index 0 should be s");
}

#ifdef DEBUG
- (void)testShouldThrowOnAddingNilSections
{
    IBATableViewModel *m = [IBATableViewModel tableViewModel];
    GHAssertThrows([m addSections:nil], @"should throw assert");
}
#endif

- (void)testShouldAddSections
{
    IBATableViewSectionModel *s1 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B")];
    IBATableViewSectionModel *s2 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B", @"C")];
    NSArray *sections = IBA_NSARRAY(s1, s2);

    IBATableViewModel *m = [IBATableViewModel tableViewModel];
    [m addSections:sections];
    
    GHAssertEquals([m sectionCount], 2, @"model should contain 1 section");
    GHAssertEquals([m numberOfRowsInSection:0], 2, @"model section 0 should contain 2 rows");
    GHAssertEquals([m numberOfRowsInSection:1], 3, @"model section 1 should contain 3 rows");
}

- (void)testShouldReturnZeroOnNumberOfRowsInSectionForUnknownSection
{
    IBATableViewSectionModel *s = [IBATableViewSectionModel tableViewSectionModel];
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSection:s] autorelease];
    GHAssertNotNil(m, @"model should not be nil");

    GHAssertEquals([m numberOfRowsInSection:12], 0, @"should return zero for unknown section");
}

- (void)testShouldReturnNilOnSectionAtIndexForUnknownSection
{
    IBATableViewSectionModel *s = [IBATableViewSectionModel tableViewSectionModel];
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSection:s] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    
    GHAssertNil([m sectionAtIndex:12], @"should return nil for unknown section index");
}

- (void)testShouldReturnNilOnObjectAtIndexPathForNilIndexPath
{
    IBATableViewSectionModel *s = [IBATableViewSectionModel tableViewSectionModel];
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSection:s] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    
    GHAssertNil([m objectAtIndexPath:nil], @"should return nil for nil index path");
}

- (void)testShouldReturnNilOnObjectAtIndexPathForInvalidIndexPath
{
    IBATableViewSectionModel *s = [IBATableViewSectionModel tableViewSectionModel];
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSection:s] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:10];
    GHAssertNil([m objectAtIndexPath:indexPath], @"should return nil for invalid index path");
}

- (void)testShouldReturnRowOnObjectAtIndexPath
{
    IBATableViewSectionModel *s = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B")];
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSection:s] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    GHAssertEquals([m objectAtIndexPath:indexPath], @"A", @"should return A for valid index path");
}

- (void)testShouldThrowOnReplaceSectionAtIndexWithSectionForInvalidSectionIndex
{
    IBATableViewSectionModel *s1 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B")];
    IBATableViewSectionModel *s2 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B", @"C")];
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSection:s1] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    
    
    GHAssertThrows([m replaceSectionAtIndex:12 withSection:s2], @"should throw with invalid section index");
}

- (void)testShouldThrowOnReplaceSectionAtIndexWithSectionForNilSection
{
    IBATableViewSectionModel *s1 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B")];
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSection:s1] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    
    
    GHAssertThrows([m replaceSectionAtIndex:0 withSection:nil], @"should throw with nil section");
}

- (void)testShouldReplaceSectionAtIndexWithSection
{
    IBATableViewSectionModel *s1 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B")];
    IBATableViewSectionModel *s2 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B", @"C")];
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSection:s1] autorelease];
    GHAssertNotNil(m, @"model should not be nil");
    
    
    [m replaceSectionAtIndex:0 withSection:s2];
    GHAssertEquals([m sectionCount], 1, @"section count should be zero");
    GHAssertEquals([m sectionAtIndex:0], s2, @"section at index 0 should be s2");
}

- (void)testShouldRemoveAllSections
{
    IBATableViewSectionModel *s1 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B")];
    IBATableViewSectionModel *s2 = [IBATableViewSectionModel tableViewSectionModelWithRows:IBA_NSARRAY(@"A", @"B", @"C")];
    IBATableViewModel *m = [[[IBATableViewModel alloc] initWithSections:IBA_NSARRAY(s1, s2)] autorelease];
    
    GHAssertEquals([m sectionCount], 2, @"should contain two sections");
    
    [m removeAllSections];
    
    GHAssertEquals([m sectionCount], 0, @"should contain no sections");
}

@end
