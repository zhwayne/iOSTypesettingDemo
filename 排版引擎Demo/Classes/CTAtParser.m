//
//  CTAtTextParser.m
//  排版引擎Demo
//
//  Created by 张尉 on 16/5/23.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import "CTAtParser.h"
#import <CoreText/CoreText.h>

@implementation CTAtParser 

- (void)parserWithAttributedString:(NSMutableAttributedString *)attributedString style:(CTTextStyle *)style {
    NSError *error = nil;
    NSString *regulaStr = @"\\s@\\S*?\\s";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    if (error) {
        return;
    }
    
    NSArray *arrayOfAllMatches = [regex matchesInString:attributedString.string
                                                options:0
                                                  range:NSMakeRange(0, [attributedString length])];
    
    /**
     * 每一次替换，range 都会向左偏移两个字符长度，造成误差，所以需要修正。
     */
    NSUInteger offset = 0;
    for (NSTextCheckingResult *res in arrayOfAllMatches) {
        NSRange newRange = NSMakeRange(res.range.location - offset, res.range.length);
        
        NSUInteger spaceCount = 2;
        
        NSAttributedString *matchString = [attributedString attributedSubstringFromRange:newRange];
        NSAttributedString *content = [matchString attributedSubstringFromRange:NSMakeRange(1, matchString.length - spaceCount)];
        
        NSMutableAttributedString *replacementMAS = [[NSMutableAttributedString alloc] initWithAttributedString:content];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)replacementMAS,
                                       CFRangeMake(0, replacementMAS.length),
                                       (kCTForegroundColorAttributeName),
                                       (__bridge CFTypeRef)style.atColor);
        
        [attributedString replaceCharactersInRange:newRange withAttributedString:replacementMAS];
        offset += spaceCount;
    }
}

@end
