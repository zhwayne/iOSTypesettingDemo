//
//  ViewController2.m
//  排版引擎Demo
//
//  Created by 张尉 on 16/5/23.
//  Copyright © 2016年 Wayne. All rights reserved.
//

#import "ViewController2.h"
#import "CTDisplay.h"

@interface ViewController2 ()

@property (strong, nonatomic) CTDisplayView *displayView;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.displayView = [[CTDisplayView alloc] initWithFrame:CGRectMake(0, 64, 320, 320)];
    self.displayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.displayView];
    
    
    CTTextStyle *style = [[CTTextStyle alloc] init];
    self.displayView.textStyle = style;
    self.displayView.text = @"【#六宫粉黛无颜色，索尼 Xperia Z5 尊享版樱花粉图赏#】前不久正是樱[face]qq[/face]👺😄花盛开的时节， @索尼Xperia 推出了樱花粉索尼 Xperia Z5 尊享版，作为 2016 年流行色的粉色，与索尼 Xperia Z5 尊享版的碰撞，不得不说##真的是“淡妆浓抹总相宜”呢，请欣赏 @罗莱尔特 为大家带来的图赏：O六宫粉黛无颜色，索尼 Xperia Z5 尊享版樱花...[face]qq[/face]哈哈";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
