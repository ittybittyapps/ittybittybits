//
//  IBADebug.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 4/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#include "IBADebug.h"
#include "IBALogger.h"

/////////////////////////////////////////////////////////////////////////////////////////////////
void DLogImpl(const char* functionName, NSString* format, ...)
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    NSString* logFormat = [[[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] stringByAppendingString: @" "] stringByAppendingString:format];
    
    va_list args;
    va_start(args, format);
    [[IBALogger sharedLogger] logDebug:logFormat args:args];
    va_end(args);
    
    [pool drain];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
void ALogImpl(BOOL assert, const char* functionName, const char* filename, int line, NSString* format, ...)
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    va_list args;
    va_start(args, format);
    
    if (assert)
    {
        NSString* function = [NSString stringWithCString:functionName encoding:NSUTF8StringEncoding];    
        NSString* file = [NSString stringWithCString:filename encoding:NSUTF8StringEncoding];
        
        NSString* description = [[NSString alloc] initWithFormat:format arguments:args];
        
        [[NSAssertionHandler currentHandler] handleFailureInFunction:function
                                                                file:file
                                                          lineNumber:line
                                                         description:description];    
        [description release];
    }
    else
    {
        NSString* logFormat = [[NSString stringWithFormat:@"ALERT: %s %s(%d):", functionName, filename, line] stringByAppendingString: format];
        
        [[IBALogger sharedLogger] logNotice:logFormat args:args];
    }
    
    va_end(args);
    [pool drain];
}
