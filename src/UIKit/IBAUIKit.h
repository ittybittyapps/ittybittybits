//
//  IBAUIKit.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 12/05/11.
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

#import "IBAActionSheet.h"
#import "IBAGradientButton.h"
#import "IBATableViewAccessory.h"

// Extension categories.
#import "UIAlertView+IBAExtensions.h"
#import "UIBarButtonItem+IBAFactories.h"
#import "UIColor+IBAExtensions.h"
#import "UINib+IBAExtensions.h"
#import "UISearchBar+IBAExtensions.h"
#import "UIScrollView+IBAExtensions.h"
#import "UIView+IBAExtensions.h"


IBA_EXTERN_C_BEGIN

CGRect IBACGRectForApplicationOrientation(CGRect rect);

IBA_EXTERN_C_END
