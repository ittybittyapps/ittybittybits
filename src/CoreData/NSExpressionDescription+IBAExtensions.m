//
//  NSExpressionDescription+IBAExtensions.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 28/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "NSExpressionDescription+IBAExtensions.h"
#import <CoreData/CoreData.h>

#import "NSEntityDescription+IBAExtensions.h"
#import "../Foundation/IBAFoundation.h"

@implementation NSExpressionDescription (IBAExtensions)


+ (NSExpressionDescription *)expressionForFunction:(NSString *)function 
                                       onAttribute:(NSString *)attribute 
                                          ofEntity:(NSEntityDescription*)entity
                                            asName:(NSString*)name
{
    NSExpression* keyPathExpression = [NSExpression expressionForKeyPath:attribute];
    NSExpression* expression = [NSExpression expressionForFunction:function
                                                         arguments:IBA_NSARRAY(keyPathExpression)];
    
    NSExpressionDescription* expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:name];
    [expressionDescription setExpression:expression];
    [expressionDescription setExpressionResultType:[[entity ibaAttributeByName:attribute] attributeType]];
    
    return [expressionDescription autorelease];
}

@end
