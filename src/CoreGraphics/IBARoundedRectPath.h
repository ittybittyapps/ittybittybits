//
//  IBARoundedRectPath.h
//  IttyBittyBits
//
//  Copyright 2010 Google Inc.
//  Modified by Oliver Jones on 6/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import <CoreGraphics/CoreGraphics.h>

#import "IBACommon.h"

IBA_EXTERN_C_BEGIN

/*!
 \brief     Inscribe a round rectangle inside of rectangle \a rect with a corner radius \a radius.
 \param     rect
            Iuter rectangle to inscribe into.
 \param     radius
            Radius of the corners. \a radius is clamped internally to be no larger than the smaller of half \a rect's width or height
 */
void GTMCGContextAddRoundRect(CGContextRef context, CGRect rect, CGFloat radius);

/*!
 \brief     Adds a path which is a round rectangle inscribed inside of rectangle \a rect with a corner radius of \a radius.
 \param     path
            Path to add the rounded rectangle to.
 \param     m
            Matrix modifying the round rect.
 \param     rect
            Outer rectangle to inscribe into.
 \param     radius
            Radius of the corners. \a radius is clamped internally to be no larger than the smaller of half \a rect's width or height.
 */
void GTMCGPathAddRoundRect(CGMutablePathRef path,
                           const CGAffineTransform *m,
                           CGRect rect,
                           CGFloat radius);

IBA_EXTERN_C_END
