//
//  NSEntityDescription+IBAExtensions.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSEntityDescription (IBAExtensions)

- (NSAttributeDescription*) ibaAttributeByName:(NSString *)name;

@end
