//
//  IBAPreProcessorMagic.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 19/05/11.
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

// concatenation
#define IBA_CAT(a, b) _IBA_PRIMITIVE_CAT(a, b)
#define _IBA_PRIMITIVE_CAT(a, b) a##b

// binary intermediate split
#define IBA_SPLIT(i, im) _IBA_PRIMITIVE_CAT(_IBA_SPLIT_, i)(im)
#define _IBA_SPLIT_0(a, b) a
#define _IBA_SPLIT_1(a, b) b

// saturating increment and decrement
#define IBA_DEC(x) IBA_SPLIT(0, _IBA_PRIMITIVE_CAT(_IBA_DEC_, x))
#define IBA_INC(x) IBA_SPLIT(1, _IBA_PRIMITIVE_CAT(_IBA_DEC_, x))

#define _IBA_DEC_0 0, 1
#define _IBA_DEC_1 0, 2
#define _IBA_DEC_2 1, 3
#define _IBA_DEC_3 2, 4
#define _IBA_DEC_4 3, 5
#define _IBA_DEC_5 4, 6
#define _IBA_DEC_6 5, 7
#define _IBA_DEC_7 6, 8
#define _IBA_DEC_8 7, 9
#define _IBA_DEC_9 8, 9

// bit complement
#define IBA_COMPL(bit) _IBA_PRIMITIVE_CAT(_IBA_COMPL_, bit)
#define _IBA_COMPL_0 1
#define _IBA_COMPL_1 0

// nullary parentheses detection
#define IBA_IS_NULLARY(x) IBA_SPLIT(0, IBA_CAT(IS_NULLARY_R_, IS_NULLARY_C x))
#define IS_NULLARY_C() 1
#define IS_NULLARY_R_1 1, ~
#define IS_NULLARY_R_IS_NULLARY_C 0, ~

// boolean conversion
#define IBA_BOOL(x) IBA_COMPL(IBA_IS_NULLARY(_IBA_PRIMITIVE_CAT(_IBA_BOOL_, x)))
#define _IBA_BOOL_0 ()

// recursion backend
#define IBA_EXPR(s) _IBA_PRIMITIVE_CAT(_IBA_EXPR_, s)
#define _IBA_EXPR_0(x) x
#define _IBA_EXPR_1(x) x
#define _IBA_EXPR_2(x) x
#define _IBA_EXPR_3(x) x
#define _IBA_EXPR_4(x) x
#define _IBA_EXPR_5(x) x
#define _IBA_EXPR_6(x) x
#define _IBA_EXPR_7(x) x
#define _IBA_EXPR_8(x) x
#define _IBA_EXPR_9(x) x

// bit-oriented if control structure
#define IBA_IIF(bit) _IBA_PRIMITIVE_CAT(_IBA_IIF_, bit)
#define _IBA_IIF_0(t, f) f
#define _IBA_IIF_1(t, f) t

// number-oriented if control structure
#define IBA_IF(cond) IBA_IIF(IBA_BOOL(cond))

// emptiness abstraction
#define IBA_EMPTY()

// 1x and 2x deferral macros
#define IBA_DEFER(macro) macro IBA_EMPTY()
#define IBA_OBSTRUCT() IBA_DEFER(IBA_EMPTY)()

// argument list eater
#define IBA_EAT(size) _IBA_PRIMITIVE_CAT(_IBA_EAT_, size)
#define _IBA_EAT_0()
#define _IBA_EAT_1(a)
#define _IBA_EAT_2(a, b)
#define _IBA_EAT_3(a, b, c)
#define _IBA_EAT_4(a, b, c, d)
#define _IBA_EAT_5(a, b, c, d, e)
#define _IBA_EAT_6(a, b, c, d, e, f)
#define _IBA_EAT_7(a, b, c, d, e, f, g)
#define _IBA_EAT_8(a, b, c, d, e, f, g, h)
#define _IBA_EAT_9(a, b, c, d, e, f, g, h, i)
#define _IBA_EAT_10(a, b, c, d, e, f, g, h, i, j)
#define _IBA_EAT_11(a, b, c, d, e, f, g, h, i, j, k)
#define _IBA_EAT_12(a, b, c, d, e, f, g, h, i, j, k, l)
#define _IBA_EAT_13(a, b, c, d, e, f, g, h, i, j, k, l, m)
#define _IBA_EAT_14(a, b, c, d, e, f, g, h, i, j, k, l, m, n)
#define _IBA_EAT_15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
#define _IBA_EAT_16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)

/*!
 \def       IBA_N_ARGS
 \brief     Macro that can tell how many variable arguments have been passed to it (up to a total of 16).
 */
#define IBA_N_ARGS(...) IBA_N_ARGS_1(__VA_ARGS__, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
#define IBA_N_ARGS_1(...) IBA_N_ARGS_2(__VA_ARGS__)
#define IBA_N_ARGS_2(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, n, ...) n

// comma abstractions
#define IBA_COMMA() ,
#define IBA_COMMA_IF(n) IBA_IF(n)(IBA_COMMA, IBA_EMPTY)()

// repetition construct
#define IBA_REPEAT(s, count, macro, data) \
    IBA_EXPR(s)(_IBA_REPEAT_I(IBA_INC(s), IBA_INC(s), count, macro, data)) \
    /**/

#define _IBA_REPEAT_INDIRECT() _IBA_REPEAT_I
#define _IBA_REPEAT_I(s, o, count, macro, data) \
    IBA_IF(count)(REPEAT_II, IBA_EAT(6))(IBA_OBSTRUCT(), s, o, IBA_DEC(count), macro, data) \
    /**/

#define REPEAT_II(_, s, o, count, macro, data) \
    IBA_EXPR(s) _(_IBA_REPEAT_INDIRECT _()( \
        IBA_INC(s), o, count, macro, data \
    )) \
    IBA_EXPR IBA_OBSTRUCT()(o)(macro IBA_OBSTRUCT()(o, count, data)) \
    /**/
