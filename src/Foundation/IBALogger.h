//
//  IBADebugLog.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 3/05/11.
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

#import <Foundation/Foundation.h>
#import "IBACommon.h"

#import <asl.h>
#import <dispatch/dispatch.h>

/*!
 \brief Log a formatted message to the default logger at the specified level.

 \param lvl     The logging level. One of ASL_LEVEL_{DEBUG, INFO, NOTICE, WARNING, ERR, CRIT, ALERT, EMERG}.
 \param format  The format string (NSString).
 */
#define IBALog(lvl, format, ...) [[IBALogger sharedLogger] log:(format) level:(lvl), ##__VA_ARGS__]

/*!
 \brief Log a formatted message to the default logger at ASL_LEVEL_DEBUG.
 \param format  The format string (NSString). 
 */
#define IBALogDebug(format, ...)		IBALog(ASL_LEVEL_DEBUG, (format), ##__VA_ARGS__)

/*!
 \brief Log a formatted message to the default logger at ASL_LEVEL_INFO.
 \param format  The format string (NSString). 
 */
#define IBALogInfo(format, ...)         IBALog(ASL_LEVEL_INFO, (format), ##__VA_ARGS__)

/*!
 \brief Log a formatted message to the default logger at ASL_LEVEL_NOTICE.
 \param format  The format string (NSString). 
 */
#define IBALogNotice(format, ...)       IBALog(ASL_LEVEL_NOTICE, (format), ##__VA_ARGS__)

/*!
 \brief Log a formatted message to the default logger at ASL_LEVEL_WARNING.
 \param format  The format string (NSString). 
 */
#define IBALogWarning(format, ...)      IBALog(ASL_LEVEL_WARNING, (format), ##__VA_ARGS__)

/*!
 \brief Log a formatted message to the default logger at ASL_LEVEL_ERR.
 \param format  The format string (NSString). 
 */
#define IBALogError(format, ...)		IBALog(ASL_LEVEL_ERR, (format), ##__VA_ARGS__)

/*!
 \brief Log a formatted message to the default logger at ASL_LEVEL_CRIT.
 \param format  The format string (NSString). 
 */
#define IBALogCritical(format, ...)     IBALog(ASL_LEVEL_CRIT, (format), ##__VA_ARGS__)

/*!
 \brief Log a formatted message to the default logger at ASL_LEVEL_ALERT.
 \param format  The format string (NSString). 
 */
#define IBALogAlert(format, ...)		IBALog(ASL_LEVEL_ALERT, (format), ##__VA_ARGS__)

/*!
 \brief Log a formatted message to the default logger at ASL_LEVEL_EMERG.
 \param format  The format string (NSString). 
 */
#define IBALogEmergency(format, ...)	IBALog(ASL_LEVEL_EMERG, (format), ##__VA_ARGS__)

/*!
 \brief     A logger that writes log messages to the Apple System Logging interface.
 \details   Actual logging is performed asynchronously on the GCD low priority queue in an effort to reduce the performance impact.  This also means that the logger is thread safe and can be used from any thread or other queue.
 */
@interface IBALogger : NSObject 
{
@private
    dispatch_queue_t logQueue;
    aslmsg aslMsg;
    aslclient aslClient;
    NSMutableDictionary* additionalFiles;
}

/*!
 \brief     Returns the shared logger singleton instance.
 */
+ (IBALogger*)sharedLogger;

/*!
 \brief     The designated initaliser.  Initialises a logger with the specified facility.
 \param     name        The logger name.
 \param     facility    The logger facility name.
 */
- (id) initWithName:(NSString*)name facility:(NSString*) facility;

/*!
 \brief     The log "facility" name of the log.
 \details   The facility defaults to "com.ittybittyapps.debug".  The facility should be specified in "reverse domain name" notation.
 */
@property (nonatomic, retain) NSString* facility;

/*!
 \brief     The log name.
 \details   The name defaults to the application's bundle identifier.
 */
@property (nonatomic, readonly) NSString* name;

/*!
 \brief     Log a message with the specified level and format string.
 */
- (void) log:(NSString*)format
       level:(NSInteger)level, ... IBA_FORMAT_FUNCTION(1, 3);

/*!
 \brief     Log a message with the specified level and format string.
 */
- (void) log:(NSString*)format
       level:(NSInteger)level
        args:(va_list)args IBA_FORMAT_FUNCTION(1, 0);

/*!
 \brief     Log a debug message with the specified format.
 */
- (void) logDebug:(NSString*)format, ... IBA_FORMAT_FUNCTION(1, 2);

/*!
 \brief     Log a debug message with the specified format.
 */
- (void) logDebug:(NSString*)format args:(va_list)args IBA_FORMAT_FUNCTION(1, 0);

/*!
 \brief     Log an info message with the specified format.
 */
- (void) logInfo:(NSString*)format, ... IBA_FORMAT_FUNCTION(1, 2);

/*!
 \brief     Log an info message with the specified format.
 */
- (void) logInfo:(NSString*)format args:(va_list)args IBA_FORMAT_FUNCTION(1, 0);

/*!
 \brief     Log a notice message with the specified format.
 */
- (void) logNotice:(NSString*)format, ... IBA_FORMAT_FUNCTION(1, 2);

/*!
 \brief     Log a notice message with the specified format.
 */
- (void) logNotice:(NSString*)format args:(va_list)args IBA_FORMAT_FUNCTION(1, 0);

/*!
 \brief     Log a warning message with the specified format.
 */
- (void) logWarning:(NSString*)format, ... IBA_FORMAT_FUNCTION(1, 2);

/*!
 \brief     Log a warning message with the specified format.
 */
- (void) logWarning:(NSString*)format args:(va_list)args IBA_FORMAT_FUNCTION(1, 0);

/*!
 \brief     Log a error message with the specified format.
 */
- (void) logError:(NSString*)format, ... IBA_FORMAT_FUNCTION(1, 2);

/*!
 \brief     Log a error message with the specified format.
 */
- (void) logError:(NSString*)format args:(va_list)args IBA_FORMAT_FUNCTION(1, 0);

/*!
 \brief     Log a critical error message with the specified format.
 */
- (void) logCritical:(NSString*)format, ... IBA_FORMAT_FUNCTION(1, 2);

/*!
 \brief     Log a critical error message with the specified format.
 */
- (void) logCritical:(NSString*)format args:(va_list)args IBA_FORMAT_FUNCTION(1, 0);

/*!
 \brief     Log an alert message with the specified format.
 */
- (void) logAlert:(NSString*)format, ... IBA_FORMAT_FUNCTION(1, 2);

/*!
 \brief     Log an alert message with the specified format.
 */
- (void) logAlert:(NSString*)format args:(va_list)args IBA_FORMAT_FUNCTION(1, 0);

/*!
 \brief     Log an emergency message with the specified format.
 \note      Emergency messages are written to the terminal of all logged in users.
 */
- (void) logEmergency:(NSString*)format, ... IBA_FORMAT_FUNCTION(1, 2);

/*!
 \brief     Log an emergency message with the specified format.
 \note      Emergency messages are written to the terminal of all logged in users.
 */
- (void) logEmergency:(NSString*)format args:(va_list)args IBA_FORMAT_FUNCTION(1, 0);

/*!
 \brief     Write log messages to the file at the specified path.
 \details   Log messages will be written to this file as well as to the server.
 \param     path    The path of the file to start writing to.
 */
- (void) addLogFile:(NSString*)path;

/*!
 \brief     Strop writing log messages to the file at the specified path.
 \param     path    The path of the file to stop writing to.
 */
- (void) removeLogFile:(NSString*)path;

@end
