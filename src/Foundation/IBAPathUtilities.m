//
//  IBAPathUtilities.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 14/08/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "IBAPathUtilities.h"

/*!
 \brief     Returns the current application's Caches directory.
 */
NSString *IBAApplicationCachesDirectory(void)
{
    NSString *path = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    if ([paths count])
    {
        NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
    }
    
    return path;
}
