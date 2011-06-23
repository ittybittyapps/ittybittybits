//
//  IBAGradientButton.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 23/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "IBAGradientButton.h"
#import "../Foundation/IBAFoundation.h"

@implementation IBAGradientButton

+ (Class) layerClass
{
    return [CAGradientLayer class];
}

- (CAGradientLayer *) gradientLayer
{
    return (CAGradientLayer *)self.layer;
}

- (NSArray *)colors
{
    return self.gradientLayer.colors;
}

- (void)setColors:(NSArray *)colors
{
    self.gradientLayer.colors = colors;
}

- (NSArray *)locations
{
    return self.gradientLayer.locations;
}

- (void)setLocations:(NSArray *)locations
{
    self.gradientLayer.locations = locations;
}

- (CGPoint)startPoint
{
    return self.gradientLayer.startPoint;
}

- (void)setStartPoint:(CGPoint)startPoint
{
    self.gradientLayer.startPoint = startPoint;
}

- (NSString *)type
{
    return self.gradientLayer.type;
}

- (void)setType:(NSString *)type
{
    self.gradientLayer.type = type;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.colors = [self.colors ibaReversedArray];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.colors = [self.colors ibaReversedArray];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.colors = [self.colors ibaReversedArray];
    [super touchesCancelled:touches withEvent:event];
}

@end
