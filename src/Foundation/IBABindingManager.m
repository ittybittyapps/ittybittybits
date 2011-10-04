//
//  IBABindingManager.m
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

#import "IBABindingManager.h"
#import "IBABinding.h"

#import "IBACommon.h"
#import "NSMutableSet+IBAExtensions.h"

@interface IBABindingManager ()
{
    NSMutableSet *bindings;
}

@end
                    
@implementation IBABindingManager

- (id)init
{
    if ((self = [super init])) 
    {
        bindings = [NSMutableSet new];
    }
    
    return self;
}

- (void)bindSource:(NSObject *)source 
       withKeyPath:(NSString *)sourceKeyPath 
          toTarget:(NSObject *)target
{
    [self bindSource:source 
         withKeyPath:sourceKeyPath 
            toTarget:target 
   withTargetKeyPath:sourceKeyPath
             options:IBABindingManagerOptionsIntializeTarget];
}

- (void)bindSource:(NSObject *)source 
       withKeyPath:(NSString *)sourceKeyPath 
          toTarget:(NSObject *)target 
 withTargetKeyPath:(NSString *)targetKeyPath
{
    [self bindSource:source 
         withKeyPath:sourceKeyPath 
            toTarget:target 
   withTargetKeyPath:targetKeyPath
             options:IBABindingManagerOptionsIntializeTarget];
}

- (void)bindSource:(NSObject *)source 
       withKeyPath:(NSString *)sourceKeyPath 
          toTarget:(NSObject *)target 
 withTargetKeyPath:(NSString *)targetKeyPath
           options:(IBABindingManagerOptions)options
{
    [self bindSource:source 
         withKeyPath:sourceKeyPath 
            toTarget:target 
   withTargetKeyPath:targetKeyPath
             options:options
              action:nil];
}

- (void)bindSource:(NSObject *)source 
       withKeyPath:(NSString *)sourceKeyPath 
          toTarget:(NSObject *)target 
 withTargetKeyPath:(NSString *)targetKeyPath
           options:(IBABindingManagerOptions)options
            action:(IBABindingActionBlock)blockOrNil
{
    IBABinding *binding = [IBABinding bindingWithSourceObject:source
                                                sourceKeyPath:sourceKeyPath
                                                 targetObject:target
                                                   targetPath:targetKeyPath
                                             initializeTarget:IBA_HAS_FLAG(options, IBABindingManagerOptionsIntializeTarget)
                                                       action:blockOrNil];
    [bindings addObject:binding];
    
    if (IBA_HAS_FLAG(options, IBABingingManagerOptionsBidirectional))
    {
        IBABinding *targetBinding = [IBABinding bindingWithSourceObject:target
                                                    sourceKeyPath:targetKeyPath
                                                     targetObject:source
                                                       targetPath:sourceKeyPath
                                                       initializeTarget:NO
                                                           action:blockOrNil];
        [bindings addObject:targetBinding];
    }
}

- (void)unbindSource:(NSObject *)source
{
    if (source)
    {
        NSMutableArray *bindingsToRemove = [NSMutableArray new];
        for (IBABinding *b in bindings)
        {
            if (b.source == source)
            {
                [bindingsToRemove addObject:b];
            }
        }
        
        [bindings ibaRemoveObjectsInArray:bindingsToRemove];
        [bindingsToRemove release];
    }
}

- (void)dealloc
{
    IBA_RELEASE(bindings);
    
    [super dealloc];
}

@end
