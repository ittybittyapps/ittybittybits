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
 \def       IBA_INLINE
 \brief     A macro for marking C functions as inline.
 */
#define IBA_INLINE CF_INLINE

/*!
 \brief     Release and nil the passed variable.
 \param     The variables to release and nil.
 */
#define IBA_RELEASE(...) IBA_CAT(_IBA_RELEASE_, IBA_N_ARGS(__VA_ARGS__))(__VA_ARGS__)
#define _IBA_RELEASE_H(a) [(a) release]; (a) = nil
#define _IBA_RELEASE_1(a) _IBA_RELEASE_H(a)
#define _IBA_RELEASE_2(a, b) _IBA_RELEASE_H(a); _IBA_RELEASE_H(b)
#define _IBA_RELEASE_3(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_2(__VA_ARGS__)
#define _IBA_RELEASE_4(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_3(__VA_ARGS__)
#define _IBA_RELEASE_5(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_4(__VA_ARGS__)
#define _IBA_RELEASE_6(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_5(__VA_ARGS__)
#define _IBA_RELEASE_7(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_6(__VA_ARGS__)
#define _IBA_RELEASE_8(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_7(__VA_ARGS__)
#define _IBA_RELEASE_9(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_8(__VA_ARGS__)
#define _IBA_RELEASE_10(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_9(__VA_ARGS__)
#define _IBA_RELEASE_11(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_10(__VA_ARGS__)
#define _IBA_RELEASE_12(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_11(__VA_ARGS__)
#define _IBA_RELEASE_13(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_12(__VA_ARGS__)
#define _IBA_RELEASE_14(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_13(__VA_ARGS__)
#define _IBA_RELEASE_15(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_14(__VA_ARGS__)
#define _IBA_RELEASE_16(a, ...) _IBA_RELEASE_H(a); _IBA_RELEASE_15(__VA_ARGS__)

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
 \sa        IBA_PIVAR
 */
#define IBA_PROPERTY_IVAR(name) IBA_CAT(name, _)

/*!
 \def       IBA_PIVAR
 \brief     Alias for IBA_PROPERTY_IVAR
 */
#define IBA_PIVAR(name) IBA_PROPERTY_IVAR(name)

#define IBA_PROPERTY(policy, ...) IBA_CAT(_IBA_PROPERTY_, IBA_N_ARGS(__VA_ARGS__))(policy, __VA_ARGS__)

#define IBA_PROPERTY_STRONG(...) IBA_PROPERTY(retain, __VA_ARGS__)
#define IBA_PROPERTY_WEAK(...) IBA_PROPERTY(assign, __VA_ARGS__)

#define _IBA_PROPERTY_H(policy, a) @property(nonatomic, policy) a
#define _IBA_PROPERTY_1(policy, a) _IBA_PROPERTY_H(policy, a)
#define _IBA_PROPERTY_2(policy, a, b) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_H(policy, b)
#define _IBA_PROPERTY_3(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_2(policy, __VA_ARGS__)
#define _IBA_PROPERTY_4(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_3(policy, __VA_ARGS__)
#define _IBA_PROPERTY_5(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_4(policy, __VA_ARGS__)
#define _IBA_PROPERTY_6(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_5(policy, __VA_ARGS__)
#define _IBA_PROPERTY_7(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_6(policy, __VA_ARGS__)
#define _IBA_PROPERTY_8(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_7(policy, __VA_ARGS__)
#define _IBA_PROPERTY_9(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_8(policy, __VA_ARGS__)
#define _IBA_PROPERTY_10(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_9(policy, __VA_ARGS__)
#define _IBA_PROPERTY_11(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_10(policy, __VA_ARGS__)
#define _IBA_PROPERTY_12(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_11(policy, __VA_ARGS__)
#define _IBA_PROPERTY_13(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_12(policy, __VA_ARGS__)
#define _IBA_PROPERTY_14(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_13(policy, __VA_ARGS__)
#define _IBA_PROPERTY_15(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_14(policy, __VA_ARGS__)
#define _IBA_PROPERTY_16(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_15(policy, __VA_ARGS__)
#define _IBA_PROPERTY_17(policy, a, ...) _IBA_PROPERTY_H(policy, a); _IBA_PROPERTY_16(policy, __VA_ARGS__)

/*!
 \brief     Release an nil the instance variable behind a property.
 \details   Useful for releasing ivars backing readonly properties.
 \param     The names of the properties to release.
 */
