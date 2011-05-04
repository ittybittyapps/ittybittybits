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

#import "NSTimer+Blocks.h"

@interface NSTimer (IBA_NSTimerBlockPrivateAdditions)
+ (void)iba_executeBlockWithTimer:(NSTimer*)timer;
@end

@implementation NSTimer (IBA_NSTimerBlockAdditions)

/////////////////////////////////////////////////////////////////////////////////////////////////
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

/////////////////////////////////////////////////////////////////////////////////////////////////
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


@implementation NSTimer (IBA_NSTimerBlockPrivateAdditions)

/////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)iba_executeBlockWithTimer:(NSTimer*)timer
{
    IBATimerBlock block = [timer userInfo];
    block(timer);
}
@end
