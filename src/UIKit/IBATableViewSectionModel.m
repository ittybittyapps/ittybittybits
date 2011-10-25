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
- (NSInteger)rowCount
{   
    return IBANSUIntegerToNSInteger([self.rows count]);
}

/*!
 \brief     Removes the specified \a row from the section.
 */
- (void)removeRow:(id)row
{
    [self.rows removeObject:row];
}

/*!
 \brief     Removes the row at the specified \a index.
 */
- (void)removeRowAtIndex:(NSInteger)index
{
    if (index >= 0) 
    {
        [self.rows removeObjectAtIndex:IBANSIntegerToNSUInteger(index)];
    }
}

/*!
 \brief     Returns the row in the section for the specified index.
 \note      UITableViewDelegate and NSIndexPath(UITableView) have historically been inconsistent.  This has changed in iOS5 betas.  Not sure if it will remain that way.  But we try and deal with it here.
 */
- (id)rowAtIndex:(NSInteger)index
{
    return index >= 0 ? [self.rows objectAtIndex:IBANSIntegerToNSUInteger(index)] : nil;
}

/*!
 \brief     Adds a row to the section.
 */
- (void)addRow:(id)row
{
    [self.rows addObject:row];
}

/*!
 \brief     Returns all the rows in the section model.
 \return    An array of all the rows in the section model.
 */
- (NSArray *)allRows
{
    return [NSArray arrayWithArray:self.rows];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %@:[\n\t%@\n]>", self.class, self.title, self.rows];
}

@end
