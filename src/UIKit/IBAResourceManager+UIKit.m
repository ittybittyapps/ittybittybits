//
//  IBAResourceManager+UIKit.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 14/11/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
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

#import "IBAResourceManager+UIKit.h"
#import "IBAResourceBundle+UIKit.h"

#import "../Foundation/IBAResourceManager.h"
#import "../Foundation/IBAResourceManager+Internal.h"

@implementation IBAResourceManager (UIKit)

ImplResourceNamed(color, UIColor *, nil)
ImplResourceNamed(image, UIImage *, nil)
ImplResourceNamed(colorWithPattern, UIColor *, nil)
ImplResourceNamed(font, UIFont *, nil)

// For additional resource-name validation without throwing missing resource debug errors.
- (BOOL)hasResource:(NSString *)name
{
	for (IBAResourceBundle *bundle in self.bundleStack)
	{
		if ([bundle hasResourceNamed:name])
			return YES;
	}
	return NO;
}

@end
