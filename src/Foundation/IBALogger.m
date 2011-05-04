//
//  IBADebugLog.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 3/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//


#import "IBALogger.h"
#import "IBADebug.h"
#import "IBASynthesizeSingleton.h"

#import <stdarg.h>

@implementation IBALogger

IBA_SYNTHESIZE_SINGLETON_FOR_CLASS(IBALogger, sharedLogger)

@synthesize facility;
@synthesize name;

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init
{
    return [self initWithName:[[NSBundle mainBundle] bundleIdentifier]
                     facility:@"com.ittybittyapps.debug"];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithFacility:(NSString*) aFacility
{
    return [self initWithName:[[NSBundle mainBundle] bundleIdentifier] 
                     facility:aFacility];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithName:(NSString*)aName facility:(NSString*) aFacility
{
    if ((self = [super init]))
    {
        additionalFiles = [NSMutableDictionary new];
        logQueue = dispatch_queue_create("com.ittybittyapps.logger", NULL);
        dispatch_set_target_queue(logQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
        
        name = [aName retain];
        self.facility = aFacility;
    
        aslClient = asl_open([aName UTF8String], [aFacility UTF8String], 0);
        aslMsg = asl_new(ASL_TYPE_MSG);
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
    dispatch_sync(logQueue, ^{        
        asl_free(aslMsg);
        asl_close(aslClient);
        
        [name release]; 
        name = nil;
        
        [facility release];
        facility = nil;
        
        [additionalFiles release];
        additionalFiles = nil;
    });
    
    dispatch_release(logQueue);
    
    [super dealloc];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFacility:(NSString *)newFacility
{
    dispatch_sync(logQueue, ^{
        if (facility != newFacility)
        {
            [facility release];
            facility = [newFacility retain];
            asl_set(aslMsg, ASL_KEY_FACILITY, [facility UTF8String]);
        }
    });
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addLogFile:(NSString*)path
{
    dispatch_sync(logQueue, ^{
        if ([additionalFiles objectForKey:path] == nil)
        {
            NSFileHandle* handle = [NSFileHandle fileHandleForWritingAtPath:path];
            if (handle != nil)
            {
                [additionalFiles setObject:handle forKey:path];
            
                asl_add_log_file(aslClient, [handle fileDescriptor]);
            }
        }
    });
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) removeLogFile:(NSString*)path
{
    dispatch_sync(logQueue, ^{
        
        NSFileHandle* handle = [additionalFiles objectForKey:path];
        if (handle != nil)
        {
            asl_remove_log_file(aslClient, [handle fileDescriptor]);
            [additionalFiles removeObjectForKey:path];
        }
    });
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (void) log:(NSString*)format level:(NSInteger)level, ...
{
    va_list args;
    va_start(args, level);
    NSString* msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    dispatch_async(logQueue, ^ {
        if (asl_log(aslClient, aslMsg, level, "%s", [msg UTF8String]))
        {
            // Log failed, try using NSLog to log message instead.
            NSLog(@"%@", msg);
        }
    });
    
    [msg release];
}

@end
