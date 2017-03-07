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
    [self CreatTime];
}
-(void)getData{
    ;
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
    
    UILabel * contentLabel =[UILabel new];
    contentLabel.backgroundColor=[UIColor whiteColor];
    contentLabel.alpha=.7;
    contentLabel.text=@"您已参加稍后拍卖会，保证金马上到账您已参加稍后拍卖会，保证金马上到账您已参加稍后拍卖会，保证金马上到账您已参加稍后拍卖会，保证金马上到账您已参加稍后拍卖会，保证金马上到账";
    [self.view sd_addSubviews:@[contentLabel]];
    contentLabel.sd_layout
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .topSpaceToView(timeLabel,20)
    .autoHeightRatio(0);
    
    [Engine messageViewMessageID:_model.messageID success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * dicc =[dic objectForKey:@"content"];
            timeLabel.text=[dicc objectForKey:@"send_time"];
            contentLabel.text=[dicc objectForKey:@"message_content"];
        }
    } error:^(NSError *error) {
        
    }];
    
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
