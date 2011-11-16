//
//  UITableView+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 3/11/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "UITableView+IBAExtensions.h"
#import "../Foundation/IBAFoundation.h"

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

@end