//
//  IBATableViewController.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 2/11/11.
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

#import "IBATableViewController.h"
#import "../Foundation/IBAFoundation.h"

#import "IBATableViewModel.h"

#import "UITableView+IBAExtensions.h"

@implementation IBATableViewController
{
    UITableViewStyle defaultTableViewStyle;
}

IBA_SYNTHESIZE(tableView, clearsSelectionOnViewWillAppear, tableViewModel);

- (id)initWithStyle:(UITableViewStyle)style
{
    if ((self = [super initWithNibName:[[self class] nibName] bundle:[[self class] bundle]]))
    {
        defaultTableViewStyle = style;
        IBA_RETAIN_PROPERTY(tableViewModel, [IBATableViewModel tableViewModel]);
    }
    
    return self;
}

- (void)setTableView:(UITableView *)newTableView
{
    IBA_RETAIN_PROPERTY(tableView, newTableView);

	self.tableView.delegate = self;
	self.tableView.dataSource = self;
}

- (void)releaseViews
{
    IBA_RELEASE_PROPERTY(tableView);
    [super releaseViews];
}

- (void)dealloc
{
    IBA_RELEASE_PROPERTY(tableViewModel);
    [super dealloc];
}

- (void)loadView
{
	if (self.nibName)
	{
		[super loadView];
		NSAssert(self.tableView != nil, @"NIB file did not set tableView property.");
		return;
	}
	
	UITableView *newTableView = [[[UITableView alloc] initWithFrame:CGRectZero style:defaultTableViewStyle] autorelease];
	self.view = newTableView;
	self.tableView = newTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.clearsSelectionOnViewWillAppear)
    {
        for (NSIndexPath *path in self.tableView.indexPathsForSelectedRows)
        {
            [self.tableView deselectRowAtIndexPath:path animated:animated];
        }
    }
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView flashScrollIndicators];
    
    [super viewDidAppear:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self.tableView setEditing:editing animated:animated];
    [super setEditing:editing animated:animated];
}

#pragma mark - Required UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)IBA_UNUSED tableView
{
	return self.tableViewModel.sectionCount;
}

- (NSInteger)tableView:(UITableView *)IBA_UNUSED tableView numberOfRowsInSection:(NSInteger)IBA_UNUSED section
{
    return [self.tableViewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)IBA_UNUSED tableView cellForRowAtIndexPath:(NSIndexPath *)IBA_UNUSED indexPath
{
    NSAssert(false, @"Subclasses need to implement tableView:cellForRowAtIndexPath:");
    return nil;
}

@end
