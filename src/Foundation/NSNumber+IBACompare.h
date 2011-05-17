//
//  NSNumber+IBACompare.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 13/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNumber (IBACompare)

- (BOOL) ibaLessThanInt:(int)n;
- (BOOL) ibaGreaterThanInt:(int)n;
- (BOOL) ibaEqualToInt:(int)n;

- (BOOL) ibaLessThanFloat:(float)n;
- (BOOL) ibaGreaterThanFloat:(float)n;
- (BOOL) ibaEqualToFloat:(float)n;



@end
