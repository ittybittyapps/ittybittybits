//
//  NSDate+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 1/07/11.
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

#import "NSDate+IBAExtensions.h"


@implementation NSDate (IBAExtensions)

/*!
 \brief Return the number of days from the receiver to the specified \a date.
 */
- (NSInteger)ibaNumberOfDaysUntil:(NSDate *)date 
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit 
                                                        fromDate:self 
                                                          toDate:date
                                                         options:0];
    [gregorianCalendar release];
    
    return [components day];
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is earlier than another given date.
 \param     other The other date to compare to the receiver.
 \return    YES if the receiver is earlier than other, otherwise NO.
 */
- (BOOL)ibaIsEarlierThan:(NSDate *)other
{
    return [self compare:other] == NSOrderedAscending;
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is earlier than or equal to another given date.
 \param     other The other date to compare to the receiver.
 \return    YES if the receiver is earlier than or equal to other, otherwise NO.
 */
- (BOOL)ibaIsEarlierThanOrEqualTo:(NSDate *)other
{
    NSComparisonResult result = [self compare:other];
    return result == NSOrderedAscending || result == NSOrderedSame;
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is later than another given date.
 \param     other The other date to compare to the receiver.
 \return    YES if the receiver is later than other, otherwise NO.
 */
- (BOOL)ibaIsLaterThan:(NSDate *)other
{
    return [self compare:other] == NSOrderedDescending;
}

/*!
 \brief     Returns a Boolean value that indicates whether the receiver is later than or equal to another given date.
 \param     other The other date to compare to the receiver.
 \return    YES if the receiver is later than or equal to other, otherwise NO.
 */
- (BOOL)ibaIsLaterThanOrEqualTo:(NSDate *)other
{
    NSComparisonResult result = [self compare:other];
    return result == NSOrderedDescending || result == NSOrderedSame;
}

// Good info on internet dates here: http://developer.apple.com/iphone/library/qa/qa2010/qa1480.html

// Get a date from a string - hit (from specs) can be used to speed up
+ (NSDate *)ibaDateFromInternetDateTimeString:(NSString *)dateString formatHint:(IBADateFormatHint)hint 
{
	NSDate *date = nil;
	if (hint != IBADateFormatHintRFC3339) 
    {
		// Try RFC822 first
		date = [NSDate ibaDateFromRFC822String:dateString];
		if (!date) date = [NSDate ibaDateFromRFC3339String:dateString];
	} 
    else 
    {
		// Try RFC3339 first
		date = [NSDate ibaDateFromRFC3339String:dateString];
		if (!date) date = [NSDate ibaDateFromRFC822String:dateString];
	}
    
	return date;
}

// See http://www.faqs.org/rfcs/rfc822.html
+ (NSDate *)ibaDateFromRFC822String:(NSString *)dateString 
{    
	// Create date formatter
	static NSDateFormatter *dateFormatter = nil;
	if (!dateFormatter) {
		NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setLocale:en_US_POSIX];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		[en_US_POSIX release];
	}
    
	// Process
	NSDate *date = nil;
	NSString *RFC822String = [[NSString stringWithString:dateString] uppercaseString];
	if ([RFC822String rangeOfString:@","].location != NSNotFound) {
		if (!date) { // Sun, 19 May 2002 15:21:36 GMT
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // Sun, 19 May 2002 15:21 GMT
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // Sun, 19 May 2002 15:21:36
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // Sun, 19 May 2002 15:21
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
	} else {
		if (!date) { // 19 May 2002 15:21:36 GMT
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // 19 May 2002 15:21 GMT
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // 19 May 2002 15:21:36
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // 19 May 2002 15:21
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
	}
	if (!date) NSLog(@"Could not parse RFC822 date: \"%@\" Possibly invalid format.", dateString);
	return date;
	
}

// See http://www.faqs.org/rfcs/rfc3339.html
+ (NSDate *)ibaDateFromRFC3339String:(NSString *)dateString {
	
	// Create date formatter
	static NSDateFormatter *dateFormatter = nil;
	if (!dateFormatter) {
		NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setLocale:en_US_POSIX];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		[en_US_POSIX release];
	}
	
	// Process date
	NSDate *date = nil;
	NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
	RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
	// Remove colon in timezone as iOS 4+ NSDateFormatter breaks. See https://devforums.apple.com/thread/45837
	if (RFC3339String.length > 20) {
		RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":" 
																 withString:@"" 
																	options:0
																	  range:NSMakeRange(20, RFC3339String.length-20)];
	}
	if (!date) { // 1996-12-19T16:39:57-0800
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"]; 
		date = [dateFormatter dateFromString:RFC3339String];
	}
	if (!date) { // 1937-01-01T12:00:27.87+0020
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"]; 
		date = [dateFormatter dateFromString:RFC3339String];
	}
	if (!date) { // 1937-01-01T12:00:27
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"]; 
		date = [dateFormatter dateFromString:RFC3339String];
	}
	if (!date) NSLog(@"Could not parse RFC3339 date: \"%@\" Possibly invalid format.", dateString);
	return date;
	
}

@end
