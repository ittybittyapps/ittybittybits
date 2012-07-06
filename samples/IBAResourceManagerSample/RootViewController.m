//
//  RootViewController.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 7/11/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "IttyBittyBits.h"

@implementation RootViewController

@synthesize label, imageView;

+ (id)controller
{
    return [[[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil] autorelease];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    IBAResourceManager *resources = [IBAResourceManager sharedInstance];
    
    self.label.textColor = [resources colorNamed:@"labelTextColor"];
    self.label.backgroundColor = [resources colorNamed:@"labelBackgroundColor"];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.image = [resources imageNamed:@"image"];
    
    [super viewDidLoad];
}

-(void)viewDidDisappear:(BOOL)animated
{
#pragma unused(animated)
    if (self.navigationController == nil)
    {
        [[IBAResourceManager sharedInstance] popResourceBundle];
    }
}

- (IBAction)buttonPressed:(id)sender forEvent:(UIEvent*)event
{
#pragma unused(sender, event)
    NSString *bundleName = [NSString stringWithFormat:@"Resources%d", [self.navigationController.viewControllers count] % 2];

    [[IBAResourceManager sharedInstance] pushResourceBundleNamed:bundleName];

    [self.navigationController pushViewController:[RootViewController controller] animated:YES];
}

@end
