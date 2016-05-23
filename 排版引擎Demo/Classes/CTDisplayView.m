//
//  CTDisplayView.m
//  排版引擎Demo
//
//  Created by Wayne on 16/5/12.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import "CTDisplayView.h"
#import "CTTextStyle.h"
#import "CTDisplayView+Draw.h"

@implementation CTDisplayView

#pragma mark - Property

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (void)setTextStyle:(CTTextStyle *)textStyle
{
    _textStyle = textStyle;
    [self setNeedsDisplay];
}


#pragma mark - Override

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    [self drawContentInContext:ctx];
}


@end
