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

#define IBA_SYNTHESIZE_SINGLETON_FOR_CLASS(classname, accessorname) \
static classname *shared##classname = nil; \
+ (classname *)accessorname \
{ \
    static dispatch_once_t p; \
    dispatch_once(&p, \
    ^{ \
        if (shared##classname == nil) \
        { \
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; \
            shared##classname = [[self alloc] init]; \
            [pool drain]; \
        } \
    }); \
    return shared##classname; \
} \
+ (id)allocWithZone:(NSZone *)zone \
{ \
    static dispatch_once_t p; \
    __block classname* temp = nil; \
    dispatch_once(&p, \
    ^{ \
        if (shared##classname == nil) \
        { \
            temp = shared##classname = [super allocWithZone:zone]; \
        } \
    }); \
    return temp; \
} \
- (id)copyWithZone:(NSZone *)IBA_UNUSED zone { return self; } \
- (id)retain { return self; } \
- (NSUInteger)retainCount { return NSUIntegerMax; } \
- (oneway void)release { } \
- (id)autorelease { return self; }
