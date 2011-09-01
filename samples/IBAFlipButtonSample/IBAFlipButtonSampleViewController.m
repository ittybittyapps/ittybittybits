//
//  IBAFlipButtonSampleViewController.m
//  IBAFlipButtonSample
//
//  Created by Oliver Jones on 30/08/11.
//  Copyright 2011 Deeper Design. All rights reserved.
//

#import "IBAFlipButtonSampleViewController.h"

@interface IBAFlipButtonSampleViewController ()
- (void)barButtonPressed:(IBAFlipButton *)sender forEvent:(UIEvent *)event;
- (IBAction)buttonPressed:(id)sender forEvent:(UIEvent *)event;
@end

@implementation IBAFlipButtonSampleViewController

IBA_SYNTHESIZE(flipButton, flipButton2);

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    // set up the bar button item.
    IBAFlipButton *flipButton = [IBAFlipButton flipButton];
  
    flipButton.adjustsImageWhenHighlighted = YES;
    [flipButton setImage:[UIImage imageNamed:@"front"] forState:UIControlStateNormal];
    [flipButton setImage:[UIImage imageNamed:@"front"] forState:UIControlStateHighlighted];
    [flipButton setImage:[UIImage imageNamed:@"back"] forState:IBAFlipButtonControlStateFlipped];
    [flipButton setImage:[UIImage imageNamed:@"back"] forState:IBAFlipButtonControlStateFlipped | UIControlStateHighlighted];
    
    [flipButton addTarget:self action:@selector(barButtonPressed:forEvent:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:flipButton] autorelease];

    // self.flipButton is configured mainly in the XIB, only the control state that IB doesn't support needs to be configured in code.
    self.flipButton.animationDuration = 2.0;
    self.flipButton.adjustsImageWhenHighlighted = YES;
    [self.flipButton  setImage:[UIImage imageNamed:@"back"] forState:IBAFlipButtonControlStateFlipped];
    [self.flipButton  setImage:[UIImage imageNamed:@"back"] forState:IBAFlipButtonControlStateFlipped | UIControlStateHighlighted];
    
    [self.flipButton  setTitle:@"Back" forState:IBAFlipButtonControlStateFlipped];
    [self.flipButton  setTitle:@"Back" forState:IBAFlipButtonControlStateFlipped | UIControlStateHighlighted];

    [self.flipButton  setTitleColor:[UIColor greenColor] forState:IBAFlipButtonControlStateFlipped];
    [self.flipButton  setTitleColor:[UIColor blueColor] forState:(IBAFlipButtonControlStateFlipped | UIControlStateHighlighted)];
    
    [self.flipButton  setContentEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.flipButton  setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    // self.flipButton2 is configured mainly in the XIB
    self.flipButton2.flipType = IBAFlipButtonFlipTypeImageOnly;
    [self.flipButton2  setImage:[UIImage imageNamed:@"back"] forState:IBAFlipButtonControlStateFlipped];
    [self.flipButton2  setImage:[UIImage imageNamed:@"back"] forState:IBAFlipButtonControlStateFlipped | UIControlStateHighlighted];

    [self.flipButton2  setTitle:@"Back" forState:IBAFlipButtonControlStateFlipped];
    [self.flipButton2  setTitle:@"Back" forState:IBAFlipButtonControlStateFlipped | UIControlStateHighlighted];

    
}

- (void)barButtonPressed:(IBAFlipButton *)sender forEvent:(UIEvent *)event
{
    NSLog(@"Bar Button Pressed, flipped? %@", sender.flipped ? @"YES" : @"NO");
}

- (IBAction)buttonPressed:(IBAFlipButton *)sender forEvent:(UIEvent *)event
{
    NSLog(@"Button Pressed, flipped? %@", sender.flipped ? @"YES" : @"NO");
}

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

@end
