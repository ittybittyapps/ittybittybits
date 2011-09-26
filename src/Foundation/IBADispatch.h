//
//  IBADispatch.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 26/09/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#ifndef IttyBittyBits_IBADispatch_h
#define IttyBittyBits_IBADispatch_h

/*!
 \brief     Helper Macro to dispatch blocks asynchronously to the application's main event loop queue.
 \param     block       The block to dispatch.
 */
#define iba_dispatch_to_main_queue(block) dispatch_async(dispatch_get_main_queue(), (block))

#endif
