//
//  IBAStack.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 25/08/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBAStack : NSObject<NSFastEnumeration>

+ (IBAStack *)stack;
+ (IBAStack *)stackWithCapacity:(NSUInteger)numItems;

- (id)initWithCapacity:(NSUInteger)numItems;
- (void)pushObject:(id)object;
- (id)popObject;
- (NSArray *)popAllObjects;
- (id)peekObject;
- (BOOL)isEmpty;
- (NSUInteger)count;

@end
