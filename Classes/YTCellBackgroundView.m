//
//  YTCellBackgroundView.m
//  YourTurn
//
//  Created by Masashi Ono on 09/07/06.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTCellBackgroundView.h"


@implementation YTCellBackgroundView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 1.0,  // Start color
    0.79, 0.79, 0.79, 1.0 }; // End color
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(colorSpace, components,
                                                   locations, num_locations);
    CGPoint startPoint = CGPointMake(self.frame.size.width/2, 0.0);
    CGPoint endPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}


- (void)dealloc
{
    [super dealloc];
}


@end
