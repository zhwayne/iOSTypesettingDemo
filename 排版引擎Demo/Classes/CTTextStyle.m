//
//  CTTextStyle.m
//  排版引擎Demo
//
//  Created by Wayne on 16/5/12.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import "CTTextStyle.h"

@implementation CTTextStyle

- (instancetype)init
{
    if (self = [super init]) {
        _textColor = [UIColor blackColor];
        _textFont = [UIFont systemFontOfSize:16];
        _fontSpace = 0;
        _lineSpace = 0;
        _URLColor = [UIColor colorWithRed:0.4 green:0.6 blue:1.0 alpha:1.0];
        _atColor = [UIColor colorWithRed:0.4 green:0.6 blue:1.0 alpha:1.0];
        _topicColor = [UIColor colorWithRed:0.4 green:0.6 blue:1.0 alpha:1.0];
    }
    
    return self;
}

#pragma mark - Property


@end
