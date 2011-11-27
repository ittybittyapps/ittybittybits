//
//  UITableView+IBAExtensions.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 3/11/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (IBAExtensions)

#pragma mark - iOS 5 Backwards Compatibility

#if !defined(__IPHONE_5_0) || __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_5_0

@property(nonatomic) BOOL allowsMultipleSelection;
- (NSArray *)indexPathsForSelectedRows;

#endif

- (NSIndexPath *)ibaIndexPathOfRowBeforeIndexPath:(NSIndexPath*)indexPath;

@end
