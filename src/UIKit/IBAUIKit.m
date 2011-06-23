//
//  IBAUIKit.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 23/06/11.
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

#include "IBAUIKit.h"

/*!
 \brief     Converts the specified \a rect to match the application's current orientation.
 \param     rect    The CGRect to convert.
 \return    The converted CGRect.
 */
CGRect IBACGRectForApplicationOrientation(CGRect rect)
{
	if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) 
    {
		return rect;
	}
	
	return CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
}