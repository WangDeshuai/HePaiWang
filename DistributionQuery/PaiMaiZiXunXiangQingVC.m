//
//  PaiMaiZiXunXiangQingVC.m
//  DistributionQuery
//
//  Created by Macx on 16/12/2.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PaiMaiZiXunXiangQingVC.h"

@interface PaiMaiZiXunXiangQingVC ()

@end

@implementation PaiMaiZiXunXiangQingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"拍卖资讯详情";
    [self CreatView];
}


-(void)CreatView{
    UIView * view1 =[UIView new];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view sd_addSubviews:@[view1]];
    view1.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,5);
    //title
    UILabel * titleLabel =[UILabel new];
    titleLabel.text=@"拍卖时应如何理性应价";
    titleLabel.font=[UIFont  systemFontOfSize:19];
    titleLabel.alpha=.8;
    [view1 sd_addSubviews:@[titleLabel]];
    titleLabel.sd_layout
    .leftSpaceToView(view1,15)
    .topSpaceToView(view1,20)
    .heightIs(20);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:300];
    //时间
    UILabel * timeLabel =[UILabel new];
    timeLabel.text=@"2016-11-20";
    timeLabel.font=[UIFont  systemFontOfSize:15];
    timeLabel.alpha=.6;
    [view1 sd_addSubviews:@[timeLabel]];
    timeLabel.sd_layout
    .leftEqualToView(titleLabel)
    .topSpaceToView(titleLabel,15)
    .heightIs(20);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:300];
    
   
    UIView * lineView =[UIView new];
    lineView.backgroundColor=BG_COLOR;
    [view1 sd_addSubviews:@[lineView]];
    lineView.sd_layout
    .leftSpaceToView(view1,0)
    .rightSpaceToView(view1,0)
    .topSpaceToView(timeLabel,15)
    .heightIs(1);
    
    //内容
    
    UILabel * contentLabel =[UILabel new];
    contentLabel.text=@"19日下午，中央委员会中共中央总书记习近平参加了会议，在会议中习近平强调了以下几点，第一加强党的建设和发展第二19日下午，中央委员会中共中央总书记习近平参加了会议，在会议中习近平强调了以下几点，第一加强党的建设和发展第二19日下午，中央委员会中共中央总书记习近平参加了会议，在会议中习近平强调了以下几点，第一加强党的建设和发展第二";
 //   contentLabel.attributedText=[ToolClass hangJianJuStr:contentLabel.text JuLi:5];
    contentLabel.font=[UIFont  systemFontOfSize:15];
    contentLabel.alpha=.7;
    contentLabel.numberOfLines=0;
    [view1 sd_addSubviews:@[contentLabel]];
    contentLabel.sd_layout
    .leftEqualToView(titleLabel)
    .topSpaceToView(lineView,15)
    .rightSpaceToView(view1,0)
    .autoHeightRatio(0);
    
    [view1 setupAutoHeightWithBottomView:contentLabel bottomMargin:15];
    
    
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
