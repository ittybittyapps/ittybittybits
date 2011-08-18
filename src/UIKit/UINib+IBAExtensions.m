//
//  UINib+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "UINib+IBAExtensions.h"
#import "../Foundation/IBAFoundation.h"

@implementation UINib (IBAExtensions)

/*!
 \brief     Instantiate the contents of the receiving UINib and return the UITableViewCell instance with the specified \a reuseIdentifier.
 \param     ownerOrNil  The object to use as the owner of the nib file.
 \param     reuseIdentifier     The reuseIdentifier to search for.
 */
- (UITableViewCell*)ibaInstantiateWithOwner:(id)ownerOrNil forTableViewCellWithReuseIdentifier:(NSString*)reuseIdentifier
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

/*!
 \brief     Unarchives and instantiates the in-memory contents of the receiver’s nib file, creating a distinct object tree and set of top level objects.
 */
- (NSArray *)ibaInstantiate
{
    return [self ibaInstantiateWithOwner:nil];
}

/*!
 \brief     Unarchives and instantiates the in-memory contents of the receiver’s nib file, creating a distinct object tree and set of top level objects.
 
 \param     ownerOrNil      
 The object to use as the owner of the nib file.
 
 */
- (NSArray *)ibaInstantiateWithOwner:(id)ownerOrNil
{
    return [self ibaInstantiateWithOwner:ownerOrNil proxyObjects:nil];
}

/*!
 \brief     Unarchives and instantiates the in-memory contents of the receiver’s nib file, creating a distinct object tree and set of top level objects.
 
 \param     ownerOrNil      
 The object to use as the owner of the nib file.
 
 \param     dictionaryOrNil 
 A dictionary that contains the runtime replacement objects for any proxy objects used in the nib file. In this dictionary, the keys are the names associated with the proxy objects and the values are the actual objects from your code that should be used in their place.
 */
- (NSArray *)ibaInstantiateWithOwner:(id)ownerOrNil proxyObjects:(NSDictionary *)dictionaryOrNil
{
    NSDictionary *nibOptions = dictionaryOrNil ? [NSDictionary dictionaryWithObjectsAndKeys:dictionaryOrNil, UINibExternalObjects, nil] : nil;
    return [self instantiateWithOwner:ownerOrNil options:nibOptions];
}

@end
