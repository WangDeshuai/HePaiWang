//
//  YuGaoXiangQingVC.m
//  DistributionQuery
//
//  Created by Macx on 16/12/1.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "YuGaoXiangQingVC.h"

@interface YuGaoXiangQingVC ()
@property(nonatomic,strong)UIView * view1;
@property(nonatomic,strong)UIView * view2;
@property(nonatomic,strong)UIView * view3;
@end

@implementation YuGaoXiangQingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"发布预告详情";
    [self CreatView1];
     [self CreatView2];
     [self CreatView3];
}
-(void)CreatView1{
    _view1=[UIView new];
    _view1.backgroundColor=[UIColor whiteColor];
    [self.view sd_addSubviews:@[_view1]];
    _view1.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,5);
    //label
    UILabel * namelabel =[UILabel new];
    namelabel.text=@"预告标题";
    namelabel.font=[UIFont systemFontOfSize:16];
    [_view1 sd_addSubviews:@[namelabel]];
    namelabel.sd_layout
    .leftSpaceToView(_view1,15)
    .topSpaceToView(_view1,15)
    .heightIs(20);
    [namelabel setSingleLineAutoResizeWithMaxWidth:120];
    //contenLabel
    UILabel * contentLabel =[UILabel new];
    contentLabel.text=_model.titleName;//@"瓷砖贴膜机 自动磨边机等机器设备一批拍卖公告";
    
    contentLabel.numberOfLines=0;
    contentLabel.alpha=.6;
    contentLabel.font=[UIFont systemFontOfSize:16];
    [_view1 sd_addSubviews:@[contentLabel]];
    contentLabel.sd_layout
    .leftSpaceToView(namelabel,10)
    .topEqualToView(namelabel)
    .rightSpaceToView(_view1,15)
    .autoHeightRatio(0);
    
    [_view1 setupAutoHeightWithBottomView:contentLabel bottomMargin:15];
    
    
}

-(void)CreatView2{
    _view2=[UIView new];
    _view2.backgroundColor=[UIColor whiteColor];
    [self.view sd_addSubviews:@[_view2]];
    _view2.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(_view1,5);
    //label
    UILabel * namelabel =[UILabel new];
    namelabel.text=@"资产处理人";
    namelabel.font=[UIFont systemFontOfSize:16];
    [_view2 sd_addSubviews:@[namelabel]];
    namelabel.sd_layout
    .leftSpaceToView(_view2,15)
    .topSpaceToView(_view2,15)
    .heightIs(20);
    [namelabel setSingleLineAutoResizeWithMaxWidth:120];
    //name
    UILabel * contentLabel1 =[UILabel new];
    contentLabel1.text=_model.yuGaoPeople;//@"大头旋";
    contentLabel1.numberOfLines=0;
    contentLabel1.alpha=.6;
    contentLabel1.font=[UIFont systemFontOfSize:16];
    [_view2 sd_addSubviews:@[contentLabel1]];
    contentLabel1.sd_layout
    .topEqualToView(namelabel)
    .rightSpaceToView(_view2,15)
    .heightIs(20);
    [contentLabel1 setSingleLineAutoResizeWithMaxWidth:220];
    
    //线条
    UIView * lineView =[UIView new];
    lineView.backgroundColor=BG_COLOR;
    [_view2 sd_addSubviews:@[lineView]];
    lineView.sd_layout
    .leftSpaceToView(_view2,0)
    .rightSpaceToView(_view2,0)
    .topSpaceToView(namelabel,15)
    .heightIs(1);

    //label2
    UILabel * namelabel2 =[UILabel new];
    namelabel2.text=@"预告内容";
    namelabel2.font=[UIFont systemFontOfSize:16];
    [_view2 sd_addSubviews:@[namelabel2]];
    namelabel2.sd_layout
    .leftSpaceToView(_view2,15)
    .topSpaceToView(lineView,15)
    .heightIs(20);
    [namelabel2 setSingleLineAutoResizeWithMaxWidth:120];
    //name2
    UILabel * contentLabel2 =[UILabel new];
    contentLabel2.text=_model.yuGaoContent;//@"大头大头大头大头大头大头大头旋大头大头大头旋大头大头大头旋大头大头大头旋大头大头大头旋大头大头大头旋";
    contentLabel2.numberOfLines=0;
    contentLabel2.alpha=.6;
    contentLabel2.font=[UIFont systemFontOfSize:16];
    [_view2 sd_addSubviews:@[contentLabel2]];
    contentLabel2.sd_layout
    .topSpaceToView(lineView,15)
    .rightSpaceToView(_view2,15)
    .leftSpaceToView(namelabel2,15)
    .autoHeightRatio(0);
   
    [_view2 setupAutoHeightWithBottomView:contentLabel2 bottomMargin:15];
    
    
}
-(void)CreatView3{
    _view3=[UIView new];
    _view3.backgroundColor=[UIColor whiteColor];
    [self.view sd_addSubviews:@[_view3]];
    _view3.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(_view2,5);
    //label
    UILabel * namelabel =[UILabel new];
    namelabel.text=@"预告图片";
    namelabel.font=[UIFont systemFontOfSize:16];
    [_view3 sd_addSubviews:@[namelabel]];
    namelabel.sd_layout
    .leftSpaceToView(_view3,15)
    .topSpaceToView(_view3,15)
    .heightIs(20);
    [namelabel setSingleLineAutoResizeWithMaxWidth:120];
    //图片
    UIImageView * imageview =[[UIImageView alloc]init];
   // imageview.image=[UIImage imageNamed:@"login_logo"];
    [imageview setImageWithURL:[NSURL URLWithString:_model.yuGaoImage] placeholderImage:[UIImage imageNamed:@"login_logo"]];
    [_view3 sd_addSubviews:@[imageview]];
    imageview.sd_layout
    .topSpaceToView(_view3,20)
    .leftSpaceToView(namelabel,10)
    .widthIs(153/2)
    .heightIs(204/2);
    [_view3 setupAutoHeightWithBottomView:imageview bottomMargin:15];
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
