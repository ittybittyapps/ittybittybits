//
//  IBAEasing.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 1/09/11.
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
//
//  Portions Copyright © 2001 Robert Penner
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, 
//  are permitted provided that the following conditions are met:
// 
//   1. Redistributions of source code must retain the above copyright notice,
//      this list of conditions and the following disclaimer.
//   2. Redistributions in binary form must reproduce the above copyright notice, 
//      this list of conditions and the following disclaimer in the documentation 
//      and/or other materials provided with the distribution.
//   3. Neither the name of the author nor the names of contributors may be used 
//      to endorse or promote products derived from this software without specific 
//      prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "IBACommon.h"

/*!
 \brief     A function pointer type for easing/interpolation functions.
 \param     time    The current elapsed time (should be in the range of [0.0, duration])
 \param     begin   The starting/beginning value.
 \param     change  The change in value for the \a duration (at end of duration the returned value should equal begin+change).
 \return    The interpolated value.
 */
typedef CGFloat (*IBAEasingFunction)(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration);

IBA_EXTERN_C_BEGIN

CGFloat IBALinearEase(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;

CGFloat IBACubicEaseIn(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;
CGFloat IBACubicEaseOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;
CGFloat IBACubicEaseInOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;

CGFloat IBAExpoEaseIn(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;
CGFloat IBAExpoEaseOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;
CGFloat IBAExpoEaseInOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;

CGFloat IBASineEaseIn(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;
CGFloat IBASineEaseOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;
CGFloat IBASineEaseInOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;

CGFloat IBAQuartEaseIn(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;
CGFloat IBAQuartEaseOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;
CGFloat IBAQuartEaseInOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;

CGFloat IBAQuintEaseIn(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;
CGFloat IBAQuintEaseOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;
CGFloat IBAQuintEaseInOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration) IBA_PURECONST;

IBA_EXTERN_C_END