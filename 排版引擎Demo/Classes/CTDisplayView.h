//
//  CTDisplayView.h
//  排版引擎Demo
//
//  Created by Wayne on 16/5/12.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTTextStyle;

@interface CTDisplayView : UIView

@property (copy, nonatomic) NSString *text;

@property (nonatomic) CTTextStyle *textStyle;

@property (nonatomic) NSInteger numberOfLines;

@end
