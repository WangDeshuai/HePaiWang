//
//  BuyXiangQingVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BuyXiangQingVC.h"

@interface BuyXiangQingVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView * view1;
@property(nonatomic,strong)UIView * view2;
@property(nonatomic,strong)UIView * view3;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation BuyXiangQingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我已买到的标的详情";
    NSArray * arr1 =@[@"交易明细",@"交割管理"];
      NSArray * arr2 =@[@"竞买须知",@"竞买公告",@"标的物介绍"];
    _dataArr=[[NSMutableArray alloc]initWithObjects:arr1,arr2, nil];
    [self CreatTableView];
   
}
#pragma mark --创建表
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    _tableView.backgroundColor=BG_COLOR;
    _tableView.tableHeaderView=[self CreatTableHeadView];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellID =[NSString stringWithFormat:@"%lu%lu",indexPath.section,indexPath.row];
    
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text=_dataArr[indexPath.section][indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.alpha=.6;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
      return 10;
    }
}
-(UIView*)CreatTableHeadView{
    UIView * headView =[UIView new];
    headView.backgroundColor=BG_COLOR;
    
    headView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(438+10);
    _view1=[UIView new];
    _view1.backgroundColor=[UIColor whiteColor];
    
    [headView addSubview:_view1];
    _view1.sd_layout
    .leftSpaceToView(headView,0)
    .topSpaceToView(headView,0)
    .rightSpaceToView(headView,0);
    
    
    
    //轮播图
    NSArray * arr =@[@"banner",@"banner"];
    SDCycleScrollView*  cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 540*ScreenWidth/1080) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor];
    [headView addSubview:cycleScrollView2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = arr;
    });
    cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
        // NSLog(@">>>>>  %ld", (long)index);
        
    };
    
    
    
    //标题
    UILabel * titleLable =[UILabel new];
    titleLable.text=@"出售183*7米的青岛产球磨机";
    titleLable.alpha=.8;
    titleLable.numberOfLines=0;
    [_view1 sd_addSubviews:@[titleLable]];
    titleLable.sd_layout
    .leftSpaceToView(_view1,15)
    .topSpaceToView(cycleScrollView2,15)
    .autoHeightRatio(0);
    [titleLable setSingleLineAutoResizeWithMaxWidth:300];
    //起拍价
    UILabel * qiPaiJiaLable =[UILabel new];
    qiPaiJiaLable.text=@"起拍价：14万";
    qiPaiJiaLable.textColor=[UIColor redColor];
    qiPaiJiaLable.font=[UIFont systemFontOfSize:18];
    qiPaiJiaLable.attributedText= [ToolClass attrStrFrom:qiPaiJiaLable.text intFond:13 Color:[UIColor blackColor] numberStr:@"起拍价："];
    qiPaiJiaLable.alpha=.6;
    
    [_view1 sd_addSubviews:@[qiPaiJiaLable]];
    qiPaiJiaLable.sd_layout
    .leftEqualToView(titleLable)
    .topSpaceToView(titleLable,10)
    .heightIs(20)
    .widthIs(120);
    //[qiPaiJiaLable setSingleLineAutoResizeWithMaxWidth:300];
    //报名人数
    UILabel * baoming =[UILabel new];
    baoming.text=@"45人报名";
    baoming.alpha=.6;
    baoming.font=[UIFont systemFontOfSize:13];
    [_view1 sd_addSubviews:@[baoming]];
    baoming.sd_layout
    .leftEqualToView(qiPaiJiaLable)
    .topSpaceToView(qiPaiJiaLable,10)
    .heightIs(20);
    [baoming setSingleLineAutoResizeWithMaxWidth:200];
    //提醒
    UILabel * tixingLabel =[UILabel new];
    tixingLabel.text=@"0人设置提醒";
    tixingLabel.alpha=.6;
    tixingLabel.font=[UIFont systemFontOfSize:13];
    [_view1 sd_addSubviews:@[tixingLabel]];
    tixingLabel.sd_layout
    .centerYEqualToView(baoming)
    .leftSpaceToView(baoming,30)
    .heightIs(20);
    [tixingLabel setSingleLineAutoResizeWithMaxWidth:200];
    //浏览次数
    UILabel * liuLanLabel =[UILabel new];
    liuLanLabel.text=@"45人浏览";
    liuLanLabel.alpha=.6;
    liuLanLabel.font=[UIFont systemFontOfSize:13];
    [_view1 sd_addSubviews:@[liuLanLabel]];
    liuLanLabel.sd_layout
    .centerYEqualToView(baoming)
    .leftSpaceToView(tixingLabel,30)
    .heightIs(20);
    [liuLanLabel setSingleLineAutoResizeWithMaxWidth:200];
