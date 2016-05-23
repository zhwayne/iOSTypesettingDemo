//
//  CTDisplayImageRenderType.m
//  排版引擎Demo
//
//  Created by 张尉 on 16/5/13.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import "CTDisplayImageRenderType.h"

#pragma mark - Types

NSString * const kCTDisplayRenderType = @"kCTDisplayRenderType";
NSString * const kCTDisplayRenderTypeFace = @"kCTDisplayRenderTypeFace";


NSString * const kCTDisplayRenderTypeUserInfoFaceName = @"kCTDisplayRenderTypeUserInfoFaceName";


@implementation CTDisplayImageRenderType

- (instancetype)initWithDisplayTpye:(NSString *)aType
{
    if (self = [super init]) {
        _typeName = aType;
    }
    
    return self;
}


- (void)renderWithCTRunAttributes:(NSDictionary *)runAttr
                           inRect:(CGRect)rect
                          context:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    CTDisplayImageRenderType *displayType = [runAttr objectForKey:kCTDisplayRenderType];
    
    if ([displayType.typeName isEqualToString:kCTDisplayRenderTypeFace]) {
        
        NSString *imageName = [displayType.userInfo objectForKey:kCTDisplayRenderTypeUserInfoFaceName];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        CGImageRef image = [UIImage imageWithContentsOfFile:imagePath].CGImage;
        CGContextDrawImage(ctx, rect, image);
    }
    CGContextRestoreGState(ctx);
}

@end
