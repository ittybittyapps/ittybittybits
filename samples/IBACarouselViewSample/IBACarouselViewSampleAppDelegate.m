//
//  IBACarouselViewSampleAppDelegate.m
//  IBACarouselViewSample
//
//  Created by Oliver Jones on 1/09/11.
//  Copyright 2011 Deeper Design. All rights reserved.
//

#import "IBACarouselViewSampleAppDelegate.h"

@implementation IBACarouselViewSampleAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#pragma unused(application, launchOptions)
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