#define IBA_RELEASE_PROPERTY(...) IBA_CAT(_IBA_RELEASE_PROPERTY_, IBA_N_ARGS(__VA_ARGS__))(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_H(a) IBA_RELEASE(IBA_PROPERTY_IVAR(a))
#define _IBA_RELEASE_PROPERTY_1(a) _IBA_RELEASE_PROPERTY_H(a)
#define _IBA_RELEASE_PROPERTY_2(a, b) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_H(b)
#define _IBA_RELEASE_PROPERTY_3(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_2(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_4(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_3(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_5(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_4(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_6(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_5(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_7(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_6(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_8(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_7(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_9(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_8(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_10(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_9(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_11(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_10(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_12(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_11(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_13(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_12(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_14(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_13(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_15(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_14(__VA_ARGS__)
#define _IBA_RELEASE_PROPERTY_16(a, ...) _IBA_RELEASE_PROPERTY_H(a); _IBA_RELEASE_PROPERTY_15(__VA_ARGS__)

/*!
 \brief     Macro that retains a new property value in a setter while releasing the old property value.
 */
#define IBA_RETAIN_PROPERTY(propertyName, newValue) \
    do { \
        __typeof__(newValue) __A = (newValue); \
        if (IBA_PROPERTY_IVAR(propertyName) != __A) \
        { \
            [__A retain]; \
            IBA_RELEASE_PROPERTY(propertyName); \
            IBA_PROPERTY_IVAR(propertyName) = __A; \
        } \
    } while(0)

/*!
 \brief     Macro that retains a new property value in a setter while releasing the old property value.  Change notifications willChangeValueForKey: and didChangeValueForKey: for the property are also called before and after the value changes.
 */
