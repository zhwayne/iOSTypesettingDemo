//
//  CTFaceParser.m
//  排版引擎Demo
//
//  Created by 张尉 on 16/5/23.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import "CTDisplayImageRenderType.h"
#import "CTFaceParser.h"
#import "CTRunItem.h"
#import <CoreText/CoreText.h>


@implementation CTFaceParser

- (void)parserWithAttributedString:(NSMutableAttributedString *)attributedString style:(CTTextStyle *)style {
    NSMutableString * attStr = attributedString.mutableString;
    NSError *error = nil;
    NSString *regulaStr = @"\\[face\\]\\S*?\\[/face\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    if (error) {
        return;
    }
    
    NSArray *arrayOfAllMatches = [regex matchesInString:attStr
                                                options:0
                                                  range:NSMakeRange(0, [attStr length])];
    
    
    NSUInteger offset = 0;
    for (NSTextCheckingResult *res in arrayOfAllMatches) {
        NSRange newRange = NSMakeRange(res.range.location - offset, res.range.length);
        
        NSString *matchString = [attStr substringWithRange:newRange];
        NSArray *subs = [matchString componentsSeparatedByString:@"[face]"];
        if ([subs count] != 2) {
            continue;
        }
        
        subs = [subs[1] componentsSeparatedByString:@"[/face]"];
        
        NSString *content = [subs firstObject];
        
        // 替换这部分的文本为占位符
        unichar objectReplacementChar = 0xFFFC;
        NSString *replacementString = [NSString stringWithCharacters:&objectReplacementChar length:1];
        NSMutableAttributedString *replacementMAS = [[NSMutableAttributedString alloc] initWithString:replacementString];
        
        CTRunDelegateCallbacks callbacks;
        memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
        callbacks.version = kCTRunDelegateVersion1;
        callbacks.getAscent = CTRunDelegateAscentCallback;
        callbacks.getDescent = CTRunDelegateDescentCallback;
        callbacks.getWidth = CTRunDelegateWidthCallback;
        callbacks.dealloc = CTRunDelegateDeallocCallback;
        
        CTRunItem *runItem = [[CTRunItem alloc] init];
        //item.size = CGSizeMake(style.textFont.ascender,
        //                               style.textFont.ascender - fabs(style.textFont.descender / 2));
        //item.descender = fabs(style.textFont.descender / 2);
        
        //item.size = CGSizeMake(style.textFont.ascender + fabs(style.textFont.descender),
        //                               style.textFont.ascender);
        //item.descender = fabs(style.textFont.descender);
        
        runItem.size = CGSizeMake(style.textFont.ascender + fabs(style.textFont.descender / 4),
                               style.textFont.ascender - fabs(style.textFont.descender / 4));
        runItem.descender = fabs(style.textFont.descender / 2);
        CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (void *)CFBridgingRetain(runItem));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)replacementMAS,
                                       CFRangeMake(0, 1),
                                       kCTRunDelegateAttributeName,
                                       delegate);
        CFRelease(delegate);
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[kCTDisplayRenderTypeUserInfoFaceName] = content;
        
        CTDisplayImageRenderType *displayType = [[CTDisplayImageRenderType alloc] initWithDisplayTpye:kCTDisplayRenderTypeFace];
        displayType.userInfo = dict;
        
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)replacementMAS,
                                       CFRangeMake(0, 1),
                                       ((__bridge CFStringRef)kCTDisplayRenderType),
                                       (__bridge CFTypeRef)displayType);
        
        [attributedString replaceCharactersInRange:newRange withAttributedString:replacementMAS];
        
        //// 删除了13个固定字符和 content
        offset += (13 + content.length - 1);
    }
}


#pragma mark - CTRunDelegateCallbacks

static void CTRunDelegateDeallocCallback(void *ref)
{
    CTRunItem *item = (__bridge CTRunItem *)ref;
    item = nil;
}

static CGFloat CTRunDelegateAscentCallback(void *ref)
{
    CTRunItem *item = (__bridge CTRunItem *)ref;
    return item.size.height;
}


static CGFloat CTRunDelegateDescentCallback(void *ref)
{
    CTRunItem *item = (__bridge CTRunItem *)ref;
    return item.descender;
}

static CGFloat CTRunDelegateWidthCallback(void *ref)
{
    CTRunItem *item = (__bridge CTRunItem *)ref;
    return item.size.width;
}


@end
