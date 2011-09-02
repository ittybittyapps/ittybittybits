//
//  IBACarouselView.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/08/11.
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

#import "IBACarouselView.h"
#import "../Foundation/IBAFoundation.h"

@interface IBACarouselView ()
- (id)commonInitialization NS_RETURNS_RETAINED;
- (void) spinCarousel:(UIPanGestureRecognizer *)gesture;
- (CGFloat) rotationForTranslation:(CGFloat)horizontalTranslation;

@property (assign, nonatomic) CGFloat currentRotation;

@end

@implementation IBACarouselView
{
    CGPoint lastTranslation;
    NSTimer *spinTimer;
}

IBA_SYNTHESIZE(dataSource, throwDuration, throwVelocityFactor, minimumThrowVelocity, currentRotation, easingFunction, throwFramesPerSecond);

#pragma mark - Private Methods

- (id)commonInitialization
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(spinCarousel:)];

    [self addGestureRecognizer:panRecognizer];
    [panRecognizer release];
    
    self.throwDuration = 2.0;
    self.throwVelocityFactor = 0.25f;
    self.minimumThrowVelocity = 5.0f;
    self.easingFunction = &IBACubicEaseOut;
    self.throwFramesPerSecond = 60.0;
    
    return self;
}

- (void) spinCarousel:(UIPanGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        lastTranslation = CGPointMake(0, 0);
        
        [self stopSpin];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gesture translationInView:self];
        CGFloat translationSinceLastChange = translation.x - lastTranslation.x;
        lastTranslation = translation;
        
        CGFloat rotation = [self rotationForTranslation:-translationSinceLastChange];
        self.currentRotation = self.currentRotation + rotation;
        [self setNeedsLayout];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint vel = [gesture velocityInView:self];
        if (fabs(vel.x) >= self.minimumThrowVelocity)
        {
            [self spinWithVelocity:((-vel.x * self.throwVelocityFactor)/(180.0f/M_PI)) 
                       forDuration: self.throwDuration];
        }
    }
}

/*!
 \brief     Return rotation (in radians) for the specified \a horizontalTranslation
 */
- (CGFloat) rotationForTranslation:(CGFloat)horizontalTranslation
{
    CGFloat radiansPerPoint = M_PI / self.frame.size.width;
    return horizontalTranslation * radiansPerPoint;
}

/*!
 \brief     Get the view to display for the rotation angle.
 */
- (UIView*) viewForRotation:(CGFloat)rotation
{
    const float TWOPI = 2*M_PI;
    
    NSUInteger viewCount = [self.dataSource numberOfItemsInCarouselView:self];
    if (viewCount > 0)
    {
        CGFloat radiansPerImage = TWOPI / viewCount;
        rotation = IBAConstrainFloatValue(rotation, 0.0f, TWOPI);
        
        NSUInteger index = ((NSUInteger) floorf(rotation / radiansPerImage)) % viewCount;        
        
        UIView *view = [self.dataSource carouselView:self viewForItemAtIndex:index];
        IBAAssertNotNil(view);
        
        return view;
    }
    
    return nil;
}

#pragma mark - Public Methods

/*!
 \brief     Initializes and returns a newly allocated view object with the specified frame rectangle.
 \param     frame       The frame rectangle for the view, measured in points.
 \return    An initialized view object or nil if the object couldn't be created.
 */
- (id)initWithFrame:(CGRect)frame
{
    return [[super initWithFrame:frame] commonInitialization];
}

/*!
 \brief     Returns an object initialized from data in a given unarchiver. (required)
 \param     decoder     An unarchiver object.
 \return    self, initialized using the data in decoder.
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [[super initWithCoder:aDecoder] commonInitialization];
}

/*!
 \brief         Spin the carousel with the specified velocity.
 \param         velocity    The velocity of the spin (measured in radians per second).
 \param         duration    The duration of the spin.
 */
- (void) spinWithVelocity:(CGFloat)velocity 
              forDuration:(NSTimeInterval)duration
{
    // stop any current spin animation before starting another.
    [self stopSpin];
        
    // Just use the velocity as the target translation/rotation value.
    CGFloat throwDistance = (velocity * duration);
    CGFloat startRotation = self.currentRotation;
    
    NSDate *start = [NSDate date];
    
    IBA_BLOCK_WEAK IBACarouselView *weakself = self;
    spinTimer = [[NSTimer ibaScheduledTimerWithTimeInterval:1.0/self.throwFramesPerSecond repeats:YES usingBlock:^(NSTimer *timer) {
        
        NSTimeInterval elapsedTime = fabs([start timeIntervalSinceNow]);
        
        weakself.currentRotation = weakself.easingFunction(elapsedTime, startRotation, throwDistance, duration);
        if (elapsedTime >= duration)
        {
            [weakself stopSpin];
        }
        
        [weakself setNeedsLayout];
    }] retain];
}

/*!
 \brief         Stop the Carousel's spin animation (if active).
 */
- (void) stopSpin
{
    [spinTimer invalidate];
    IBA_RELEASE(spinTimer);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Stop any existing spin as soon as the view is touched.
    [self stopSpin];
}

- (void)setCurrentRotation:(CGFloat)currentRotation
{
    currentRotation_ = currentRotation;
}
/*!
 */
- (void)layoutSubviews
{
    UIView *view = [self viewForRotation:self.currentRotation];
    view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    if ([self.subviews count] > 0)
    {
        [[self.subviews objectAtIndex:0] removeFromSuperview];
    }
    
    [self addSubview:view];
}

/*!
 \brief     Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    [self stopSpin];
    self.dataSource = nil;
    
    [super dealloc];
}

@end
