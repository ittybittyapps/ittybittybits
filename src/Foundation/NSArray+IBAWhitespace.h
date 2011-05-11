//
//  NSArray+Whitespace.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 10/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (IBAWhitespace)

- (NSString *)ibaNonEmptyComponentsJoinedByString:(NSString *)string;

@end
