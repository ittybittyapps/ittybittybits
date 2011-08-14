//
//  NSFileManager+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 14/08/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSFileManager+IBAExtensions.h"

@implementation NSFileManager (IBAExtensions)


/*!
 \brief     Returns a Boolean value that indicates whether a file exists at the specified path and it is a directory.
 */
- (BOOL)ibaDirectoryExistsAtPath:(NSString *)directory
{
    BOOL isDirectory = NO;
    BOOL fileExists = [self fileExistsAtPath:directory isDirectory:&isDirectory];
    
    return fileExists && isDirectory;
}

@end
