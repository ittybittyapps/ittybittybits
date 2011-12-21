//
//  IBATableViewModel.h
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

#import <UIKit/UIKit.h>
#import "IBATableViewSectionModel.h"
#import "NSIndexPath+UITableView+IBAExtensions.h"

@interface IBATableViewModel : NSObject

+ (id)tableViewModel;
+ (id)tableViewModelWithSection:(IBATableViewSectionModel *)section;
+ (id)tableViewModelWithSections:(NSArray *)sections;
+ (id)tableViewModelWithSectionTitles:(NSArray *)sectionTitles;

- (id)initWithSection:(IBATableViewSectionModel *)section;
- (id)initWithSections:(NSArray *)sections;
- (id)initWithSectionTitles:(NSArray *)sectionTitles;

- (void)addSection:(IBATableViewSectionModel *)section;
- (void)addSections:(NSArray *)sections;
- (void)replaceSectionAtIndex:(NSInteger)sectionIndex withSection:(IBATableViewSectionModel *)section;

- (NSInteger)sectionCount;
- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex;

- (void)withEachSectionPerformBlock:(void (^)(NSInteger index, IBATableViewSectionModel *sectionModel))block;

- (IBATableViewSectionModel *)sectionAtIndex:(NSInteger)sectionIndex;
- (id)objectAtIndexPath:(NSIndexPath*)indexPath;

- (void)removeAllSections;

@end

@interface NSIndexPath (IBATableViewModel)

- (NSInteger)ibaTableViewModelSection;
- (NSInteger)ibaTableViewModelRow;

- (BOOL)ibaIsLastRowOfSectionInTableViewModel:(IBATableViewModel *)tableViewModel;
- (BOOL)ibaIsLastRowInTableViewModel:(IBATableViewModel *)tableViewModel;

@end
