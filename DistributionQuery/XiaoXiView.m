//
//  XiaoXiView.m
//  DistributionQuery
//
//  Created by Macx on 17/3/2.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "XiaoXiView.h"

@interface XiaoXiView ()

@end

@implementation XiaoXiView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"详情页";
}
-(void)CreatTime{
    UILabel * timeLabel =[UILabel new];
    timeLabel.text=@"2016-11-24 10:00";
    timeLabel.textColor=[UIColor redColor];
    [self.view sd_addSubviews:@[timeLabel]];
    timeLabel.sd_layout
    .centerXEqualToView(self.view)
    .heightIs(20)
    .topSpaceToView(self.view,15);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:200];
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
