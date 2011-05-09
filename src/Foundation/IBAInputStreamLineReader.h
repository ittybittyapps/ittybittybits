//
//  IBALineInputStream.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 9/05/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IBAInputStreamLineReader : NSObject {
}

/*!
 \brief     Creates an autoreleased reader instance with the specified \a inputStream, \a lineEnding and string \a encoding.
 \param     inputStream
            The input stream to read from.
 \param     lineEnding
            The string to use as the line ending sequence in the file.
 \param     encoding
            The string encoding to use when converting the stream contents to strings.
 */
+ (id) readerWithInputStream:(NSInputStream*)inputStream 
             linesEndingWith:(NSString*)lineEnding 
                    encoding:(NSStringEncoding)encoding;

/*!
 \brief     Creates an autoreleased reader instance with the specified \a inputStream.
 \details   The line ending string defaults to new-line (\\n) with a UTF8 string encoding.
 */
+ (id) readerWithInputStream:(NSInputStream*)inputStream;


/*!
 \brief     Initializes the reader instance with the specified \a inputStream.
 \details   The line ending string defaults to new-line (\\n) with a UTF8 string encoding.
 */
- (id) initWithStream:(NSInputStream*)inputStream;

/*!
 \brief     Initializes the reader instance with the specified \a inputStream, \a lineEnding and string \a encoding.
 \param     inputStream
 The input stream to read from.
 \param     lineEnding
 The string to use as the line ending sequence in the file.
 \param     encoding
 The string encoding to use when converting the stream contents to strings.
 */
- (id) initWithStream:(NSInputStream*)inputStream 
      linesEndingWith:(NSString*)lineEnding 
             encoding:(NSStringEncoding)encoding;


/*!
 \brief     Read a line.
 \param     line
            A pointer to an NSString read from the input stream. The value of the pointer will be overwritten.  The NSString instance pointed to will be autoreleased. Callers should only retain the instance if they need to.
 \return    Return Value
            A number indicating the outcome of the operation.   A positive number indicates the number of bytes read; 0 indicates that the end of the buffer was reached; A negative number means that the operation failed.
 */
- (NSInteger) readLine:(NSString**)line;

@end
