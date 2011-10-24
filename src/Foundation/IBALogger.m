//
//  IBADebugLog.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 3/05/11.
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

#import "IBALogger.h"
#import "IBADebug.h"
#import "IBACommon.h"
#import "IBASynthesizeSingleton.h"

#import <stdarg.h>

@implementation IBALogger
{
    dispatch_queue_t logQueue;
    aslmsg aslMsg;
    aslclient aslClient;
    NSMutableDictionary* additionalFiles;
}

IBA_SYNTHESIZE_SINGLETON_FOR_CLASS(IBALogger, sharedLogger)

@synthesize facility;
@synthesize name;

- (id)init
{
    return [self initWithName:[[NSBundle mainBundle] bundleIdentifier]
                     facility:@"com.ittybittyapps.debug"];
}

- (id)initWithFacility:(NSString *) aFacility
{
    return [self initWithName:[[NSBundle mainBundle] bundleIdentifier] 
                     facility:aFacility];
}

- (id)initWithName:(NSString *)aName facility:(NSString *)aFacility
{
    if ((self = [super init]))
    {
        additionalFiles = [NSMutableDictionary new];
        logQueue = dispatch_queue_create("com.ittybittyapps.logger", NULL);
        dispatch_set_target_queue(logQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
        
        name = [aName retain];
        self.facility = aFacility;
    
        uint32_t opts = ASL_OPT_STDERR   | // adds stderr as an output file descriptor
                        ASL_OPT_NO_DELAY | // connects to the server immediately
                        ASL_OPT_NO_REMOTE; // disables remote-control filter adjustment
        
        aslClient = asl_open([aName UTF8String], [aFacility UTF8String], opts);
        aslMsg = asl_new(ASL_TYPE_MSG);
    }
    
    return self;
}

- (void)dealloc
{
    dispatch_sync(logQueue, ^{        
        asl_free(aslMsg);
        asl_close(aslClient);
        
        IBA_RELEASE(name);
        IBA_RELEASE(facility);
        IBA_RELEASE(additionalFiles);
    });
    
    dispatch_release(logQueue);
    
    [super dealloc];
}

- (NSInteger)setFilter:(NSInteger)filter
{
    __block NSInteger previousValue = 0;
    dispatch_sync(logQueue, ^{
        previousValue = asl_set_filter(aslClient, filter);
    });
    
    return previousValue;
}

- (void)setFacility:(NSString *)newFacility
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

- (void)addLogFile:(NSString *)path
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

- (void)removeLogFile:(NSString *)path
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

- (void)log:(NSString*)format 
      level:(NSInteger)level
       file:(const char *)file
       line:(NSInteger)line
   function:(const char *)function, ...
{
    va_list args;
    va_start(args, function);
    [self log:format level:level file:file line:line function:function args:args];
    va_end(args);
}

- (void)log:(NSString *)format 
      level:(NSInteger)level 
       file:(const char *)file
       line:(NSInteger)line
   function:(const char *)function
       args:(va_list)args
{

    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    NSString *metaMsg = [[NSString alloc] initWithFormat:@"%@\t(%s:%d) %s", msg, file, line, function];
    
    dispatch_async(logQueue, ^ {
        if (asl_log(aslClient, aslMsg, level, "%s", [metaMsg UTF8String]))
        {
            // Log failed, try using NSLog to log message instead.
            NSLog(@"%@", metaMsg);
        }
    });
    
    [msg release];
    [metaMsg release];
}

- (void) logDebug:(NSString*)format
             file:(const char *)file
             line:(NSInteger)line
         function:(const char *)function, ...
{
    va_list args;
    va_start(args, function);
    [self logDebug:format file:file line:line function:function args:args];
    va_end(args);
}

- (void) logDebug:(NSString*)format
             file:(const char *)file
             line:(NSInteger)line
         function:(const char *)function
             args:(va_list)args
{
    [self log:format level:ASL_LEVEL_DEBUG file:file line:line function:function args:args];
}

- (void) logInfo:(NSString*)format
            file:(const char *)file
            line:(NSInteger)line
        function:(const char *)function, ...
{
    va_list args;
    va_start(args, function);
    [self logInfo:format file:file line:line function:function args:args];
    va_end(args);
}

- (void) logInfo:(NSString*)format
            file:(const char *)file
            line:(NSInteger)line
        function:(const char *)function
            args:(va_list)args
{
    [self log:format level:ASL_LEVEL_INFO file:file line:line function:function args:args];
}

- (void) logNotice:(NSString*)format
              file:(const char *)file
              line:(NSInteger)line
          function:(const char *)function, ...
{
    va_list args;
    va_start(args, function);
    [self logNotice:format file:file line:line function:function args:args];
    va_end(args);
}

- (void) logNotice:(NSString*)format
              file:(const char *)file
              line:(NSInteger)line
          function:(const char *)function
              args:(va_list)args
{
    [self log:format level:ASL_LEVEL_NOTICE file:file line:line function:function args:args];
}

- (void) logWarning:(NSString*)format
               file:(const char *)file
               line:(NSInteger)line
           function:(const char *)function, ...
{
    va_list args;
    va_start(args, function);
    [self logWarning:format file:file line:line function:function args:args];
    va_end(args);
}

- (void) logWarning:(NSString*)format
               file:(const char *)file
               line:(NSInteger)line
           function:(const char *)function
               args:(va_list)args
{
    [self log:format level:ASL_LEVEL_WARNING file:file line:line function:function args:args];
}

- (void) logError:(NSString*)format
             file:(const char *)file
             line:(NSInteger)line
         function:(const char *)function, ...
{
    va_list args;
    va_start(args, function);
    [self logError:format file:file line:line function:function args:args];
    va_end(args);
}

- (void) logError:(NSString*)format
             file:(const char *)file
             line:(NSInteger)line
         function:(const char *)function
             args:(va_list)args
{
    [self log:format level:ASL_LEVEL_ERR file:file line:line function:function args:args];
}

- (void) logCritical:(NSString*)format
                file:(const char *)file
                line:(NSInteger)line
            function:(const char *)function, ...
{
    va_list args;
    va_start(args, function);
    [self logCritical:format file:file line:line function:function args:args];
    va_end(args);
}

- (void) logCritical:(NSString*)format
                file:(const char *)file
                line:(NSInteger)line
            function:(const char *)function
                args:(va_list)args
{
    [self log:format level:ASL_LEVEL_CRIT file:file line:line function:function args:args];
}

- (void) logAlert:(NSString*)format
             file:(const char *)file
             line:(NSInteger)line
         function:(const char *)function, ...
{
    va_list args;
    va_start(args, function);
    [self logAlert:format file:file line:line function:function args:args];
    va_end(args);
}

- (void) logAlert:(NSString*)format
             file:(const char *)file
             line:(NSInteger)line
         function:(const char *)function
             args:(va_list)args
{
    [self log:format level:ASL_LEVEL_ALERT file:file line:line function:function args:args];
}

- (void) logEmergency:(NSString*)format
                 file:(const char *)file
                 line:(NSInteger)line
             function:(const char *)function, ...
{
    va_list args;
    va_start(args, function);
    [self logEmergency:format file:file line:line function:function args:args];
    va_end(args);
}

- (void) logEmergency:(NSString*)format
                 file:(const char *)file
                 line:(NSInteger)line
             function:(const char *)function
                 args:(va_list)args
{
    [self log:format level:ASL_LEVEL_EMERG file:file line:line function:function args:args];
}

@end
