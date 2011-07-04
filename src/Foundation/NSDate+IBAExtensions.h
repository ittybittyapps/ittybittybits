//
//  NSDate+IBAExtensions.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 1/07/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 \def       IBANSTimeIntervalForMinutes
 \brief     Returns the NSTimeInterval value for the specified number of \a minutes.
 \param     minutes     The number of minutes to return a time interval for.
 */
#define IBANSTimeIntervalForMinutes(minutes) (60.0 * (minutes))

/*!
 \def       IBANSTimeIntervalForHours
 \brief     Returns the NSTimeInterval value for the specified number of \a hours.
 \param     hours     The number of hours to return a time interval for.
 */

#define IBANSTimeIntervalForHours(hours) IBANSTimeIntervalForMinutes(60.0 * (hours))

@interface NSDate (IBAExtensions)

/*!
 \brief Return the number of days from the receiver to the specified \a date.
*/
- (NSInteger)ibaNumberOfDaysUntil:(NSDate *)date;

@end
