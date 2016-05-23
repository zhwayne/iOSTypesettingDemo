//
//  CTTextParser.h
//  排版引擎Demo
//
//  Created by Wayne on 16/5/13.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTTextStyle.h"

@interface CTTextParser : NSObject

- (void)parserWithAttributedString:(NSMutableAttributedString *)attributedString style:(CTTextStyle *)style;

@end
