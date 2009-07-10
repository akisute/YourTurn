//
//  YTYourTurnBackgroundView.m
//  YourTurn
//
//  Created by Masashi Ono on 09/07/07.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTYourTurnBackgroundView.h"

#define TIME_INTERVAL_REDRAW (1.0 / 30)
#define HEIGHT_GRADIENT 220.0


@interface YTYourTurnBackgroundView (Private)
/*! Calculate the delta between start hue and end hue. Takes as small delta as possible. */
- (CGFloat)calculateHueDeltaWithStartHue:(CGFloat)s endHue:(CGFloat)e time:(CGFloat)t;
@end


@implementation YTYourTurnBackgroundView

/*! Used when initializing from xib files. */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder])
    {
        initialBackgroundColorHSBA = malloc(4 * sizeof(CGFloat));
        endBackgroundColorHSBA = malloc(4 * sizeof(CGFloat));
        currentBackgroundColorHSBA = malloc(4 * sizeof(CGFloat));
        deltaBackgroundColorHSBA = malloc(4 * sizeof(CGFloat));
        
        initialBackgroundColorHSBA[0] = 0.0;
        initialBackgroundColorHSBA[1] = 1.0;
        initialBackgroundColorHSBA[2] = 1.0;
        initialBackgroundColorHSBA[3] = 1.0;
        endBackgroundColorHSBA[0] = 0.0;
        endBackgroundColorHSBA[1] = 1.0;
        endBackgroundColorHSBA[2] = 1.0;
        endBackgroundColorHSBA[3] = 1.0;
        currentBackgroundColorHSBA[0] = 0.0;
        currentBackgroundColorHSBA[1] = 1.0;
        currentBackgroundColorHSBA[2] = 1.0;
        currentBackgroundColorHSBA[3] = 1.0;
        deltaBackgroundColorHSBA[0] = 0.0;
        deltaBackgroundColorHSBA[1] = 0.0;
        deltaBackgroundColorHSBA[2] = 0.0;
        deltaBackgroundColorHSBA[3] = 0.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *currentColor = [UIColor colorWithHue:currentBackgroundColorHSBA[0]
                                       saturation:currentBackgroundColorHSBA[1]
                                       brightness:currentBackgroundColorHSBA[2]
                                            alpha:currentBackgroundColorHSBA[3]];
    if (gradient)
    {
        // gradient background
        CGGradientRef grad;
        CGColorSpaceRef colorSpace;
        CGColorRef currentColorRef = [currentColor CGColor];
        CGColorRef voidColorRef = [[UIColor colorWithHue:0.0
                                              saturation:0.0
                                              brightness:0.17
                                                   alpha:1.0] CGColor];
        CGColorRef colorArray[2] = {voidColorRef, currentColorRef};
        CGFloat locations[2] = { 0.0, 1.0 };
        CFArrayRef colors = CFArrayCreate(kCFAllocatorDefault, (const void **)colorArray, 2, &kCFTypeArrayCallBacks);
        
        colorSpace = CGColorSpaceCreateDeviceRGB();
        grad = CGGradientCreateWithColors(colorSpace, colors, locations);
        
        CGFloat progress = currentTime / allottedTime;
        CGFloat height = self.frame.size.height + HEIGHT_GRADIENT;
        CGPoint startPoint = CGPointMake(self.frame.size.width/2, progress * height - HEIGHT_GRADIENT);
        CGPoint endPoint = CGPointMake(self.frame.size.width/2, progress * height);
        CGContextDrawLinearGradient(context,
                                    grad,
                                    startPoint,
                                    endPoint,
                                    kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    }
    else
    {
        // opaque background
        [currentColor set];
        CGContextFillRect(context, rect);
    }
}

- (void)dealloc
{
    free(initialBackgroundColorHSBA);
    free(endBackgroundColorHSBA);
    free(currentBackgroundColorHSBA);
    free(deltaBackgroundColorHSBA);
    [super dealloc];
}

#pragma mark other method

- (void)setTimerWithAllottedTime:(int)time
                            wait:(NSTimeInterval)wait
                    initialColor:(CGFloat *)initialColor
                        endColor:(CGFloat *)endColor
                        gradient:(BOOL)grad
{
    allottedTime = (NSTimeInterval)time;
    currentTime = 0.0;
    gradient = grad;
    initialBackgroundColorHSBA[0] = initialColor[0];
    initialBackgroundColorHSBA[1] = initialColor[1];
    initialBackgroundColorHSBA[2] = initialColor[2];
    initialBackgroundColorHSBA[3] = initialColor[3];
    endBackgroundColorHSBA[0] = endColor[0];
    endBackgroundColorHSBA[1] = endColor[1];
    endBackgroundColorHSBA[2] = endColor[2];
    endBackgroundColorHSBA[3] = endColor[3];
    currentBackgroundColorHSBA[0] = initialBackgroundColorHSBA[0];
    currentBackgroundColorHSBA[1] = initialBackgroundColorHSBA[1];
    currentBackgroundColorHSBA[2] = initialBackgroundColorHSBA[2];
    currentBackgroundColorHSBA[3] = initialBackgroundColorHSBA[3];
    deltaBackgroundColorHSBA[0] = [self calculateHueDeltaWithStartHue:initialBackgroundColorHSBA[0]
                                                               endHue:endBackgroundColorHSBA[0]
                                                                 time:(CGFloat)(allottedTime / TIME_INTERVAL_REDRAW)];
    deltaBackgroundColorHSBA[1] = (endBackgroundColorHSBA[1] - initialBackgroundColorHSBA[1]) / allottedTime;
    deltaBackgroundColorHSBA[2] = (endBackgroundColorHSBA[2] - initialBackgroundColorHSBA[2]) / allottedTime;
    deltaBackgroundColorHSBA[3] = (endBackgroundColorHSBA[3] - initialBackgroundColorHSBA[3]) / allottedTime;
    LOG(@"[color delta]hue=%f, saturation=%f, brightness=%f alpha=%f",
        deltaBackgroundColorHSBA[0],
        deltaBackgroundColorHSBA[1],
        deltaBackgroundColorHSBA[2],
        deltaBackgroundColorHSBA[3]
    );
    
    if (timer)
    {
        // set a new interval for current timer
        [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:TIME_INTERVAL_REDRAW + wait]];
    }
    else
    {
        // create a new timer with given interval
        // timer is just assigned, not retained here
        timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL_REDRAW
                                                 target:self
                                               selector:@selector(timerFired)
                                               userInfo:nil
                                                repeats:YES];
    }
    
    [self setNeedsDisplay];
}

