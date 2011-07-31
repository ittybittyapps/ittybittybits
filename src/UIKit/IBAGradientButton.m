//
//  IBAGradientButton.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 23/06/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
