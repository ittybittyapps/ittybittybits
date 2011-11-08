//
//  IBAResourceManager.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 25/08/11.
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

#import <UIKit/UIKit.h>

@class IBAResourceBundle;

@interface IBAResourceManager : NSObject

/*!
 \brief     Returns a shared singleton instance of the theme manager.
 */
+ (IBAResourceManager *)sharedInstance;

- (void)pushResourceBundle:(IBAResourceBundle *)bundle;
- (void)popResourceBundle;

- (UIImage *)imageNamed:(NSString *)name;
- (CGSize)sizeNamed:(NSString *)name;
- (CGRect)rectNamed:(NSString *)name;
- (UIColor *)colorNamed:(NSString *)name;
// gradients?
- (CGSize)sizeNamed:(NSString *)name;
- (CGRect)rectNamed:(NSString *)name;
- (CGPoint)pointNamed:(NSString *)name;
- (NSString *)stringNamed:(NSString *)name;
- (NSData *)dataNamed:(NSString *)name;
- (UIImage *)imageNamed:(NSString *)name;



@end
