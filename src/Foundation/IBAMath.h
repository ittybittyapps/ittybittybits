//
//  IBAMath.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 10/05/11.
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

/*!
 \def       IBA_DEG_TO_RAD
 \brief     Macro to convert degrees to radians.
 */
#define IBA_DEG_TO_RAD(x) ((x) * (M_PI/180.0f))

/*!
 \def       IBA_RAD_TO_DEG
 \brief     Macro to convert radians to degrees.
 */
#define IBA_RAD_TO_DEG(x) ((x) * (180.0f/M_PI))

#import "../Foundation/IBACommon.h"

IBA_EXTERN_C_BEGIN

float IBAClampFloatValue(float val, float minval, float maxval);
int32_t IBAClampIntValue(int32_t val, int32_t minval, int32_t maxval);
float IBAConstrainFloatValue(float val, float minval, float maxval);
int32_t IBAConstrainIntValue(int32_t val, int32_t minval, int32_t maxval);

IBA_EXTERN_C_END

#ifdef __cplusplus

inline float IBAClamp(float val, float minval, float maxval) { return IBAClampFloatValue(val, minval, maxval); }
inline float IBAClamp(int32_t val, int32_t minval, int32_t maxval) { return IBAClampIntValue(val, minval, maxval); }
inline float IBAConstrain(float val, float minval, float maxval) { return IBAConstrainFloatValue(val, minval, maxval); }
inline int32_t IBAConstrain(int32_t val, int32_t minval, int32_t maxval) { return IBAConstrainIntValue(val, minval, maxval); }

#endif
