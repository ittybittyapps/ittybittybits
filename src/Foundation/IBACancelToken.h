//
//  IBACancelToken.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 21/10/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBACancelToken : NSObject

+ (id)token;

- (void)cancel;
- (BOOL)cancelled;
- (BOOL)notCancelled;

@end
