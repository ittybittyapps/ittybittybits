//
//  IBATableViewController.h
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

#import "IBAViewController.h"

@class IBATableViewModel;

@interface IBATableViewController : IBAViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBATableViewModel *tableViewModel;

@property (nonatomic, assign) BOOL clearsSelectionOnViewWillAppear;

- (id)initWithStyle:(UITableViewStyle)style;

@end