#define IBA_RETAIN_PROPERTY_WITH_CHANGE_NOTIFICATION(propertyName, newValue) \
    do { \
        __typeof__(newValue) __A = (newValue); \
        if (IBA_PROPERTY_IVAR(propertyName) != __A) \
        { \
            [self willChangeValueForKey:@#propertyName]; \
            [__A retain]; \
            IBA_RELEASE_PROPERTY(propertyName); \
            IBA_PROPERTY_IVAR(propertyName) = __A; \
            [self didChangeValueForKey:@#propertyName]; \
        } \
    } while(0)

/*!
 \brief     Macro that assigns a new property value.  Change notifications willChangeValueForKey: and didChangeValueForKey: for the property are also called before and after the value changes.
 */
#define IBA_ASSIGN_PROPERTY_WITH_CHANGE_NOTIFICATION(propertyName, newValue) \
    do { \
        __typeof__(newValue) __A = (newValue); \
        if (IBA_PROPERTY_IVAR(propertyName) != __A) \
        { \
            [self willChangeValueForKey:@#propertyName]; \
            IBA_PROPERTY_IVAR(propertyName) = __A; \
            [self didChangeValueForKey:@#propertyName]; \
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
#       define IBA_EXTERN extern "C" __attribute__((visibility ("default")))
#       define IBA_EXTERN_C_BEGIN extern "C" {
#       define IBA_EXTERN_C_END }
#   else
#       define IBA_EXTERN extern __attribute__((visibility ("default")))
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
 \def       IBA_NONNULL
 \brief     Macro that specifies that the parameters of a method of function should not be null.  
 \details   The compiler will warn if a nil or NULL is passed to the function for the specified parameters.  The parameters are specified as a numeric list.  eg, IBA_NONNULL(1, 2) specifies that the 1st and 2nd parameters to the method/function should not be null.  
 
 \note      LLVM's static analyser does more thorough checking for non-nullness than the compiler does by default.
 */

#if __has_attribute(nonnull)
#   define IBA_NONNULL(...) __attribute__((nonnull(__VA_ARGS__)))
#else
#   define IBA_NONNULL(...)
#endif

/*!
 \def       IBA_PURE
 \brief     Macro for marking functions as "pure".
 
 \details   Many functions have no effects except the return value and their return value depends only on the parameters and/or global variables. Such a function can be subject to common subexpression elimination and loop optimization just as an arithmetic operator would be. These functions should be declared with the attribute pure.
 
 For example,
 \code
 int square (int) IBA_PURE;
 \endcode
 
 says that the hypothetical function square is safe to call fewer times than the program says.
 
 Some of common examples of pure functions are strlen or memcmp. Interesting non-pure functions are functions with infinite loops or those depending on volatile memory or other system resource, that may change between two consecutive calls (such as feof in a multithreading environment).
 */
#if __has_attribute(pure)
#   define IBA_PURE __attribute__((pure))
#else
#   define IBA_PURE
#endif

/*!
 \def       IBA_PURECONST
 \brief     Macro for marking functions as extra pure (i.e., using __attribute__((const)).

 \details
 Many functions do not examine any values except their arguments, and have no effects except the return value. Basically this is just slightly more strict class than the IBA_PURE attribute, since function is not allowed to read global memory.
 
 Note that a function that has pointer arguments and examines the data pointed to must not be declared IBA_PURECONST. Likewise, a function that calls a non-IBA_PURECONST function usually must not be IBA_PURECONST. It does not make sense for a IBA_PURECONST function to return void.
 */
#ifdef __pure2
#   define IBA_PURECONST __pure2
#else
#   define IBA_PURECONST
#endif

#if __has_attribute(unused)
#   define IBA_UNUSED __attribute__((unused))
#else
#   define IBA_UNUSED
#endif

/*!
 \def       IBA_HAS_FLAG
 \brief     Tests the specified \a flags value to determine whether the specified \a flag is set.
 \param     flags       The flags variable to test.
 \param     flag        The flag to test for.
 */
#define IBA_HAS_FLAG(flags, flag) (((flags) & (flag)) != 0)

/*!
 \def       IBA_ADD_FLAG
 \brief     Adds a \flag to an existing set of \a flags and returns the new combined value.
 */
#define IBA_ADD_FLAG(flags, flag) ((flags) | (flag))

/*!
 \def       IBA_ADD_FLAG
 \brief     Removes a \flag from an existing set of \a flags and returns the new value.
 */
#define IBA_DEL_FLAG(flags, flag) ((flags) & (~((unsigned)flag)))

/*!
 \def       IBA_SET_FLAG
 \brief     Sets or unsets a \flag from an existing set of \a flags and returns the new value.
 \param     set     If true then sets the flag in the flagset; otherwise unsets the flag.
 */
#define IBA_SET_FLAG(flags, flag, set) ((set) ? IBA_ADD_FLAG((flags), (flag)) : IBA_DEL_FLAG((flags), (flag)))


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

/*!
 \def       IBALocalizedString
 \brief     Returns a localized version of a string.
 \details   This is just a helper macro that simplfies using NSLocalizedString a little.
 \sa        NSLocalizedString
 */
#define IBALocalizedString(x) NSLocalizedString((x), @"")

/*!
 \def       IBA_RUN_BLOCK
 \brief     Macro to safely invoke a block.
 \param     block   The block to invoke.
 */
#define IBA_RUN_BLOCK(block, ...) if (block) { (block)(__VA_ARGS__); }

/*!
 \def       IBA_SET_NSERROR
 \brief     Macro to safely set an NSError out param.
 \param     errorOut    The NSError out parameter.
 \param     error       The error to assign to \a errorOut.
 */
#define     IBA_SET_NSERROR(errorOutParam, error) if (errorOut) { *(errorOut) = error; }

/*!
 \def       IBA_BLOCK_WEAK
 \brief     Helper macro for platform compatibility and weak block pointers.
*/
#if defined(__IPHONE_5_0) && __has_feature(objc_arc) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0)
#   define IBA_BLOCK_WEAK __block __weak 
#elif defined(__IPHONE_5_0) && defined(__IPHONE_4_3) && __has_feature(objc_arc) && (__IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_5_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_3)
#	define IBA_BLOCK_WEAK __block __unsafe_unretained
#else
#	define IBA_BLOCK_WEAK __block
#endif

/*!
 \def       IBA_ARRAYCOUNT
 \brief     Returns the count of elements in an array.
 \param     array   The array for which to get the count of elements.
 */
#define IBA_ARRAYCOUNT(array) ((sizeof(array)/sizeof(0[array])) / ((size_t)(!(sizeof(array) % sizeof(0[array])))))

#ifdef __cplusplus
    /*!
     \brief     Returns a value indicating whether the specified \a array contains the specified \a value.
     \param     array   The array to test.
     \param     value   The value to look for.
     \retruns   YES if the \a value is contained in the \a array.
     */
    template<typename T, size_t N>
    BOOL IBAArrayContains(T (&array)[N], const T value)
    {
        for (size_t i = 0; i < IBA_ARRAYCOUNT(array); ++i) 
        {
            if (array[i] == value) return YES;
        }
        
        return NO;
    }
#endif

/*!
 \brief     A generic action block.
 */
typedef void (^IBAAction)(void);


/*!
 \def       IBA_SIZE_IS_WITHIN
 \brief     Tests whether the height and width of size1 are both smaller than the height and width of size2.
 \param     size1       The flags variable to test.
 \param     size2       The flag to test for.
 */
#define IBA_SIZE_IS_WITHIN(size1, size2) ((size1.width <= size2.width) && (size1.height <= size2.height))

/*!
 \brief     Safely compare an NSInteger to an NSUInteger.
 \details   Returns YES if the specified value \a i is less than the specifief value \a ui; otherwise NO.
 
 */
IBA_INLINE BOOL IBANSIntegerLessThanNSUInteger(NSInteger i, NSUInteger ui)
{
    return (i < 0) ? YES : (((NSUInteger)i) < ui);
}
