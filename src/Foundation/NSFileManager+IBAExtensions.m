//
//  NSFileManager+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 14/08/11.
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
