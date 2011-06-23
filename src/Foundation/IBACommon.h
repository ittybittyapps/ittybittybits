//
//  IBACommon.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 4/05/11.
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

#include "IBAPreProcessorMagic.h"

// Ensure compatibility with other non-clang compilers
#ifndef __has_attribute             
#   define __has_attribute(x) 0
#endif

#ifndef __has_extension             
#   define __has_extension(x) 0
#endif


/*!
 \brief     Release and nil the passed variable.
 \param     x   The instance to release.
 */
#define IBA_RELEASE(x) \
    [(x) release]; (x) = nil

/*!
 \brief     Free and NULL the passed pointer variable.
 \param     p   The pointer to free.
 */
#define IBA_FREE(p) { if(p) { free(p); (p) = NULL; } }

/*!
 \brief     Releae and nil a Core Foundation reference.
 \param     ref The reference to release.
 */
#define IBA_CFRELEASE(ref) { if (ref) { CFRelease(ref); (ref) = nil; } }

/*!
 \def       IBA_PROPERTY_IVAR
 \brief     Returns gets the ivar name of a property with the specified \a name.
 \param     name        The name of the property.
 \return    The ivar name.
 */
#define IBA_PROPERTY_IVAR(name) IBA_CAT(name, _)

/*!
 \brief     Release an nil the instance variable behind a property.
 \details   Useful for releasing ivars backing readonly properties.
 \param     propertyName        The name of the property to release.
 */
#define IBA_RELEASE_PROPERTY(propertyName) \
    IBA_RELEASE(IBA_PROPERTY_IVAR(propertyName));

/*!
 \brief     Macro that retains a new property value in a setter while releasing the old property value.
 */
#define IBA_RETAIN_PROPERTY(propertyName, newValue) \
    do { \
        if (IBA_PROPERTY_IVAR(propertyName) != newValue) \
        { \
            [newValue retain]; \
            IBA_RELEASE_PROPERTY(propertyName); \
            IBA_PROPERTY_IVAR(propertyName) = newValue; \
        } \
    } while(0)

/*! 
 \def       IBA_FORMAT_FUNCTION
 \brief     An alias for NS_FORMAT_FUNCTION
 */

/*!
 \def       IBA_FORMAT_ARGUMENT
 \brief     An alias for NS_FORMAT_ARGUMENT
*/

// Perhaps one day this macro will actually do something in Clang.

#ifdef NS_FORMAT_FUNCTION
#   define IBA_FORMAT_FUNCTION(F, A) NS_FORMAT_FUNCTION(F, A)
#else
#   define IBA_FORMAT_FUNCTION(F, A)
#endif

#ifdef NS_FORMAT_ARGUMENT
#   define IBA_FORMAT_ARGUMENT(F, A) NS_FORMAT_ARGUMENT(F)
#else
#   define IBA_FORMAT_ARGUMENT(F, A)
#endif

/*!
 \def   IBA_DEPRECATED
 \brief     Macro to mark a method, function or variable as deprecated.
 \details   This is useful when identifying things that are expected to be removed in a future version. 
 */
#if __has_attribute(deprecated)
#   if __has_extension(attribute_deprecated_with_message)
#       define IBA_DEPRECATED(msg) __attribute__((deprecated(msg)))
#   else
#       define IBA_DEPRECATED(msg) __attribute__((deprecated))
#   endif
#else
#   define  IBA_DEPRECATED(msg)
#endif

// Give ourselves a consistent way of doing externs that links up nicely
// when mixing objc and objc++
#ifndef IBA_EXTERN
#   ifdef __cplusplus
#       define IBA_EXTERN extern "C"
#       define IBA_EXTERN_C_BEGIN extern "C" {
#       define IBA_EXTERN_C_END }
#   else
#       define IBA_EXTERN extern
#       define IBA_EXTERN_C_BEGIN
#       define IBA_EXTERN_C_END
#   endif
#endif

/*!
 \def       IBA_SYNTHESIZE
 \brief     Helper macro for specifying synthesized properties.
 */
#define IBA_SYNTHESIZE(...) @synthesize IBA_CAT(_IBA_SYNTHESIZE_, IBA_N_ARGS(__VA_ARGS__))(__VA_ARGS__)
#define _IBA_SYNTHESIZE_H(x) x=IBA_PROPERTY_IVAR(x)
#define _IBA_SYNTHESIZE_1(a) _IBA_SYNTHESIZE_H(a)
#define _IBA_SYNTHESIZE_2(a, b) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_H(b)
#define _IBA_SYNTHESIZE_3(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_2(__VA_ARGS__)
#define _IBA_SYNTHESIZE_4(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_3(__VA_ARGS__)
#define _IBA_SYNTHESIZE_5(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_4(__VA_ARGS__)
#define _IBA_SYNTHESIZE_6(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_5(__VA_ARGS__)
#define _IBA_SYNTHESIZE_7(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_6(__VA_ARGS__)
#define _IBA_SYNTHESIZE_8(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_7(__VA_ARGS__)
#define _IBA_SYNTHESIZE_9(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_8(__VA_ARGS__)
#define _IBA_SYNTHESIZE_10(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_9(__VA_ARGS__)
#define _IBA_SYNTHESIZE_11(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_10(__VA_ARGS__)
#define _IBA_SYNTHESIZE_12(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_11(__VA_ARGS__)
#define _IBA_SYNTHESIZE_13(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_12(__VA_ARGS__)
#define _IBA_SYNTHESIZE_14(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_13(__VA_ARGS__)
#define _IBA_SYNTHESIZE_15(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_14(__VA_ARGS__)
#define _IBA_SYNTHESIZE_16(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_15(__VA_ARGS__)
#define _IBA_SYNTHESIZE_17(a, ...) _IBA_SYNTHESIZE_H(a), _IBA_SYNTHESIZE_16(__VA_ARGS__)

/*!
 \def       IBA_NSDICTIONARY
 \brief     Helper macro for creating an NSDictionary instance with a series of objects and keys.
 \details   Usage example:
 \code      NSDictionary *d = IBA_NSDICTIONARY(object, key, object, key);
 \endcode
 \sa        NSDictionary#dictionaryWithObjectsAndKeys
 */
#define IBA_NSDICTIONARY(...) [NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__, nil]

/*!
 \def       IBA_NSARRAY
 \brief     Helper macro for creating inline NSArray instances with a series of objects.
 */
#define IBA_NSARRAY(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]

/*!
 \def       IBA_NSARRAY
 \brief     Helper macro for creating inline NSMutableArray instances with a series of objects.
 */
#define IBA_NSMUTABLEARRAY(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]

#define IBAFloatToNumber(x) [NSNumber numberWithFloat:(x)]
#define IBADoubleToNumber(x) [NSNumber numberWithDouble:(x)]
#define IBAIntToNumber(x) [NSNumber numberWithInt:(x)]
#define IBAUIntToNumber(x) [NSNumber numberWithUnsignedInt:(x)]
#define IBALongToNumber(x) [NSNumber numberWithLong:(x)]
#define IBAULongToNumber(x) [NSNumber numberWithUnsignedLong:(x)]
#define IBALongLongToNumber(x) [NSNumber numberWithLongLong:(x)]
#define IBAULongLongToNumber(x) [NSNumber numberWithUnsignedLongLong:(x)]

/*!
 \def       IBALocalizedString
 \brief     Returns a localized version of a string.
 \details   This is just a helper macro that simplfies using NSLocalizedString a little.
 \sa        NSLocalizedString
 */
#define IBALocalizedString(x) NSLocalizedString((x), @"")
