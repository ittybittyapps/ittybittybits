//
//  IBAActionSheet.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 17/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//
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

#import "IBAActionSheet.h"
#import "../Foundation/IBACommon.h"
#import "../Foundation/NSNumber+IBAExtensions.h"

@interface IBAActionSheet ()
@property (nonatomic, assign) id<UIActionSheetDelegate> actionSheetDelegate;
@property (nonatomic, retain) NSMutableDictionary *actions;
@end

@implementation IBAActionSheet

IBA_SYNTHESIZE(actionSheetDelegate);
IBA_SYNTHESIZE(actions);

+ (id)actionSheetWithTitle:(NSString *)title 
                  delegate:(id<UIActionSheetDelegate>)delegate 
{
    return [[[self alloc] initWithTitle:title delegate:delegate] autorelease];
}

+ (id)actionSheet
{
    return [[[self alloc] initWithTitle:nil delegate:nil] autorelease];
}

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate
{
    if ((self = [super initWithTitle:title 
                            delegate:self 
                   cancelButtonTitle:nil 
              destructiveButtonTitle:nil 
                   otherButtonTitles:nil]))
    {
        self.actionSheetDelegate = delegate;
        self.actions = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)dealloc
{
    self.actionSheetDelegate = nil;
    self.actions = nil;
    
    [super dealloc];
}

- (void)setDelegate:(id<UIActionSheetDelegate>)delegate
{
    if (delegate == self)
    {
        super.delegate = delegate;
    }
    else
    {
        self.actionSheetDelegate = delegate;
    }
}

/*!
 \brief     Adds a custom button to the action sheet.
 \param     title       The title of the new button.
 \param     blk         The block to invoke when the action button is pressed.
 \return    The index of the new button. Button indices start at 0 and increase in the order they are added.
 */
- (NSInteger)addButtonWithTitle:(NSString *)title block:(IBAActionSheetActionBlock)blk
{
    if (self.actions == nil)
    {
        self.actions = [NSMutableDictionary dictionary];
    }
    
    NSInteger index = [self addButtonWithTitle:title];
    [self.actions setObject:[[blk copy] autorelease] forKey:IBAIntToNumber(index)];
    return index;
}

/*!
 \brief     Adds a destructive button to the action sheet.
 \param     title       The title of the new button.
 \param     blk         The block to invoke when the action button is pressed.
 \return    The index of the new button. Button indices start at 0 and increase in the order they are added.
 */
- (NSInteger)setDestructiveButtonTitle:(NSString *)title block:(IBAActionSheetActionBlock)blk
{
    return self.destructiveButtonIndex = [self addButtonWithTitle:title block:blk];    
}

/*!
 \brief     Adds a cancel button to the action sheet.
 \param     title       The title of the new button.
 \param     blk         The block to invoke when the action button is pressed.
 \return    The index of the new button. Button indices start at 0 and increase in the order they are added.
 */
- (NSInteger)setCancelButtonTitle:(NSString *)title block:(IBAActionSheetActionBlock)blk
{
    return self.cancelButtonIndex = [self addButtonWithTitle:title block:blk];    
}

/*!
 \brief     Adds a cancel button to the action sheet.
 \param     title       The title of the new button.
 \return    The index of the new button. Button indices start at 0 and increase in the order they are added.
 */
- (NSInteger)setCancelButtonTitle:(NSString *)title
{
    return self.cancelButtonIndex = [self addButtonWithTitle:title];    
}

#pragma mark -
#pragma mark UIActionSheetDelegate Protocol Methods

/*!
 Sent to the delegate when the user clicks a button on an action sheet.
*/
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    IBAActionSheetActionBlock blk = [self.actions objectForKey:IBAIntToNumber(buttonIndex)];
    if (blk)
    {
        blk(self);
    }
    
    if ([self.actionSheetDelegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
    {
        [self.actionSheetDelegate actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    }
}

/*!
 Sent to the delegate before an action sheet is presented to the user.
 */
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    if ([self.actionSheetDelegate respondsToSelector:@selector(willPresentActionSheet:)])
    {
        [self.actionSheetDelegate willPresentActionSheet:actionSheet];
    }
}

/*!
 Sent to the delegate after an action sheet is presented to the user.
*/
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    if ([self.actionSheetDelegate respondsToSelector:@selector(didPresentActionSheet:)])
    {
        [self.actionSheetDelegate didPresentActionSheet:actionSheet];
    }
}

/*!
 Sent to the delegate before an action sheet is dismissed.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([self.actionSheetDelegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)])
    {
        [self.actionSheetDelegate actionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
    }
}

/*!
 Sent to the delegate after an action sheet is dismissed from the screen.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([self.actionSheetDelegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)])
    {
        [self.actionSheetDelegate actionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
    }
}

/*!
 Sent to the delegate before an action sheet is canceled.
*/
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    if ([self.actionSheetDelegate respondsToSelector:@selector(actionSheetCancel:)])
    {
        [self.actionSheetDelegate actionSheetCancel:actionSheet];
    }
}

@end
