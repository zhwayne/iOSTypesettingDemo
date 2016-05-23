//
//  CTDisplayView+Draw.m
//  排版引擎Demo
//
//  Created by Wayne on 16/5/12.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import "CTDisplayView+Draw.h"
#import <CoreText/CoreText.h>
#import "CTTextStyle.h"
#import "CTTextParser.h"
#import "CTDisplayImageRenderType.h"


#pragma mark - 绘制一像素的线
#define SINGLE_LINE_WIDTH           (1.0 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1.0 / [UIScreen mainScreen].scale) / 2)
#define PX(x)                       (floor(x) - SINGLE_LINE_ADJUST_OFFSET)
#define PW(w)                       (w * SINGLE_LINE_WIDTH)



@implementation CTDisplayView (Draw)

- (void)drawContentInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    NSMutableAttributedString *mas = [self createAttributedStringWithString:self.text
                                                                      style:self.textStyle].mutableCopy;
    // 具体制定样式
    CTTextParser *textParser= [[CTTextParser alloc] init];
    [textParser parserWithAttributedString:mas style:self.textStyle];
    
    
    CGRect contentRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));//
    
    // 创建 CTFramesetterRef 实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mas);
    
    //创建一个用来描画文字的路径，其区域为当前视图的bounds  CGPath
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, contentRect);
    
    //创建由framesetter管理的frame，是描画文字的一个视图范围  CTFrame
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    // 文字和图片的绘制分离开，先画文字后画图
    [self drawLineWithFrame:frame context:ctx];
    [self drawImageWithFrame:frame context:ctx];
    
    CFRelease(path);
    CFRelease(frame);
    CFRelease(framesetter);
    CGContextRestoreGState(ctx);
}

#pragma mark - Private

- (void)drawLineWithFrame:(CTFrameRef)frame context:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    CFArrayRef lines = CTFrameGetLines(frame);
    CFIndex lineCount = CFArrayGetCount(lines);
    
    // 获取所有行的起始点
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    for (CFIndex i = 0; i < lineCount; ++i) {
        if (self.numberOfLines > 0 && i > self.numberOfLines) {
            break;
        }
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(runs);
        
        for (CFIndex j = 0; j < runCount; ++j) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
#define DRAW_DEBUG 0
#if DRAW_DEBUG == 1
            {
                CGFloat offset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                
                CGRect runBounds = CGRectZero;
                CGFloat runAscent;
                CGFloat runDescent;
                CGFloat runLeading;
                runBounds.size.width = CTRunGetTypographicBounds(run,
                                                                 CFRangeMake(0, 0),
                                                                 &runAscent,
                                                                 &runDescent,
                                                                 &runLeading);
                
                runBounds.size.height = runAscent + runDescent + runLeading;
                runBounds.origin.x = lineOrigins[i].x + offset;
                runBounds.origin.y = lineOrigins[i].y - runDescent;
                
                CGFloat lineWidth = PW(1);
                CGContextSetLineWidth(ctx, lineWidth);
                CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
                CGContextMoveToPoint(ctx,
                                     PX(lineOrigins[i].x),
                                     PX(lineOrigins[i].y));
                CGContextAddLineToPoint(ctx,
                                        PX(lineOrigins[i].x + (j + 1) * runBounds.size.width),
                                        PX(lineOrigins[i].y));
                CGContextStrokePath(ctx);
                
                
                CFIndex glyphCount = CTRunGetGlyphCount(run);
                CGGlyph glyphs[glyphCount];
                CGPoint glyphPositions[glyphCount];
                CTRunGetGlyphs(run, CFRangeMake(0, 0), glyphs);
                CTRunGetPositions(run, CFRangeMake(0, 0), glyphPositions);
                
                for (CFIndex m = 0; m < glyphCount; ++m) {
                    
                }
                
            }
#endif
#undef DRAW_DEBUG
            CGContextSetTextPosition(ctx,
                                     lineOrigins[i].x,
                                     lineOrigins[i].y);
            CTRunDraw(run, ctx, CFRangeMake(0, 0));
        }
        
    }

    // 或者使用：
    // CTFrameDraw(frame, ctx);
    CGContextRestoreGState(ctx);
}

- (void)drawImageWithFrame:(CTFrameRef)frame context:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    CFArrayRef lines = CTFrameGetLines(frame);
    CFIndex lineCount = CFArrayGetCount(lines);
    
    // 获取所有行的起始点
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    for (CFIndex i = 0; i < lineCount; ++i) {
        if (self.numberOfLines > 0 && i > self.numberOfLines) {
            break;
        }
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(runs);

        
        for (CFIndex j = 0; j < runCount; ++j) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);

            NSDictionary *runAttributes = (__bridge NSDictionary *)CTRunGetAttributes(run);
            
            CTRunDelegateRef runDelegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (runDelegate == nil) {
                continue;
            }
            
            //NSArray *metaDic = CTRunDelegateGetRefCon(runDelegate);
            //if (![metaDic isKindOfClass:[NSArray class]]) {
                //continue;
            //}
            
            CGFloat offset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            
            CGRect runBounds = CGRectZero;
            CGFloat runAscent;
            CGFloat runDescent;
            __unused CGFloat runLeading;
            runBounds.size.width = CTRunGetTypographicBounds(run,
                                                             CFRangeMake(0, 0),
                                                             &runAscent,
                                                             &runDescent,
                                                             NULL);
            
            // 获取 Run bounds
            runBounds.size.height = runAscent + runDescent;
            runBounds.origin.x = lineOrigins[i].x + offset;
            runBounds.origin.y = lineOrigins[i].y - runDescent;
            
            CGPathRef path = CTFrameGetPath(frame);
            CGRect colRect = CGPathGetBoundingBox(path);
            
            // 获取 Run delegate bounds
            CGRect delegateBounds = CGRectOffset(runBounds,
                                                 colRect.origin.x,
                                                 colRect.origin.y);
            
            [[[CTDisplayImageRenderType alloc] init] renderWithCTRunAttributes:runAttributes
                                                             inRect:delegateBounds
                                                            context:ctx];
            
//            CGFloat lineWidth = PW(1);
//            CGContextSetLineWidth(ctx, lineWidth);
//            CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//            CGContextAddRect(ctx, runBounds);
//            CGContextStrokePath(ctx);
        }
        
    }
    CGContextRestoreGState(ctx);
}


/**
 *  生成 基本的 Attributed String
 */
- (NSAttributedString *)createAttributedStringWithString:(NSString *)string
                                                   style:(CTTextStyle *)style
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    // 设置文本颜色
    attributes[(id)kCTForegroundColorAttributeName] = (id)style.textColor.CGColor;
    
    // 设置字体
    CTFontRef font = CTFontCreateWithName((CFStringRef)style.textFont.fontName,
                                          style.textFont.pointSize,
                                          NULL);
    attributes[(id)kCTFontAttributeName] = (__bridge id)font;
    
    // 设置字间距
    attributes[(id)kCTKernAttributeName] = @(style.fontSpace);
    
    // 设置行距，和换行模式
    const CFIndex kNumberOfSettings = 4;
    CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;
    CGFloat lineSpace = style.lineSpace;
    CTParagraphStyleSetting settings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpace},
        {kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode},
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, kNumberOfSettings);
    attributes[(id)kCTParagraphStyleAttributeName] = (__bridge id)paragraphStyle;
    
    CFRelease(font);
    CFRelease(paragraphStyle);
    
    return [[NSAttributedString alloc] initWithString:string
                                           attributes:attributes];
}

@end
