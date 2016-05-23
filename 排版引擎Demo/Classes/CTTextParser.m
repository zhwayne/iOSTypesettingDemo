//
//  CTTextParser.m
//  排版引擎Demo
//
//  Created by Wayne on 16/5/13.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import "CTDisplayImageRenderType.h"
#import "CTRunItem.h"
#import "CTTextParser.h"
#import "CTTextParserDelegate.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>


static NSMutableArray <Class>*parsers = nil;


@interface CTTextParser ()

@property (nonatomic) CTTextStyle *runStyle;
@property (nonatomic) CTRunItem *runItem;
@property (nonatomic, weak) NSMutableAttributedString *attrString;

@end


@implementation CTTextParser

+ (void)initialize
{
    if (parsers != nil) {
        [parsers removeAllObjects];
        parsers = nil;
    }
    
    int classCount = objc_getClassList(NULL, 0);
    
    if (classCount <= 0) return;
    
    parsers = [NSMutableArray array];
    
    Class *classes = (Class *) malloc(sizeof(Class) * classCount);
    objc_getClassList(classes, classCount);
    
    for (int i = 0; i < classCount; ++i) {
        @autoreleasepool {
            if (!class_conformsToProtocol(classes[i], @protocol(CTTextParserDelegate))) {
                continue;
            }
            
            if (!class_respondsToSelector(classes[i], @selector(parserWithAttributedString:style:))) {
                continue;
            }
            
            [parsers addObject:classes[i]];
        }
    }
    
    NSLog(@"%@", parsers);
    
    free(classes);
}

- (void)parserWithAttributedString:(NSMutableAttributedString *)attributedString style:(CTTextStyle *)style
{
    _runStyle = style;
    _attrString = attributedString;
    
    ////////////////////
    [parsers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            [[[obj alloc] init] parserWithAttributedString:attributedString style:style];
        }
    }];
}



@end
