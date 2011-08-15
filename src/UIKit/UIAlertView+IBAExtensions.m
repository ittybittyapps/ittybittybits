//
//  UIAlertView+IBAHelpers.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 12/05/11.
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

#import "UIAlertView+IBAExtensions.h"
#import "../Foundation/IBACommon.h"

@implementation UIAlertView (IBAHelpers)

/*!
 \brief     Show a simple modal alert with a \a title, \a message, and OK button.
 \param     title       The alert title.
 \param     message     The alert message.
 */
+ (void)ibaShowSimpleAlertWithTitle:(NSString *)title message:(NSString *)message
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
