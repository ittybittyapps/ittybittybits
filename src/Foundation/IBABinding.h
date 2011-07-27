//
//  IBABinding.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 25/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

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
