//
//  IBABinding.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 25/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "IBABinding.h"
#import "IBACommon.h"
#import "IBALogger.h"
#import "IBADebug.h"

#import <libkern/OSAtomic.h>

@interface IBABinding () {
    int32_t isSettingValue;
}

@end

@implementation IBABinding

IBA_SYNTHESIZE(source, 
               target, 
               sourceKeyPath, 
               targetKeyPath,
               action);

+ (id)bindingWithSourceObject:(NSObject *)source
                sourceKeyPath:(NSString *)sourceKeyPath
                 targetObject:(NSObject *)target
                   targetPath:(NSString *)targetKeyPath
             initializeTarget:(BOOL)initializeTarget
                       action:(IBABindingActionBlock)blockOrNil

{
    return [[[self alloc] initWithSourceObject:source 
                                 sourceKeyPath:sourceKeyPath 
                                  targetObject:target
                                    targetPath:targetKeyPath
                              initializeTarget:initializeTarget
                                        action:blockOrNil] autorelease];
}

- (id)initWithSourceObject:(NSObject *)source
             sourceKeyPath:(NSString *)sourceKeyPath
              targetObject:(NSObject *)target
                targetPath:(NSString *)targetKeyPath
          initializeTarget:(BOOL)initializeTarget
                    action:(IBABindingActionBlock)blockOrNil
{
    IBAAssertNotNil(source);
    IBAAssertNotNilOrEmptyString(sourceKeyPath);
    IBAAssertNotNil(target);
    IBAAssertNotNilOrEmptyString(targetKeyPath);
    
    self = [super init];
    if (self) 
    {
        IBA_RETAIN_PROPERTY(source, source);
        IBA_RETAIN_PROPERTY(target, target);
        IBA_RETAIN_PROPERTY(sourceKeyPath, sourceKeyPath);
        IBA_RETAIN_PROPERTY(targetKeyPath, targetKeyPath);
        IBA_PIVAR(action) = [blockOrNil copy];
        
        [source addObserver:self 
                 forKeyPath:sourceKeyPath 
                    options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld | (initializeTarget?NSKeyValueObservingOptionInitial : 0)
                    context:NULL];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.source)
    {
        // Don't re-enter binding code while setting original.
        if (OSAtomicCompareAndSwap32(0, 1, &isSettingValue))
        {
            NSAssert([[change objectForKey:NSKeyValueChangeKindKey] intValue] == NSKeyValueChangeSetting,
                     @"Binding collections is not supported yet.");

            NSObject *newValue = [change objectForKey:NSKeyValueChangeNewKey];
            NSObject *oldValue = [change objectForKey:NSKeyValueChangeOldKey];

            newValue = [newValue isKindOfClass:[NSNull class]] ? nil : newValue;
            oldValue = [oldValue isKindOfClass:[NSNull class]] ? nil : oldValue;
            
            IBALogDebug(@"Observed change in keyPath '%@' from '%@' to '%@' for binding %@.", 
                        keyPath, oldValue, newValue, self);
            
            if (self.action)
            {
                self.action(self, oldValue, newValue);
            }
            else
            {
                [self.target setValue:newValue forKey:self.targetKeyPath];
            }
            
            // remove re-entrancy guard.
            OSAtomicCompareAndSwap32(1, 0, &isSettingValue);
        }
    }
}

/*!
 Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    [self.source removeObserver:self forKeyPath:self.sourceKeyPath];
    
    IBA_RELEASE_PROPERTY(source);
    IBA_RELEASE_PROPERTY(target);
    IBA_RELEASE_PROPERTY(sourceKeyPath);
    IBA_RELEASE_PROPERTY(targetKeyPath);
    IBA_RELEASE_PROPERTY(action);
    
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: source:%@, sourceKeyPath:%@, target:%@, targetKeyPath:%@>", 
            [self class],  
            self.source,
            self.sourceKeyPath,
            self.target,
            self.targetKeyPath];
}

@end
