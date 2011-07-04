//
//  NSDate+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 1/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSDate+IBAExtensions.h"


@implementation NSDate (IBAExtensions)

- (NSInteger)ibaNumberOfDaysUntil:(NSDate *)date 
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit 
                                                        fromDate:self 
                                                          toDate:date
                                                         options:0];
    
    return [components day];
}

@end
