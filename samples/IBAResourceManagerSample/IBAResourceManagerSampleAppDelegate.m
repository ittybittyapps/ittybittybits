//
//  IBAResourceManagerSampleAppDelegate.m
//  IBAResourceManagerSample
//
//  Created by Oliver Jones on 7/11/11.
//  Copyright 2011 Deeper Design. All rights reserved.
//

#import "IBAResourceManagerSampleAppDelegate.h"

@implementation IBAResourceManagerSampleAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[IBAResourceManager sharedInstance] pushResourceBundleNamed:@"Resources0"];
     
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
