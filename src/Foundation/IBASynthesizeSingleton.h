//
//  IBASynthesizeSingleton.h
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Modified by Oliver Jones.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname, accessorname) \
 \
static classname *shared##classname = nil; \
 \
+ (classname *)shared##accessorname \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
            shared##classname = [[self alloc] init]; \
        } \
    } \
     \
    return shared##classname; \
} \
 \
+ (id)allocWithZone:(NSZone *)zone \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
            shared##classname = [super allocWithZone:zone]; \
            return shared##classname; \
        } \
    } \
     \
    return nil; \
} \
 \
- (id)copyWithZone:(NSZone *)zone \
{ \
    return self; \
} \
 \
- (id)retain \
{ \
    return self; \
} \
 \
- (NSUInteger)retainCount \
{ \
    return NSUIntegerMax; \
} \
 \
- (void)release \
{ \
} \
 \
- (id)autorelease \
{ \
    return self; \
}
