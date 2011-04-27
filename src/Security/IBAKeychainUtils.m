//
//  IBAKeychainUtils.m
//
//  Created by Buzz Andersen on 10/20/08.
//  Based partly on code by Jonathan Wight, Jon Crosby, and Mike Malone.
//  Copyright 2008 Sci-Fi Hi-Fi. All rights reserved.
//
//  Modified by Oliver Jones (oliver@ittybittyapps.com)
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "IBAKeychainUtils.h"
#import "IBADebug.h"

#import <Security/Security.h>

static NSString *IBAKeychainUtilsErrorDomain = @"IBAKeychainUtilsErrorDomain";

/////////////////////////////////////////////////////////////////////////////////////////////////
static void ClearError(NSError** error)
{
    if (error != nil) 
    {
		*error = nil;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////
static void SetErrorForError(NSError** error, NSError* srcError)
{
    if (error != nil)
    {
        *error = srcError;
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
static void SetErrorForCode(NSError** error, NSInteger code)
{
    if (error != nil)
    {
        // Only return an error if a real exception happened--not simply for "not found."
        *error = [NSError errorWithDomain: IBAKeychainUtilsErrorDomain 
                                     code: code 
                                 userInfo: nil];
    }
}

@implementation IBAKeychainUtils

/////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *) getPasswordForUsername: (NSString*) username 
                          serviceName: (NSString*) serviceName 
                                error: (NSError**) error 
{
    IBAAssertNotNilOrEmptyString(username);
    IBAAssertNotNilOrEmptyString(serviceName);
	
	ClearError(error);
    
	// Set up a query dictionary with the base query attributes: item type (generic), username, and service
	NSArray *keys = [NSArray arrayWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil];
	NSArray *objects = [NSArray arrayWithObjects: (NSString *) kSecClassGenericPassword, username, serviceName, nil];
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjects: objects forKeys: keys];
	
	// First do a query for attributes, in case we already have a Keychain item with no password data set.
	// One likely way such an incorrect item could have come about is due to the previous (incorrect)
	// version of this code (which set the password as a generic attribute instead of password data).
	
	NSDictionary *attributeResult = NULL;
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject: (id) kCFBooleanTrue forKey:(id) kSecReturnAttributes];
	OSStatus status = SecItemCopyMatching((CFDictionaryRef) attributeQuery, (CFTypeRef *) &attributeResult);
	
	[attributeResult release];
	[attributeQuery release];
	
	if (status != noErr) 
    {
		// No existing item found--simply return nil for the password
		if (status != errSecItemNotFound) 
        {
            // Only return an error if a real exception happened--not simply for "not found."
            SetErrorForCode(error, status);
		}
		
		return nil;
	}
	
	// We have an existing item, now query for the password data associated with it.
	
	NSData *resultData = nil;
	NSMutableDictionary *passwordQuery = [query mutableCopy];
	[passwordQuery setObject: (id) kCFBooleanTrue forKey: (id) kSecReturnData];
    
	status = SecItemCopyMatching((CFDictionaryRef) passwordQuery, (CFTypeRef *) &resultData);
	
	[resultData autorelease];
	[passwordQuery release];
	
	if (status != noErr) 
    {
		if (status == errSecItemNotFound) 
        {
			// We found attributes for the item previously, but no password now, so return a special error.
			// Users of this API will probably want to detect this error and prompt the user to
			// re-enter their credentials.  When you attempt to store the re-entered credentials
			// using storeUsername:andPassword:forServiceName:updateExisting:error
			// the old, incorrect entry will be deleted and a new one with a properly encrypted
			// password will be added.
            SetErrorForCode(error, -1998);
		}
		else 
        {
			// Something else went wrong. Simply return the normal Keychain API error code.
            SetErrorForCode(error, status);
		}
		
		return nil;
	}
    
	NSString *password = nil;    
	if (resultData) 
    {
		password = [[NSString alloc] initWithData: resultData encoding: NSUTF8StringEncoding];
	}
	else 
    {
		// There is an existing item, but we weren't able to get password data for it for some reason,
		// Possibly as a result of an item being incorrectly entered by the previous code.
		// Set the -1999 error so the code above us can prompt the user again.
        SetErrorForCode(error, -1999);
	}
    
	return [password autorelease];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) storeUsername: (NSString*) username 
              password: (NSString*) password 
        forServiceName: (NSString*) serviceName 
        updateExisting: (BOOL) updateExisting 
                 error: (NSError**) error 
{	
	IBAAssertNotNilOrEmptyString(username);
    IBAAssertNotNil(password);
    IBAAssertNotNilOrEmptyString(serviceName);
    
	// See if we already have a password entered for these credentials.
	NSError* getError = nil;
	NSString* existingPassword = [IBAKeychainUtils getPasswordForUsername: username 
                                                              serviceName: serviceName 
                                                                    error: &getError];
    
	if ([getError code] == -1999) 
    {
		// There is an existing entry without a password properly stored 
        // (possibly as a result of the previous incorrect version of this code.
		// Delete the existing item before moving on entering a correct one.
        
		getError = nil;
		
		[self deleteItemForUsername: username 
                        serviceName: serviceName 
                              error: &getError];
        
		if ([getError code] != noErr) 
        {
            SetErrorForError(error, getError);            
			return NO;
		}
	}
	else if ([getError code] != noErr) 
    {
        SetErrorForError(error, getError);        
		return NO;
	}
	
	ClearError(error);
	
	OSStatus status = noErr;
    NSData* passwordData = [password dataUsingEncoding: NSUTF8StringEncoding];
    
	if (existingPassword) 
    {
		// We have an existing, properly entered item with a password.
		// Update the existing item.		
		if (![existingPassword isEqualToString:password] && updateExisting) 
        {
			// Only update if we're allowed to update existing.  If not, simply do nothing.        
			NSArray *keys = [NSArray arrayWithObjects: (NSString*) kSecClass, 
                             kSecAttrService, 
                             kSecAttrLabel, 
                             kSecAttrAccount, 
                             nil];
			
			NSArray *objects = [NSArray arrayWithObjects: (NSString*) kSecClassGenericPassword, 
                                serviceName,
                                serviceName,
                                username,
                                nil];
			
            
			NSDictionary *query = [NSDictionary dictionaryWithObjects: objects forKeys: keys];
            NSDictionary* data = [NSDictionary dictionaryWithObject: passwordData forKey: (NSString *) kSecValueData];
            
			status = SecItemUpdate((CFDictionaryRef) query, (CFDictionaryRef) data);
		}
	}
	else 
    {
		// No existing entry (or an existing, improperly entered, and therefore now
		// deleted, entry).  Create a new entry.
		NSArray *keys = [NSArray arrayWithObjects: (NSString *) kSecClass, 
                         kSecAttrService, 
                         kSecAttrLabel, 
                         kSecAttrAccount, 
                         kSecValueData, 
                         nil];
		
		NSArray *objects = [NSArray arrayWithObjects: (NSString *) kSecClassGenericPassword, 
                            serviceName,
                            serviceName,
                            username,
                            passwordData,
                            nil];
		
		NSDictionary *query = [NSDictionary dictionaryWithObjects: objects forKeys: keys];			
        
		status = SecItemAdd((CFDictionaryRef) query, NULL);
	}
	
	if (status != noErr) 
    {
        // Something went wrong with adding the new item. Return the Keychain error code.
        SetErrorForCode(error, status);
        
        return NO;
	}
    
    return YES;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) deleteItemForUsername: (NSString*) username 
                   serviceName: (NSString*) serviceName 
                         error: (NSError**) error 
{
    IBAAssertNotNilOrEmptyString(username);
    IBAAssertNotNilOrEmptyString(serviceName);
	
    ClearError(error);
    
	NSArray *keys = [NSArray arrayWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
	NSArray *objects = [NSArray arrayWithObjects: (NSString *) kSecClassGenericPassword, username, serviceName, kCFBooleanTrue, nil];
	NSDictionary *query = [NSDictionary dictionaryWithObjects: objects forKeys: keys];
	
	OSStatus status = SecItemDelete((CFDictionaryRef) query);
	if (status != noErr) 
    {
        SetErrorForCode(error, status);
        
        return NO;
	}
    
    return YES;
}

@end