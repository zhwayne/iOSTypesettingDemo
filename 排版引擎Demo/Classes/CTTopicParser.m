//
//  CTTopicTextParser.m
//  排版引擎Demo
//
//  Created by 张尉 on 16/5/23.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import "CTTopicParser.h"
#import <CoreText/CoreText.h>

@implementation CTTopicParser 

- (void)parserWithAttributedString:(NSMutableAttributedString *)attributedString style:(CTTextStyle *)style {
    NSError *error = nil;
    NSString *regulaStr = @"#.*?#";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    if (error) {
        return;
    }
    
    NSArray *arrayOfAllMatches = [regex matchesInString:attributedString.string
                                                options:0
                                                  range:NSMakeRange(0, [attributedString length])];
    
    for (NSTextCheckingResult *res in arrayOfAllMatches) {
        
        NSAttributedString *matchString = [attributedString attributedSubstringFromRange:res.range];
        
        NSMutableAttributedString *replacementMAS = [[NSMutableAttributedString alloc] initWithAttributedString:matchString];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)replacementMAS,
                                       CFRangeMake(0, replacementMAS.length),
                                       (kCTForegroundColorAttributeName),
                                       (__bridge CFTypeRef)(style.topicColor));
        
        [attributedString replaceCharactersInRange:res.range withAttributedString:replacementMAS];
    }
}

@end
