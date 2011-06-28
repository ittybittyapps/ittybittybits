//
//  NSFetchRequest+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSFetchRequest+IBAExtensions.h"
#import "NSEntityDescription+IBAExtensions.h"

@implementation NSFetchRequest (IBAExtensions)

+ (id) newDictionaryFetchRequestForEntity:(NSString *)entityName inContext:(NSManagedObjectContext*)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    
    return request;
}

@end
