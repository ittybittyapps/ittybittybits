//
//  IBAStateMachine.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/07/11.
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

typedef NSInteger IBAState;
typedef void (^IBAStateTransitionBlock)(IBAState from, IBAState to);
typedef void (^IBAStateActionBlock)(IBAState state);

@interface IBAStateMachine : NSObject

- (id)initWithInitialState:(IBAState)state;

- (void)addTransitionFromState:(IBAState)fromState 
                       toState:(IBAState)toState;
- (void)addTransitionFromState:(IBAState)fromState 
                       toState:(IBAState)toState 
                withTransition:(IBAStateTransitionBlock)transition;

- (void)transitionToState:(IBAState)state;

- (void)whenExitingState:(IBAState)state invokeAction:(IBAStateActionBlock)action;
- (void)whenEnteringState:(IBAState)state invokeAction:(IBAStateActionBlock)action;

@property (nonatomic, readonly) IBAState currentState;

@end
