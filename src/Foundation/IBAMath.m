//
//  IBAMath.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 22/06/11.
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

#include "IBAMath.h"

/*!
 \brief     Clamp a value within an inclusive range.
 \details   Returns \a maxval for \a val values greater than \a maxval.  
            Returns \a minval for \a val values less than \a minval.
 */
float IBAClampFloatValue(float val, float minval, float maxval)
{  
    float minOfMax = MIN(val, maxval);
    return MAX(minOfMax, minval);
}

/*!
 \brief     Clamp a value within an inclusive range.
 \details   Returns \a maxval for \a val values greater than \a maxval.  
            Returns \a minval for \a val values less than \a minval.
 */
int32_t IBAClampIntValue(int32_t val, int32_t minval, int32_t maxval)
{  
    float minOfMax = MIN(val, maxval);
    return MAX(minOfMax, minval);
}

/*!
 \brief      Constrain a value within an inclusive lower bound and an exclusive upper bound.
 \details    i.e. in interval notation: [minval, maxval).  Values outside the range will cycle 
 back around into the range.  Eg: given a minval 0, maxval 10 and val 15 will result in 5 being returned.
 */
float IBAConstrainFloatValue(float val, float minval, float maxval)
{   
    double x = val;
    double lo = minval;
    double hi = maxval;
    
    double t = (x-lo) / (hi-lo);
    return (float) (lo + (hi-lo) * (t-floor(t)));
}

/*!
 \brief      Constrain a value within an inclusive lower bound and an exclusive upper bound.
 \details    i.e. in interval notation: [minval, maxval).  Values outside the range will cycle 
 back around into the range.  Eg: given a minval 0, maxval 10 and val 15 will result in 5 being returned.
 */
int32_t IBAConstrainIntValue(int32_t val, int32_t minval, int32_t maxval)
{  
    // TODO: create a integer way of doing this rather than using floating point.
    return (int32_t) IBAConstrainFloatValue(val, minval, maxval);
}
