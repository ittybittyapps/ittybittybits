//
//  IBABindingManager.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 25/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

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
