//
//  IBAFlipButton.m
//  IttyBittyBits
//
//  Created by Oliver Jones on 30/08/11.
//  Copyright 2011 Itty Bitty Apps Pty. Ltd. All rights reserved.
//

#import "IBAFlipButton.h"
#import "../Foundation/IBAFoundation.h"

@interface IBAFlipButton ()
- (id)commonInitialization NS_RETURNS_RETAINED;
- (UIButton *)buttonForSide:(IBAFlipButtonSide)side;

@property (nonatomic, assign, readwrite) IBAFlipButtonSide currentSide;

@end

@implementation IBAFlipButton
{
    NSArray *buttons;
}

IBA_SYNTHESIZE(currentSide, animationDuration, flipDirection);

#pragma mark - Private Methods

- (void)forwardTouchUpInside:(id)sender
{
    
    IBAFlipButtonSide oldSide = self.currentSide;
    
    // do the flip
    UIView *fromView = [buttons objectAtIndex:self.currentSide];
    UIView *toView = [buttons objectAtIndex:!self.currentSide];    
    toView.hidden = NO;
    
    [UIView transitionWithView:self
                      duration:self.animationDuration
                       options:(self.flipDirection == IBAFlipButtonDirectionFromLeft ?  UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight)
                    animations:^{ 
                        fromView.hidden = YES;
                        toView.hidden = NO;
                        self.currentSide = !self.currentSide;
                    }
                    completion:nil];

    // forward event
    [[self buttonForSide:oldSide] sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)forwardTouchUpOutside:(id)sender
{
    [[self buttonForSide:self.currentSide] sendActionsForControlEvents:UIControlEventTouchUpOutside];    
}

- (void)forwardTouchDown:(id)sender
{
    [[self buttonForSide:self.currentSide] sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void)forwardTouchDownRepeat:(id)sender
{
    [[self buttonForSide:self.currentSide] sendActionsForControlEvents:UIControlEventTouchDownRepeat];
}

- (void)forwardTouchDragInside:(id)sender
{
    [[self buttonForSide:self.currentSide] sendActionsForControlEvents:UIControlEventTouchDragInside];
}

- (void)forwardTouchDragOutside:(id)sender
{
    [[self buttonForSide:self.currentSide] sendActionsForControlEvents:UIControlEventTouchDragOutside];
}

- (void)forwardTouchDragEnter:(id)sender
{
    [[self buttonForSide:self.currentSide] sendActionsForControlEvents:UIControlEventTouchDragEnter];
}

- (void)forwardTouchDragExit:(id)sender
{
    [[self buttonForSide:self.currentSide] sendActionsForControlEvents:UIControlEventTouchDragExit];
}

- (void)forwardTouchCancel:(id)sender
{
    [[self buttonForSide:self.currentSide] sendActionsForControlEvents:UIControlEventTouchCancel];
}

- (id)commonInitialization
{
    self.currentSide = IBAFlipButtonSideFront;
    self.animationDuration = 0.25;
    self.flipDirection = IBAFlipButtonDirectionFromLeft;

    // forward events
    [self addTarget:self action:@selector(forwardTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(forwardTouchDownRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
    [self addTarget:self action:@selector(forwardTouchDragInside:) forControlEvents:UIControlEventTouchDragInside];
    [self addTarget:self action:@selector(forwardTouchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
    [self addTarget:self action:@selector(forwardTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(forwardTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(forwardTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(forwardTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(forwardTouchCancel:) forControlEvents:UIControlEventTouchCancel];

    buttons = [[NSArray alloc] initWithObjects:[UIButton buttonWithType:UIButtonTypeCustom], [UIButton buttonWithType:UIButtonTypeCustom], nil];
    for (UIView *v in buttons)
    {
        [self addSubview:v];
    }
    
    return self;
}

- (void)buttonPressed:(id)sender
{
    }

#pragma mark - Public Methods

+ (IBAFlipButton *)flipButton
{
    // Is 44x44 reasonable default frame rect for a button?  Sounds good to me.
    return [self flipButtonWithFrame:CGRectMake(0, 0, 44, 44)];
}

+ (IBAFlipButton *)flipButtonWithFrame:(CGRect)frame
{
    return [[[self alloc] initWithFrame:frame] autorelease];
}

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

/*
 Lays out subviews.
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (size_t i = 0; i < [buttons count]; ++i)
    {
        UIButton *b = [buttons objectAtIndex:i];
        b.hidden = (i != self.currentSide);
        b.frame = self.bounds;
    }
}

/*!
 Returns the farthest descendant of the receiver in the view hierarchy (including itself) that contains a specified point.
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // subviews do not participate in hit testing.
    return self;
}

/*
 Deallocates the memory occupied by the receiver.
 */
- (void)dealloc
{
    IBA_RELEASE(buttons);
    
    [super dealloc];
}

- (UIButton *)buttonForSide:(IBAFlipButtonSide)side
{
    NSAssert(side >= IBAFlipButtonSideFront && side <= IBAFlipButtonSideBack, @"side out of bounds");
    return [buttons objectAtIndex:side];
}

/*!
 \brief     Configure the buttons using the specified \a block. 
 \details   The provided block is invoked for each side of the button.  Configure the button instance passed to the block as necessary.
 */
- (void)configureButtonsWithBlock:(void (^)(IBAFlipButtonSide side, UIButton *button))block
{
    block(IBAFlipButtonSideFront, [self buttonForSide:IBAFlipButtonSideFront]);
    block(IBAFlipButtonSideBack, [self buttonForSide:IBAFlipButtonSideBack]);
}

/*!
 \brief     Sets a Boolean value that determines whether the receiver is highlighted.
 */
- (void)setHighlighted:(BOOL)highlighted
{
    for (UIButton *b in buttons)
    {
        b.highlighted = highlighted;
    }
    
    [super setHighlighted:highlighted];
}

/*!
 \brief     Sets a Boolean value that determines the receiver’s selected state.
 */
- (void)setSelected:(BOOL)selected
{
    for (UIButton *b in buttons)
    {
        b.selected = selected;
    }
    
    [super setSelected:selected];
}

@end
