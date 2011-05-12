//
//  UIAlertView+IBAHelpers.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 12/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "UIAlertView+IBAHelpers.h"
#import "../Foundation/IBACommon.h"

@implementation UIAlertView (IBAHelpers)

/*!
 \brief     Show a simple modal alert with a \a title, \a message, and OK button.
 \param     title       The alert title.
 \param     message     The alert message.
 */
+ (void)showSimpleAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil 
                                          cancelButtonTitle:IBALocalizedString(@"OK")
                                          otherButtonTitles:nil];
    
    [alert show];
    
    IBA_RELEASE(alert);
}

@end
