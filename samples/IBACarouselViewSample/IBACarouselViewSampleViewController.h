//
//  IBACarouselViewSampleViewController.h
//  IBACarouselViewSample
//
//  Created by Oliver Jones on 1/09/11.
//  Copyright 2011 Deeper Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IBACarouselView;

@interface IBACarouselViewSampleViewController : UIViewController<IBACarouselViewDatasource>

@property (nonatomic, retain) IBOutlet IBACarouselView* carousel1;
@property (nonatomic, retain) IBOutlet IBACarouselView* carousel2;

@end
