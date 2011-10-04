//
//  IBABindingManager.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 25/07/11.
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

#import <Foundation/Foundation.h>
#import "IBABinding.h"

typedef enum 
{
    IBABindingManagerOptionsNone = 0,
    IBABindingManagerOptionsIntializeTarget,
    IBABingingManagerOptionsBidirectional
} IBABindingManagerOptions;

@interface IBABindingManager : NSObject

- (void)bindSource:(NSObject *)source 
       withKeyPath:(NSString *)sourceKeyPath 
          toTarget:(NSObject *)target;

- (void)bindSource:(NSObject *)source 
       withKeyPath:(NSString *)sourceKeyPath 
          toTarget:(NSObject *)target 
 withTargetKeyPath:(NSString *)targetKeyPath;

- (void)bindSource:(NSObject *)source 
       withKeyPath:(NSString *)sourceKeyPath 
          toTarget:(NSObject *)target 
 withTargetKeyPath:(NSString *)targetKeyPath
           options:(IBABindingManagerOptions)options;

- (void)bindSource:(NSObject *)source 
       withKeyPath:(NSString *)sourceKeyPath 
          toTarget:(NSObject *)target 
 withTargetKeyPath:(NSString *)targetKeyPath
           options:(IBABindingManagerOptions)options
            action:(IBABindingActionBlock)blockOrNil;

- (void)unbindSource:(NSObject *)source;

@end
