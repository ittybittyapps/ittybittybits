//  Copyright (c) 2011, Kevin O'Neill
//  All rights reserved.
//
//  Modified by Jason Morrissey & Oliver Jones
//  Original Source: UBAlertView at https://github.com/kevinoneill/Useful-Bits
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
//  * Neither the name UsefulBits nor the names of its contributors may be used
//   to endorse or promote products derived from this software without specific
//   prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "IBAAlertView.h"
#import "IBACommon.h"

@interface IBAAlertView()

- (void)alertViewCancel:(UIAlertView *)alertView;
- (id)initWithTitle:(NSString*)title message:(NSString*)msg;
- (void)setAlertViewCancelBlock:(void(^)(IBAAlertView*))block;

@property (nonatomic, copy) IBAlertViewCancelActionBlock cancel;
@property (nonatomic, retain) NSMutableArray *buttonBlocks;

@end

@implementation IBAAlertView

+ (IBAAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message
{
    return [IBAAlertView alertViewWithTitle:title message:message cancelButtonTitle:IBALocalizedString(@"OK")];
}

+ (IBAAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    IBAAlertView *alertView = [[[IBAAlertView alloc] initWithTitle:title message:message] autorelease];
    
    if (cancelButtonTitle)
    {
        [alertView addButtonWithTitle:cancelButtonTitle block:nil];
        [alertView setCancelButtonIndex:0];
    }
    return alertView;
}

IBA_SYNTHESIZE(cancel, buttonBlocks);

- (id)initWithTitle:(NSString*)title message:(NSString*)msg
{
    if ((self = [super initWithTitle:title message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil]))
    {
        IBA_RETAIN_PROPERTY(buttonBlocks, [NSMutableArray array]);
        self.delegate = self;
    }
    
    return self;
}

- (void)dealloc
{
    IBA_RELEASE_PROPERTY(cancel);
    IBA_RELEASE_PROPERTY(buttonBlocks);
    
    [super dealloc];
}

- (void)addButtonWithTitle:(NSString*)title block:(IBAlertViewActionBlock)block
{
    [self addButtonWithTitle:title];
    if (block == nil)
    {
        block = ^(IBAAlertView * IBA_UNUSED alertView, NSInteger IBA_UNUSED i){};
    }
    
    [self.buttonBlocks addObject:[[block copy] autorelease]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0) 
    {
        ((IBAlertViewActionBlock)[self.buttonBlocks objectAtIndex:IBANSIntegerToNSUInteger(buttonIndex)])((IBAAlertView*)alertView, buttonIndex);
    }
    else
    {
        IBA_RUN_BLOCK(self.cancel, (IBAAlertView*)alertView);
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if (self.cancel)
    {
        self.cancel((IBAAlertView*)alertView);
    }
    else
    {
        [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
    }
}

- (void)setAlertViewCancelBlock:(IBAlertViewCancelActionBlock)block
{
    if (block != self.cancel)
    {
        self.cancel = block;
    }
}

@end
