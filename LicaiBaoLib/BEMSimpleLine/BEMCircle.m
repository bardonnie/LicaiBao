//
//  BEMCircle.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//

#import "BEMCircle.h"

@implementation BEMCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // 点颜色
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    [UIColorFromRGB(0xffc955) set];
    CGContextFillPath(ctx);
}

@end