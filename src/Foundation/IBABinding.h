//
//  IBABinding.h
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

@class IBABinding;

typedef void (^IBABindingActionBlock)(IBABinding *binding, id oldValue, id newValue);

@interface IBABinding : NSObject

@property (nonatomic, retain, readonly) NSObject *source;
@property (nonatomic, retain, readonly) NSObject *target;
@property (nonatomic, retain, readonly) NSString *sourceKeyPath;
@property (nonatomic, retain, readonly) NSString *targetKeyPath;
@property (nonatomic, copy, readonly) IBABindingActionBlock action;

+ (id)bindingWithSourceObject:(NSObject *)source
                sourceKeyPath:(NSString *)sourceKeyPath
                 targetObject:(NSObject *)target
                   targetPath:(NSString *)targetKeyPath
             initializeTarget:(BOOL)initializeTarget
                       action:(IBABindingActionBlock)blockOrNil;

- (id)initWithSourceObject:(NSObject *)source
             sourceKeyPath:(NSString *)sourceKeyPath
              targetObject:(NSObject *)target
                targetPath:(NSString *)targetKeyPath
          initializeTarget:(BOOL)initializeTarget
                    action:(IBABindingActionBlock)blockOrNil;

@end
