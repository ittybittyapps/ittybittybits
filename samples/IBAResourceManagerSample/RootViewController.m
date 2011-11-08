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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (self.navigationController == nil)
    {
        [[IBAResourceManager sharedInstance] popResourceBundle];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buttonPressed:(id)sender forEvent:(UIEvent*)event
{
    [[IBAResourceManager sharedInstance] pushResourceBundleNamed:[NSString stringWithFormat:@"Resources%d", [self.navigationController.viewControllers count] % 2]];

    [self.navigationController pushViewController:[RootViewController controller] animated:YES];
}

@end
