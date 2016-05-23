//
//  CTRunItem.h
//  排版引擎Demo
//
//  Created by Wayne on 16/5/13.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTRunItem : NSObject

@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat descender;

@property (nonatomic) CGRect position NS_UNAVAILABLE;

@end
