//
//  IBADebug.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 4/05/11.
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

#import "IBADebug.h"
#import "IBALogger.h"

/////////////////////////////////////////////////////////////////////////////////////////////////
void DLogImpl(const char* functionName, const char* filename, int line, NSString* format, ...)
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    NSString* logFormat = [[[NSString stringWithCString:functionName encoding:NSUTF8StringEncoding] stringByAppendingString: @" "] stringByAppendingString:format];
    
    va_list args;
    va_start(args, format);
    [[IBALogger sharedLogger] logDebug:logFormat file:filename line:line function:functionName args:args];
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
        
//        NSString* description = [[NSString alloc] initWithFormat:format arguments:args];
        
        [[NSAssertionHandler currentHandler] handleFailureInFunction:function
                                                                file:file
                                                          lineNumber:line
                                                         description:format, args];
//        [description release];
    }
    else
    {
        NSString* logFormat = [[NSString alloc] initWithFormat:@"ALERT: %@", format];
        [[IBALogger sharedLogger] logNotice:logFormat file:filename line:line function:functionName args:args];
        [logFormat release];
    }
    
    va_end(args);
    [pool drain];
}
