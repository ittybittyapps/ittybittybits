//
//  IBADebug.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 27/04/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IBAAssertNotNil(x) \
    NSAssert1((x) != nil, @"%@ can not be nil", @#x)

#define IBAAssertNotNilOrEmptyString(x) \
    NSAssert1((((x) != nil) && (![(x) isEqualToString: @""])), @"%@ can not be nil or empty", @#x)

#ifndef NDEBUG
    #define DLog(...) NSLog(@"DEBUG: %s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
    #define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
    #define DLog(...) do { } while (0)
    #define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif