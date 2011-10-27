//
//  IBADispatch.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 26/09/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
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

#ifndef IttyBittyBits_IBADispatch_h
#define IttyBittyBits_IBADispatch_h

/*!
 \brief     Helper macro to dispatch blocks asynchronously to the application's main event loop queue.
 \param     block       The block to dispatch.
 */
#define iba_dispatch_to_main_queue(block) dispatch_async(dispatch_get_main_queue(), (block))

/*!
 \brief     Helper macro to dispatch blocks asynchronously to the application's global queue with default priority.
 \param     block       The block to dispatch.
 */
#define iba_dispatch_to_default_queue(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), (block))

#endif
