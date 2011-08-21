//
//  UINib+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
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

/*!
 \brief     Instantiate a UINavigationController from the nib with the specified \a rootViewController pushed onto the navigation stack.
 \return    The first UINavigationController instance found in the nib; otherwise nil.
 */
- (UINavigationController *)ibaInstantiateNavigationControllerWithRootViewController:(UIViewController *)rootViewController
{
    NSArray *contents = [self ibaInstantiateWithOwner:nil proxyObjects:nil];
    for (id o in contents) 
    {
        if ([o isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *navController = (UINavigationController *)o;
            [navController pushViewController:rootViewController animated:NO];
            
            return navController;
        }
    }

    return nil;
}

@end
