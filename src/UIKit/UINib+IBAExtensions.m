//
//  UINib+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "UINib+IBAExtensions.h"


@implementation UINib (IBAExtensions)

/*!
 \brief     Instantiate the contents of the receiving UINib and return the UITableViewCell instance with the specified \a reuseIdentifier.
 \param     ownerOrNil  The object to use as the owner of the nib file.
 \param     reuseIdentifier     The reuseIdentifier to search for.
 */
- (UITableViewCell*) instantiateWithOwner:(id)ownerOrNil forTableViewCellWithReuseIdentifier:(NSString*)reuseIdentifier
{
    NSArray *contents = [self instantiateWithOwner:ownerOrNil options:nil];
    for (id o in contents) 
    {
        if ([o isKindOfClass:[UITableViewCell class]])
        {
            UITableViewCell *cell = o;
            if ([cell.reuseIdentifier isEqualToString:reuseIdentifier])
            {
                return cell;
            }
        }
    }
    
    return nil;
}

@end
