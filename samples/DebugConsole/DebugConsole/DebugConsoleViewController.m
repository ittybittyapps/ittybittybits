//
//  DebugConsoleViewController.m
//  DebugConsole
//
//  Created by Oliver Jones on 3/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DebugConsoleViewController.h"

@implementation DebugConsoleViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)openDebugConsole:(id)sender 
{
    [self presentModalViewController:<#(UIViewController *)#> animated:<#(BOOL)#>
}
@end
