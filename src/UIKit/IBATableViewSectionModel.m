//
//  IBATableViewSectionModel.m
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

#import "IBATableViewSectionModel.h"
#import "../Foundation/IBAFoundation.h"

@interface IBATableViewSectionModel ()
@property (nonatomic, retain) NSMutableArray *rows;
@end

@implementation IBATableViewSectionModel

IBA_SYNTHESIZE(title, rows);

/*!
 \brief     Returns an auto-released IBATableViewSectionModel 
 */
+ (id)tableViewSectionModel
{
    return [self tableViewSectionModelWithRows:[NSArray array] title:nil];
}

/*!
 \brief     Returns an auto-released IBATableViewSectionModel initialized with the specified \a rows and \a title.
 */
+ (id)tableViewSectionModelWithRows:(NSArray *)rows title:(NSString*)title
{
    return [[[self alloc] initWithRows:rows title:title] autorelease];
}

/*!
 \brief     Returns an auto-released IBATableViewSectionModel initialized with the specified \a rows.
 */
+ (id)tableViewSectionModelWithRows:(NSArray *)rows
{
    return [self tableViewSectionModelWithRows:rows title:nil];
}

/*!
 \brief     Returns an auto-released IBATableViewSectionModel initialized with no rows and the specified \a title.
 */
+ (id)tableViewSectionModelWithTitle:(NSString *)title
{
    return [self tableViewSectionModelWithRows:[NSArray array] title:title];
}

/*!
 \brief     Initialize the section with the specified \a rows and \a title.
 \param     rows        The rows in table the section.
 \param     title       The title of the section.
 */
- (id)initWithRows:(NSArray *)rows title:(NSString *)title
{
    if ((self = [super init]))
    {
        self.title = title;
        self.rows = rows ? [NSMutableArray arrayWithArray:rows] : [NSMutableArray array];
    }
    
    return self;
}

/*!
 \brief     Initialize the section with no rows and the specified \a title.
 \param     title       The title of the section.
 */
- (id)initWithTitle:(NSString *)title
{
    return [self initWithRows:nil title:title];
}

/*!
 \brief     Initialize the section with the specified \a rows.
 \param     rows        The rows in table the section.
 */
- (id)initWithRows:(NSArray *)rows
{
    return [self initWithRows:rows title:nil];
}

/*!
 Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    IBA_RELEASE_PROPERTY(title);
    IBA_RELEASE_PROPERTY(rows);
    
    [super dealloc];
}

/*!
 \brief     Returns the number of rows in the section.
 */
- (IBAIndexPathRowType)rowCount
{   
    return IBANSUIntegerToIBAIndexPathRowType([self.rows count]);
}

/*!
 \brief     Returns the row in the section for the specified index.
 \note      On iOS 5 we use a signed \a index because NSIndexPath.row is signed.  Normally you would use an unsigned index.  Silly UITableView API design.
 */
- (id)rowAtIndex:(IBAIndexPathRowType)index
{
    BOOL withinBounds = 
#if IBA_NSINDEXPATH_ROW_IS_SIGNED
    [self.rows ibaIntegerIsWithinIndexBounds:index]
#else
    index < [self.rows count] 
#endif
    ;
    
    return withinBounds ? [self.rows objectAtIndex:IBAIndexPathRowTypeToNSUInteger(index)] : nil;
}

/*!
 \brief     Adds a row to the section.
 */
- (void)addRow:(id)row
{
    [self.rows addObject:row];
}

@end
