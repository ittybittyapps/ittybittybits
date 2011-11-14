//
//  RootViewController.h
//  IttyBittyBits
//
//  Created by Oliver Jones on 7/11/11.
//  Copyright (c) 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : IBAViewController

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

+ (id)controller;

- (IBAction)buttonPressed:(id)sender forEvent:(UIEvent*)event;

@end
