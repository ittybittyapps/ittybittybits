//
//  DebugConsoleAppDelegate.h
//  DebugConsole
//
//  Created by Oliver Jones on 3/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DebugConsoleViewController;

@interface DebugConsoleAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet DebugConsoleViewController *viewController;

@end
