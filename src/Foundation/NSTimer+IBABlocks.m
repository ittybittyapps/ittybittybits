/*
 Copyright (c) 2009 Remy Demarest
 Modifications Copyright (c) 2011 Oliver Jones
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */

#import "NSTimer+IBABlocks.h"

#pragma mark -
#pragma Private Interface

@interface NSTimer (IBABlocksPrivate)
+ (void)iba_executeBlockWithTimer:(NSTimer *)timer;
@end

@implementation NSTimer (IBABlocks)

/*!
 \brief     Creates and returns a new NSTimer object initialized with the specified block.
 \details   You must add the new timer to a run loop, using NSRunLoop#addTimer:forMode:. Then, after seconds seconds have elapsed, the timer fires, sending the message aSelector to target. (If the timer is configured to repeat, there is no need to subsequently re-add the timer to the run loop.)
 \param     seconds
            The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead.
 \param     repeats
            If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
 \param     block
            The block to execute when the timer fires.
 \return    A new NSTimer object, configured according to the specified parameters.
 */
+ (NSTimer *)ibaScheduledTimerWithTimeInterval:(NSTimeInterval)seconds 
                                       repeats:(BOOL)repeats 
                                    usingBlock:(IBATimerBlock)block
{
    return [self scheduledTimerWithTimeInterval:seconds 
                                         target:self 
                                       selector:@selector(iba_executeBlockWithTimer:) 
                                       userInfo:[[block copy] autorelease]
                                        repeats:repeats];
}

/*!
 \brief     Creates and returns a new NSTimer object initialized to with the specified block and schedules it on the current run loop in the default mode.
 \details   After seconds seconds have elapsed, the timer fires, sending the message aSelector to target.
 
 \param     seconds     
            The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead.
 \param     repeats
            If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
 \param     block       
            The block to execute when the timer fires.
 
 \return    A new NSTimer object, configured according to the specified parameters.
 */
+ (NSTimer *)ibaTimerWithTimeInterval:(NSTimeInterval)seconds 
                              repeats:(BOOL)repeats 
                           usingBlock:(IBATimerBlock)block
{
    return [self timerWithTimeInterval:seconds 
                                target:self 
                              selector:@selector(iba_executeBlockWithTimer:) 
                              userInfo:[[block copy] autorelease]
                               repeats:repeats];
}

@end

#pragma mark -
#pragma Private Implmention

@implementation NSTimer (IBABlocksPrivate)


+ (void)iba_executeBlockWithTimer:(NSTimer *)timer
{
    IBATimerBlock block = [timer userInfo];
    block(timer);
}
@end
