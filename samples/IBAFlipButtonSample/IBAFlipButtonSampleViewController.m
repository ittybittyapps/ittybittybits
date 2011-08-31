//
//  IBAFlipButtonSampleViewController.m
//  IBAFlipButtonSample
//
//  Created by Oliver Jones on 30/08/11.
//  Copyright 2011 Deeper Design. All rights reserved.
//

#import "IBAFlipButtonSampleViewController.h"

@interface IBAFlipButtonSampleViewController ()
- (void)backPressed:(id)sender forEvent:(UIEvent *)event;
- (void)frontPressed:(id)sender forEvent:(UIEvent *)event;
- (IBAction)buttonPressed:(id)sender forEvent:(UIEvent *)event;
@end

@implementation IBAFlipButtonSampleViewController

IBA_SYNTHESIZE(flipButton);

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
    
    IBAFlipButton *flipButton = [IBAFlipButton flipButton];
    [flipButton configureButtonsWithBlock:^(IBAFlipButtonSide side, UIButton *button) {

        SEL selector = (side == IBAFlipButtonSideBack ? @selector(barButtonBackPressed:forEvent:) : @selector(barButtonFrontPressed:forEvent:));
        NSString *imageName = (side == IBAFlipButtonSideBack ? @"back" : @"front");
        
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:flipButton] autorelease];
    
    
    [self.flipButton configureButtonsWithBlock:^(IBAFlipButtonSide side, UIButton *button) {
        
        SEL selector = (side == IBAFlipButtonSideBack ? @selector(backPressed:forEvent:) : @selector(frontPressed:forEvent:));
        
        NSString *imageName = (side == IBAFlipButtonSideBack ? @"back" : @"front");

        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setTitle:imageName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button setContentEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

        [button setShowsTouchWhenHighlighted:YES];
        [button setAdjustsImageWhenDisabled:YES];
        
        button.imageView.layer.borderColor = [UIColor blueColor].CGColor;
        button.imageView.layer.borderWidth = 1.0f;
        button.titleLabel.layer.borderColor = [UIColor greenColor].CGColor;
        button.titleLabel.layer.borderWidth = 1.0f;
        
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)barButtonBackPressed:(id)sender forEvent:(UIEvent *)event
{
    NSLog(@"Bar Button Back Pressed");
}

- (void)barButtonFrontPressed:(id)sender forEvent:(UIEvent *)event
{
    NSLog(@"Bar Button Front Pressed");    
}


- (void)backPressed:(id)sender forEvent:(UIEvent *)event
{
    NSLog(@"Button Back Pressed");
}

- (void)frontPressed:(id)sender forEvent:(UIEvent *)event
{
    NSLog(@"Button Front Pressed");    
}

- (IBAction)buttonPressed:(id)sender forEvent:(UIEvent *)event
{
    NSLog(@"Button Pressed");
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
