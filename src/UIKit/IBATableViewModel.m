//
//  IBATableViewModel.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 14/09/11.
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

#import "IBATableViewModel.h"
#import "IBATableViewSectionModel.h"
#import "NSIndexPath+UITableView+IBAExtensions.h"

#import "../Foundation/IBAFoundation.h"

#import <objc/runtime.h>

@interface IBATableViewModel ()
@property (nonatomic, retain) NSMutableArray *sections;
@end

@implementation IBATableViewModel
{
}

IBA_SYNTHESIZE(sections);

+ (id)tableViewModel
{
    return [self tableViewModelWithSections:[NSArray array]];
}

+ (id)tableViewModelWithSection:(IBATableViewSectionModel *)section
{
    return [self tableViewModelWithSections:IBA_NSARRAY(section)];
}

+ (id)tableViewModelWithSections:(NSArray *)sections
{
    return [[[self alloc] initWithSections:sections] autorelease];
}

+ (id)tableViewModelWithSectionTitles:(NSArray *)sectionTitles
{
    return [[[self alloc] initWithSectionTitles:sectionTitles] autorelease];
}

- (id)initWithSectionTitles:(NSArray *)sectionTitles
{
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:[sectionTitles count]];
    for (NSString *title in sectionTitles)
    {
        [sections addObject:[IBATableViewSectionModel tableViewSectionModelWithTitle:title]];
    }
    
    return [self initWithSections:sections];
}

- (id)initWithSection:(IBATableViewSectionModel *)section
{
    return [self initWithSections:section ? IBA_NSARRAY(section) : [NSArray array]];
}

- (id)initWithSections:(NSArray *)sections
{
    if ((self = [super init]))
    {
        self.sections = sections ? [NSMutableArray arrayWithArray:sections] : [NSMutableArray array];
    }
    
    return self;
}

/*
 Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    IBA_RELEASE_PROPERTY(sections);
    [super dealloc];
}

/*!
 \return        Returns the count of sections in the model.
 */
- (NSInteger)sectionCount
{
    return IBANSUIntegerToNSInteger([self.sections count]);
}

/*!
 \return        Returns the number of rows in a section.
 */
- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [[self sectionAtIndex:section] rowCount];
}

/*!
 \brief     Add the specified \a section to the model.
 */
- (void)addSection:(IBATableViewSectionModel *)section
{
    IBAAssertNotNil(section);
    
    if (section)
    {
        [self.sections addObject:section];
    }
}

/*!
 \brief     Removes all sections from the model.
 */
- (void)removeAllSections
{
    [self.sections removeAllObjects];
}

/*!
 \brief     Add the specified array of \a sections to the model.
 */
- (void)addSections:(NSArray *)sections
{
    IBAAssertNotNil(sections);
    
    if (sections)
    {
        for (id section in sections)
        {
            NSAssert([section isKindOfClass:[IBATableViewSectionModel class]], @"sections array members must be instances of %s", class_getName([IBATableViewSectionModel class]));
            [self addSection:section];
        }
    }
}

- (void)replaceSectionAtIndex:(NSInteger)sectionIndex withSection:(IBATableViewSectionModel *)section
{
    IBAAssertNotNil(section);
    NSAssert(sectionIndex >= 0, @"sectionIndex must be greater than or equal to zero");
    
    if (section && sectionIndex >= 0)
    {
        [self.sections replaceObjectAtIndex:(NSUInteger)sectionIndex withObject:section];
    }
    
}

/*!
 \brief     Returns the section at the specified \a sectionIndex (or nil of none exists).
 */
- (IBATableViewSectionModel *)sectionAtIndex:(NSInteger)sectionIndex
{
    return [self.sections ibaIntegerIsWithinIndexBounds:sectionIndex] ? [self.sections objectAtIndex:IBANSIntegerToNSUInteger(sectionIndex)] : nil;
}

/*!
 \brief     Returns the object at the specified \a indexPath.
 \param     The index path (section & row) of the object to fetch.
 \return    The object at the specified \a indexPath; otherwise nil.
 */
- (id)objectAtIndexPath:(NSIndexPath*)indexPath
{
    return indexPath ? [[self sectionAtIndex:indexPath.ibaTableViewModelSection] rowAtIndex:indexPath.ibaTableViewModelRow] : nil;
}

/*!
 \brief     Perform the specified \a block for each section in the table model.
 */
- (void)withEachSectionPerformBlock:(void (^)(NSInteger sectionIndex, IBATableViewSectionModel *sectionModel))block
{
    for (NSInteger i = 0; i < self.sectionCount; ++i)
    {
        IBATableViewSectionModel *sectionModel = [self sectionAtIndex:i];
        IBA_RUN_BLOCK(block, i, sectionModel);
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ [\n\t%@\n]>", self.class, [[self.sections ibaMap:^(id i) { return [i description]; }] componentsJoinedByString:@",\n\t"]];
}

@end
        
@implementation NSIndexPath (IBATableViewModel)

- (NSInteger)ibaTableViewModelSection
{
    return IBAIndexPathSectionTypeToNSInteger(self.section);
}

- (NSInteger)ibaTableViewModelRow
{
    return IBAIndexPathRowTypeToNSInteger(self.row);    
}

/*!
 \brief     Returns a value that indicates whether the specified \a indexPath references the last row in a section.
 \return    YES if the \a indexPath references the last row in a table model section; otherwise NO.
 */
- (BOOL)ibaIsLastRowOfSectionInTableViewModel:(IBATableViewModel *)tableViewModel
{
    return self.ibaTableViewModelRow == ([tableViewModel numberOfRowsInSection:self.ibaTableViewModelSection] - 1);
}

/*!
 \brief     Returns a value that indicates whether the specified \a indexPath references the last row in the table model.
 \return    YES if the \a indexPath references the last row in the table model; otherwise NO.
 */
- (BOOL)ibaIsLastRowInTableViewModel:(IBATableViewModel *)tableViewModel
{
    NSInteger section = self.ibaTableViewModelSection;
    NSInteger row = self.ibaTableViewModelRow;
 
    // get the index of the last non-empty section
    NSInteger idx = [tableViewModel sectionCount] - 1;
    NSInteger lastNonEmptySectionIdx = -1;
    while (idx >= 0)
    {
        IBATableViewSectionModel *sectionModel = [tableViewModel sectionAtIndex:idx];
        if (sectionModel.rowCount > 0)
        {
            lastNonEmptySectionIdx = idx;
            break;
        }
    
        --idx;
    }
     
    return section == lastNonEmptySectionIdx  && row == ([tableViewModel numberOfRowsInSection:section] - 1);
}

@end

