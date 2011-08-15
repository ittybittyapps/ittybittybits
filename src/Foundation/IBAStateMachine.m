//
//  IBAStateMachine.m
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

#import "IBAStateMachine.h"
#import "IBACommon.h"
#import "NSMutableDictionary+IBAExtensions.h"

@interface IBAStateMachine ()
{
    NSMutableDictionary *states;
    NSMutableDictionary *exitStateActions;
    NSMutableDictionary *enterStateActions;
}

@property (nonatomic, assign, readwrite) IBAState currentState;

@end

@implementation IBAStateMachine

IBA_SYNTHESIZE(currentState);

/*!
 \brief     Initialize an instance with the intial state of \a state.
 */
- (id)initWithInitialState:(IBAState)state
{
    if ((self = [super init]))
    {
        self.currentState = state;
        states = [NSMutableDictionary new];
        enterStateActions = [NSMutableDictionary new];
        exitStateActions = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    IBA_RELEASE(states);
    IBA_RELEASE(enterStateActions);
    IBA_RELEASE(exitStateActions);
    
    [super dealloc];
}

- (void)whenExitingState:(IBAState)state invokeAction:(IBAStateActionBlock)action
{
    NSMutableArray *actions = [exitStateActions ibaObjectForIntegerKey:state];
    if (actions == nil)
    {
        actions = [NSMutableArray array];
        [exitStateActions ibaSetObject:actions forIntegerKey:state];
    }
    
    [actions addObject:[[action copy] autorelease]];
}

- (void)whenEnteringState:(IBAState)state invokeAction:(IBAStateActionBlock)action
{
    NSMutableArray *actions = [enterStateActions ibaObjectForIntegerKey:state];
    if (actions == nil)
    {
        actions = [NSMutableArray array];
        [enterStateActions ibaSetObject:actions forIntegerKey:state];
    }
    
    [actions addObject:[[action copy] autorelease]];
}

- (void)addTransitionFromState:(IBAState)fromState 
                       toState:(IBAState)toState 
{
    [self addTransitionFromState:(IBAState)fromState toState:(IBAState)toState withTransition:nil];
}

- (void)addTransitionFromState:(IBAState)fromState
                       toState:(IBAState)toState
                withTransition:(IBAStateTransitionBlock)transition
{
    NSMutableDictionary *transitions = [states ibaObjectForIntegerKey:fromState];
    if (transitions == nil)
    {
        transitions = [NSMutableDictionary dictionary];
        [states ibaSetObject:transitions forIntegerKey:fromState];
    }
    
    // Store an NSNull if the transition is nil.
    transition = transition == nil ? [NSNull null] : [[transition copy] autorelease];
    
    [transitions ibaSetObject:transition forIntegerKey:toState];
}

- (void)transitionToState:(IBAState)state
{
    if (self.currentState == state)
    {
        return;
    }
    
    NSMutableArray *exitActions = [exitStateActions ibaObjectForIntegerKey:self.currentState];
    NSMutableArray *enterActions = [enterStateActions ibaObjectForIntegerKey:state];
    NSMutableDictionary *transitions = [states ibaObjectForIntegerKey:self.currentState];
    IBAStateTransitionBlock transition = [transitions ibaObjectForIntegerKey:state];
    
    if (transition == nil)
    {   
        NSString *reason = [NSString stringWithFormat:@"There is no transition from state %d to state %d.", self.currentState, state];
        @throw [NSException exceptionWithName:@"IBAInvalidStateException" reason:reason userInfo:nil];
    }
    else
    {
        if (exitActions)
        {
            for (IBAStateActionBlock action in exitActions)
            {
                action(self.currentState);
            }
        }
        
        if ([transition isKindOfClass:[NSNull class]] == NO)
        {
            transition(self.currentState, state);
        }
        
        if (enterActions)
        {
            for (IBAStateActionBlock action in enterActions)
            {
                action(state);
            }
        }
        
        self.currentState = state;
    }
}

@end
