//
//  IBAEasing.m
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

#import "IBAEasing.h"
#import "IBAMath.h"
#import <math.h>

CGFloat IBALinearEase(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    return (change * (time/duration)) + begin;
}

CGFloat IBACubicEaseIn (NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    return (change * (time /= duration) * IBA_SQUARE(time)) + begin;
}

CGFloat IBACubicEaseOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    return change * ((time = time/duration - 1.0) * IBA_SQUARE(time) + 1.0) + begin;
}

CGFloat IBACubicEaseInOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    if ((time /= duration/2.0) < 1.0) 
    {
        return (change / 2.0 * IBA_CUBE(time)) + begin;
    }
    
    return (change / 2.0f * ((time -= 2.0) * IBA_SQUARE(time) + 2.0)) + begin;
}

CGFloat IBAExpoEaseIn(NSTimeInterval t, CGFloat b, CGFloat c, NSTimeInterval d)
{
    return ( t == 0) ? b : c * pow(2, 10 * (t/d - 1)) + b;
}

CGFloat IBAExpoEaseOut(NSTimeInterval t, CGFloat b, CGFloat c, NSTimeInterval d)
{
    return (t == d) ? (b + c) : (c * (-pow(2, -10 * t/d) + 1) + b);
}

CGFloat IBAExpoEaseInOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    if (time == 0.0) 
        return begin;
    
    if (time == duration) 
        return begin + change;

    if ((time /= (duration/2.0)) < 1.0) 
        return (change/2.0f * powf(2.0f, 10.0f * (time - 1.0f))) + begin;
    
    return (change/2.0f * (-powf(2.0f, -10.0f * --time) + 2.0f)) + begin;
}

CGFloat IBASineEaseIn(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    return (-change * cosf(time/duration * (M_PI/2.0))) + change + begin;
}

CGFloat IBASineEaseOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    return (change * sinf(time/duration * (M_PI/2.0))) + begin;
}

CGFloat IBASineEaseInOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    return (-change/2.0f * (cosf(M_PI * time/duration) - 1.0)) + begin;
}

CGFloat IBAQuartEaseIn(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    return (change * (time /= duration) * IBA_CUBE(time)) + begin;
}

CGFloat IBAQuartEaseOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    return (-change * ((time = time/duration - 1) * IBA_CUBE(time) - 1.0)) + begin;
}

CGFloat IBAQuartEaseInOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    if ((time /= duration/2.0) < 1.0) 
        return (change/2.0f * IBA_QUARTIC(time)) + begin;
    
    return (-change/2.0f * ((time -= 2.0) * IBA_CUBE(time) - 2.0)) + begin;
}

CGFloat IBAQuintEaseIn(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    return (change * (time /= duration) * IBA_QUARTIC(time)) + begin;
}

CGFloat IBAQuintEaseOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    return (change * ((time = (time/duration - 1)) * IBA_QUARTIC(time) + 1)) + begin;
}

CGFloat IBAQuintEaseInOut(NSTimeInterval time, CGFloat begin, CGFloat change, NSTimeInterval duration)
{
    if ((time /= (duration/2.0)) < 1.0) 
        return (change/2.0f * IBA_QUARTIC(time) * time) + begin;
    
    return (change/2.0f * ((time -= 2.0) * IBA_QUARTIC(time) + 2.0)) + begin;
}

