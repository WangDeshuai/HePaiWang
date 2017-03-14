//
//  HtmlViewController.m
//  DistributionQuery
//
//  Created by Macx on 17/3/14.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "HtmlViewController.h"

@interface HtmlViewController ()

@end

@implementation HtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"公告详情";
    NSLog(@"输出>>>%@",_str);
    
    UILabel * gongGaoXiangQing =[UILabel new];
    gongGaoXiangQing.font=[UIFont systemFontOfSize:16];
    gongGaoXiangQing.alpha=.6;
//    gongGaoXiangQing.text=_str;
    gongGaoXiangQing.attributedText=[ToolClass HTML:_str];
    [self.view sd_addSubviews:@[gongGaoXiangQing]];
    gongGaoXiangQing.sd_layout
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .topSpaceToView(self.view,20)
    .autoHeightRatio(0);
    
    
    
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