- (void)timerFired
{
    currentTime += TIME_INTERVAL_REDRAW;
    currentBackgroundColorHSBA[0] = currentBackgroundColorHSBA[0] + deltaBackgroundColorHSBA[0];
    currentBackgroundColorHSBA[1] = currentBackgroundColorHSBA[1] + deltaBackgroundColorHSBA[1];
    currentBackgroundColorHSBA[2] = currentBackgroundColorHSBA[2] + deltaBackgroundColorHSBA[2];
    currentBackgroundColorHSBA[3] = currentBackgroundColorHSBA[3] + deltaBackgroundColorHSBA[3];
    [self setNeedsDisplay];
}

- (void)releaseTimer
{
    // invalidate the current timer
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark private method

- (CGFloat)calculateHueDeltaWithStartHue:(CGFloat)s endHue:(CGFloat)e time:(CGFloat)t
{
    LOG(@"[hue calculation]start=%f, end=%f, time=%f", s, e, t);
    CGFloat end = (e < s) ? e + 1.0 : e;
    CGFloat diff = end - s;
    if (diff < 0.5)
    {
        LOG(@"[hue calculation]diff=%f - Clockwise rotation", diff);
        return diff / t;
    }
    else
    {
        LOG(@"[hue calculation]diff=%f - Counter-Clockwise rotation", diff);
        return (diff - 1.0) / t;
    }
}

@end
