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

- (id) initWithStream:(NSInputStream*)inputStream 
      linesEndingWith:(NSString*)lineEnding 
             encoding:(NSStringEncoding)encoding;


- (NSInteger) readLine:(NSString**)line;

@end
