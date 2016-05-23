//
//  CTTextStyle.h
//  排版引擎Demo
//
//  Created by Wayne on 16/5/12.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CTRunItem;

/**
 *  文本样式
 */
@interface CTTextStyle : NSObject

// 默认文本颜色
@property (nonatomic) UIColor *textColor;

// 默认文本字体
@property (nonatomic) UIFont *textFont;

// 字间距
@property (nonatomic) CGFloat fontSpace;

// 行间距
@property (nonatomic) CGFloat lineSpace;

// URL 颜色
@property (nonatomic) UIColor *URLColor;

// @ 的颜色
@property (nonatomic) UIColor *atColor;

// 话题 #...# 颜色
@property (nonatomic) UIColor *topicColor;

@end
