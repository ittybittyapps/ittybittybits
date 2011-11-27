//
//  UITableView+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 3/11/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "UITableView+IBAExtensions.h"
#import "../Foundation/IBAFoundation.h"

#import "NSIndexPath+UITableView+IBAExtensions.h"

@implementation UITableView (IBAExtensions)

#pragma mark - iOS 5 Backwards Compatibility

#if !defined(__IPHONE_5_0) || __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_5_0

/*!
 \brief     Returns the index paths represented the selected rows.
 \return    An array of index-path objects each identifying a row through its section and row index. Returns nil if there are no selected rows.
 */
- (NSArray *)indexPathsForSelectedRows
{
    NSIndexPath *path = self.indexPathForSelectedRow;
    if (path)
    {
        return [NSArray arrayWithObject:path];
    }
    
    return nil;
}

/*!
 \brief     A Boolean value that determines whether users can select more than one row outside of editing mode.
 \details   Always NO (unsupported feature on iOS prior to 5.0).
 */
- (BOOL)allowsMultipleSelection
{
    return NO;
}

- (void)setAllowsMultipleSelection:(BOOL)IBA_UNUSED enabled
{
    NSAssert(enabled == NO, @"Multiple selection is unsupported on versions of iOS prior to 5.0");
}

#endif

- (NSIndexPath *)ibaIndexPathOfRowBeforeIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row > 0)
    {
        return [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
    }

    NSInteger section = indexPath.section;
    
    while (section > 0)
    {
        // move to previous section
        --section;
    
        NSInteger rows = [self numberOfRowsInSection:section];
        if (rows > 0)
        {
            return [NSIndexPath indexPathForRow:(rows - 1) inSection:section];
        }
    }

    return nil;
}

@end
