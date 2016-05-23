//
//  ViewController.m
//  排版引擎Demo
//
//  Created by Wayne on 16/5/12.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[ViewController2 new] animated:YES];
}

@end
