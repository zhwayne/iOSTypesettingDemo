//
//  CTTextParserDelegate.h
//  排版引擎Demo
//
//  Created by 张尉 on 16/5/15.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTTextStyle.h"


@protocol CTTextParserDelegate <NSObject>

@required
- (void)parserWithAttributedString:(NSMutableAttributedString *)attributedString
                             style:(CTTextStyle *)style;

@end