//    //开拍提醒
//    UIButton * tixingBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [tixingBtn setBackgroundImage:[UIImage imageNamed:@"biaodi_bt1"] forState:0];
//    // [tixingBtn addTarget:self action:@selector(wangji) forControlEvents:UIControlEventTouchUpInside];
//    [_view1 sd_addSubviews:@[tixingBtn]];
//    tixingBtn.sd_layout
//    .rightSpaceToView(_view1,20)
//    .topEqualToView(titleLable)
//    .widthIs(100/2)
//    .heightIs(78/2);
    [_view1 setupAutoHeightWithBottomView:liuLanLabel bottomMargin:10];
    //view2
    _view2=[UIView new];
    _view2.backgroundColor=[UIColor whiteColor];
    [headView sd_addSubviews:@[_view2]];
    _view2.sd_layout
    .leftSpaceToView(headView,0)
    .rightSpaceToView(headView,0)
    .topSpaceToView(_view1,10);
    //评估价
    UILabel * pinggujia =[UILabel new];
    pinggujia.text=@"评估价:1万";
    [self LabelShuXing:pinggujia];
    [_view2 sd_addSubviews:@[pinggujia]];
    pinggujia.sd_layout
    .leftSpaceToView(_view2,15)
    .topSpaceToView(_view2,15)
    .heightIs(20);
    [pinggujia setSingleLineAutoResizeWithMaxWidth:200];
    //加价幅度
    UILabel * jiaLable =[UILabel new];
    jiaLable.text=@"加价幅度:5000元";
    [self LabelShuXing:jiaLable];
    [_view2 sd_addSubviews:@[jiaLable]];
    jiaLable.sd_layout
    .leftSpaceToView(pinggujia,100)
    .centerYEqualToView(pinggujia)
    .heightIs(20);
    [jiaLable setSingleLineAutoResizeWithMaxWidth:200];
    //保证金
    UILabel * baozhengjin =[UILabel new];
    baozhengjin.text=@"保证金:1万";
    [self LabelShuXing:baozhengjin];
    [_view2 sd_addSubviews:@[baozhengjin]];
    baozhengjin.sd_layout
    .leftEqualToView(pinggujia)
    .topSpaceToView(pinggujia,10)
    .heightIs(20);
    [baozhengjin setSingleLineAutoResizeWithMaxWidth:200];
    //类型
    UILabel * typeLabel =[UILabel new];
    typeLabel.text=@"类型:机动车拍卖";
    [self LabelShuXing:typeLabel];
    [_view2 sd_addSubviews:@[typeLabel]];
    typeLabel.sd_layout
    .leftEqualToView(jiaLable)
    .centerYEqualToView(baozhengjin)
    .heightIs(20);
    [typeLabel setSingleLineAutoResizeWithMaxWidth:200];
    //自由竞价
    UILabel * ziyouLabel =[UILabel new];
    ziyouLabel.text=@"自由竞价:1万";
    [self LabelShuXing:ziyouLabel];
    [_view2 sd_addSubviews:@[ziyouLabel]];
    ziyouLabel.sd_layout
    .leftEqualToView(baozhengjin)
    .topSpaceToView(baozhengjin,10)
    .heightIs(20);
    [ziyouLabel setSingleLineAutoResizeWithMaxWidth:200];
    //保留价
    UILabel * baoLiu =[UILabel new];
    baoLiu.text=@"保留价:无";
    [self LabelShuXing:baoLiu];
    [_view2 sd_addSubviews:@[baoLiu]];
    baoLiu.sd_layout
    .leftEqualToView(typeLabel)
    .centerYEqualToView(ziyouLabel)
    .heightIs(20);
    [baoLiu setSingleLineAutoResizeWithMaxWidth:200];
    //限时竞价
    UILabel * xianshiLabel =[UILabel new];
    xianshiLabel.text=@"限时竞价:1万";
    [self LabelShuXing:xianshiLabel];
    [_view2 sd_addSubviews:@[xianshiLabel]];
    xianshiLabel.sd_layout
    .leftEqualToView(ziyouLabel)
    .topSpaceToView(ziyouLabel,10)
    .heightIs(20);
    [xianshiLabel setSingleLineAutoResizeWithMaxWidth:200];
    //优先购买
    UILabel * youXian =[UILabel new];
    youXian.text=@"优先购买权人:无";
    [self LabelShuXing:youXian];
    [_view2 sd_addSubviews:@[youXian]];
    youXian.sd_layout
    .leftEqualToView(baoLiu)
    .centerYEqualToView(xianshiLabel)
    .heightIs(20);
    [youXian setSingleLineAutoResizeWithMaxWidth:200];
    [_view2 setupAutoHeightWithBottomView:youXian bottomMargin:10];
    [headView setupAutoHeightWithBottomView:_view2 bottomMargin:10];
    
    //    _view2.didFinishAutoLayoutBlock=^(CGRect rect){
    //        NSLog(@"输出左边%f",rect.size.height+rect.origin.y);
    //    };
    
    
    return headView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)LabelShuXing:(UILabel*)lab{
    lab.alpha=.6;
    lab.font=[UIFont systemFontOfSize:13];
    
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
