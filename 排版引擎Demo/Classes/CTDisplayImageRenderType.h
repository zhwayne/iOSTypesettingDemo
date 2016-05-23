//
//  CTDisplayImageRenderType.h
//  排版引擎Demo
//
//  Created by 张尉 on 16/5/13.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString * const kCTDisplayRenderType;
FOUNDATION_EXTERN NSString * const kCTDisplayRenderTypeFace;


FOUNDATION_EXTERN NSString * const kCTDisplayRenderTypeUserInfoFaceName;

@interface CTDisplayImageRenderType : NSObject

@property (copy, nonatomic) NSString *typeName;
@property (nonatomic) NSDictionary *userInfo;

- (instancetype)initWithDisplayTpye:(NSString *)aType;

- (void)renderWithCTRunAttributes:(NSDictionary *)runAttr
                           inRect:(CGRect)rect
                          context:(CGContextRef)ctx;

@end
