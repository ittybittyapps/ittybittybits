//
//  NSExpressionDescription+IBAExtensions.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSExpressionDescription (IBAExtensions)

+ (NSExpressionDescription *)expressionForFunction:(NSString *)function 
                                       onAttribute:(NSString *)attribute 
                                          ofEntity:(NSEntityDescription*)entity
                                            asName:(NSString*)name;

@end
