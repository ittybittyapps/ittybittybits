//
//  IBAStack.m
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

#import "IBAStack.h"
#import "IBACommon.h"
#import "NSArray+IBAExtensions.h"

@implementation IBAStack
{
    NSMutableArray *stack;
}

/*!
 \brief
 Returns an auto-released stack instance.
 */
+ (IBAStack *)stack
{
    return [[[IBAStack alloc] init] autorelease];
}

/*!
 \brief
 Returns an auto-released stack with the specified capacity.
 */
+ (IBAStack *)stackWithCapacity:(NSUInteger)numItems
{
    return [[[IBAStack alloc] initWithCapacity:numItems] autorelease];
}

/*!
 \brief
 Returns an initialized stack.
 */
- (id)init
{
    return [self initWithCapacity:0];
}

/*!
 \brief     
 Returns a stack, initialized with enough memory to initially hold a given number of objects.
 
 \details
 This is the class designated initializer.
 
 \param     numItems
 The initial capacity of the new array.

 \return    
 An array initialized with enough memory to hold numItems objects.
 */
- (id)initWithCapacity:(NSUInteger)numItems
{
    if ((self = [super init]))
    {
        stack = numItems > 0 ? [[NSMutableArray alloc] initWithCapacity:numItems] : [[NSMutableArray alloc] init];
    }
 
    return self;
}

/*
 Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    IBA_RELEASE(stack);
    
    [super dealloc];
}

/*!
 \brief     
 Pushes the specified \a object onto the top of the stack.
 */
- (void)pushObject:(id)object
{
    [stack addObject:object];
}

/*!
 \brief
 Pops an object off the top of the stack and returns it to the caller.
 \return
 The object on the top of the stack (auto-released).
 */
- (id)popObject
{
    NSAssert([stack count] > 0, @"The stack can not be empty when popping off the stack!");
    
    if ([stack count] > 0)
    {
        id object = [[stack lastObject] retain];
        [stack removeObjectAtIndex:[stack count] - 1];
        
        return [object autorelease];
    }
    
    return nil;
}

/*!
 \brief
 Returns an array of all the objects in the stack.  
 \return
 An array of all elements in the stack. The first element of the returned array is the object on the top of the stack.
 */
- (NSArray *)popAllObjects
{
    NSArray* allObjects = [stack ibaReversedArray];
    [stack removeAllObjects];
    return allObjects;
}

/*!
 \brief
 Returns the object on the top of the stack.
 \return
 The object on the top of the stack.
 */
- (id)peekObject
{
    return [stack lastObject];
}

/*!
 \brief
 Returns a value indicating whether the stack is empty.
 \return
 YES if the stack is empty; otherwise NO.
 */
- (BOOL)isEmpty
{
    return [stack count] == 0;
}

/*!
 \brief
 Returns the number of items in the stack.
 \return
 The number of items (aka the depth) in the stack.
 */
- (NSUInteger)count
{
    return [stack count];
}

/*!
 Returns by reference a C array of objects over which the sender should iterate, and as the return value the number of objects in the array.
 */
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
    return [[stack ibaReversedArray] countByEnumeratingWithState:state objects:stackbuf count:len];
}

@end
