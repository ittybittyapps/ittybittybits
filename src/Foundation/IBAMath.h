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

#import <math.h>

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

/*!
 \def       IBA_SQUARE
 \brief     Macro to square (raise to the 2nd power) the specified value \a x.
 */
#define IBA_SQUARE(x) ((x)*(x))

/*!
 \def       IBA_CUBE
 \brief     Macro to cube (raise to the 3rd power) the specified value \a x.
 */
#define IBA_CUBE(x) ((x)*(x)*(x))

/*!
 \def       IBA_POW4
 \brief     Macro to raise the specified \a x value to the 4th power.
 */
#define IBA_QUARTIC(x) ((x)*(x)*(x)*(x))

#import "../Foundation/IBACommon.h"

/*!
 \def       IBA_E
 \brief     The mathmatical constant e
 \details   M_E from math.h cast to CGFloat.
 */
#define IBA_E         ((CGFloat)M_E)

/*!
 \def       IBA_LOG2E
 \brief     The mathmatical constant log2(e).
 \details   M_LOG2E from math.h cast to CGFloat.
 */
#define IBA_LOG2E     ((CGFloat)M_LOG2E)

/*!
 \def       IBA_LOG10E 
 \brief     The mathmatical constant log10(e). 
 \details   M_LOG2E cast to CGFloat.
 */
#define IBA_LOG10E      ((CGFloat)M_LOG10E)

/*!
 \def       IBA_LN2 
 \brief     The mathmatical constant loge(2). 
 \details   M_LN2 cast to CGFloat.
 */
#define IBA_LN2         ((CGFloat)M_LN2)

/*!
 \def       IBA_LN10 
 \brief     The mathmatical constant loge(10). 
 \details   M_LN10 cast to CGFloat.
 */
#define IBA_LN10        ((CGFloat)M_LN10)

/*!
 \def       IBA_PI 
 \brief     The mathmatical constant pi. 
 \details   M_PI cast to CGFloat.
 */
#define IBA_PI          ((CGFloat)M_PI)

/*!
 \def       IBA_PI_2 
 \brief     The mathmatical constant pi/2. 
 \details   M_PI_2 cast to CGFloat.
 */
#define IBA_PI_2        ((CGFloat)M_PI_2)

/*!
 \def       IBA_PI_4 
 \brief     The mathmatical constant pi/4. 
 \details   M_PI_4 cast to CGFloat.
 */
#define IBA_PI_4        ((CGFloat)M_PI_4)

/*!
 \def       IBA_1_PI 
 \brief     The mathmatical constant 1/pi. 
 \details   M_1_PI cast to CGFloat.
 */
#define IBA_1_PI        ((CGFloat)M_1_PI)

/*!
 \def       IBA_2_PI 
 \brief     The mathmatical constant 2/pi. 
 \details   M_2_PI cast to CGFloat.
 */
#define IBA_2_PI        ((CGFloat)M_2_PI)

/*!
 \def       IBA_2_SQRTPI 
 \brief     The mathmatical constant 2/sqrt(pi). 
 \details   M_2_SQRTPI cast to CGFloat.
 */
#define IBA_2_SQRTPI    ((CGFloat)M_2_SQRTPI)

/*!
 \def       IBA_SQRT2 
 \brief     The mathmatical constant sqrt(2). 
 \details   M_SQRT2 cast to CGFloat.
 */
#define IBA_SQRT2       ((CGFloat)M_SQRT2)

/*!
 \def       IBA_SQRT1_2 
 \brief     The mathmatical constant 1/sqrt(2). 
 \details   M_SQRT1_2 cast to CGFloat.
 */
#define IBA_SQRT1_2     ((CGFloat)M_SQRT1_2)

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
