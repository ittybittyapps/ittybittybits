//
//  IBAErrors.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 12/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

typedef void (^IBAErrorHandler)(NSError *error);


/*!
 \def       IBASetError
 \brief     Helper macro to set an pointer to a NSError.
 \details   Ensures that the pointer references a valid NSError pointer before assigning to it.
 */
#define IBASetOutError(error, value) do { if (error) { (*(error)) = (value); } } while(0)