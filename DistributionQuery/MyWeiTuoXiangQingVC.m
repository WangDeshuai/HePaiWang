//
//  MyWeiTuoXiangQingVC.m
//  DistributionQuery
//
//  Created by Macx on 17/4/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MyWeiTuoXiangQingVC.h"
#import "JiaoGeGuanLiVC.h"//交割管理
#import "MingXiViewController.h"//交易明细
#import "HtmlViewController.h"
#import "MyWeiTuoBiaoDiModel.h"
#import "QueRenChengJiaoVC.h"//签字界面Html
@interface MyWeiTuoXiangQingVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView * view1;
@property(nonatomic,strong)UIView * view2;
@property(nonatomic,strong)UIView * view3;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)MyWeiTuoBiaoDiModel * model;
@end

@implementation MyWeiTuoXiangQingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"委托标的详情";
    self.view.backgroundColor=[UIColor whiteColor];
    NSArray * arr1 =@[@"交易明细",@"交割管理"];
    NSArray * arr2 =@[@"竞买须知",@"竞买公告",@"标的物介绍"];
    _dataArr=[[NSMutableArray alloc]initWithObjects:arr1,arr2, nil];
    [self CreatTableView];
    [self CreatButton];

}

#pragma mark --创建底部按钮
-(void)CreatButton{
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor redColor];
    [button setTitle:@"签订委托拍卖合同" forState:0];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    button.sd_cornerRadius=@(3);
    [button addTarget:self action:@selector(hetong) forControlEvents:UIControlEventTouchUpInside];
    [self.view sd_addSubviews:@[button]];
    button.sd_layout
    .widthIs(150)
    .heightIs(40)
    .bottomSpaceToView(self.view,5)
    .centerXEqualToView(self.view);
}
-(void)hetong{
    QueRenChengJiaoVC * vc =[QueRenChengJiaoVC new];
    vc.tagg=2;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --创建表
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-50) style:UITableViewStylePlain];
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
    
    NSString * cellID =[NSString stringWithFormat:@"%lu%lu",(long)indexPath.section,(long)indexPath.row];
    
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

#pragma mark --表格点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            //交易明细
            MingXiViewController * vc =[MingXiViewController new];
            vc.tagg=2;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //交割管理
            JiaoGeGuanLiVC * vc =[JiaoGeGuanLiVC new];
            vc.tagg=2;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if (indexPath.row==0) {
            //竞买须知
            HtmlViewController * vc =[HtmlViewController new];
            vc.str=_model.xqjingmai;
            [self.navigationController pushViewController:vc animated:YES];
        }else  if (indexPath.row==1){
            //竞买公告
            HtmlViewController * vc =[HtmlViewController new];
            vc.str=_model.xqgonggao;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //标的物介绍
            HtmlViewController * vc =[HtmlViewController new];
            vc.str=_model.xqjieshao;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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
    .topSpaceToView(self.view,0);
    
    if (ScreenWidth==414) {
        headView.sd_layout.heightIs(468);
    }else if (ScreenWidth==375){
        headView.sd_layout.heightIs(448);
    }else{
        headView.sd_layout.heightIs(418);
    }
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
    
    
    
    [Engine myWeiTuoXiangQingBiaoDiID:@"10" success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                if ([code isEqualToString:@"1"]) {
                    NSDictionary * dicc =[dic objectForKey:@"content"];
                    MyWeiTuoBiaoDiModel * md =[[MyWeiTuoBiaoDiModel alloc]initWithBiaoDiXiangQingDic:dicc];
                    _model=md;
                    //轮播图
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        cycleScrollView2.imageURLStringsGroup = md.xqImage;
                    });
                    //标题
                    titleLable.text=md.xqtitlename;
                    //起拍价
                    qiPaiJiaLable.text=[NSString stringWithFormat:@"起拍价：%@",md.xqprice];//@"起拍价：14万";
                    qiPaiJiaLable.attributedText= [ToolClass attrStrFrom:qiPaiJiaLable.text intFond:13 Color:[UIColor blackColor] numberStr:@"起拍价："];
                    //报名人数
                    baoming.text=[NSString stringWithFormat:@"%@报名人数",md.xqbaoming];
                    //提醒
                    tixingLabel.text=[NSString stringWithFormat:@"%@设置提醒",md.xqtixing];
                    //浏览次数
                    liuLanLabel.text=[NSString stringWithFormat:@"%@浏览次数",md.xqliulan];
                    //评估价
                    pinggujia.text=[NSString stringWithFormat:@"评估价:%@",md.xqpinggu];
                    //加价幅度
                    jiaLable.text=[NSString stringWithFormat:@"加价幅度:%@",md.xqjiajia];
                    //保证金
                    baozhengjin.text=[NSString stringWithFormat:@"保证金:%@",md.xqbaozhengjin];
                    //类型
                    typeLabel.text=[NSString stringWithFormat:@"类型:%@",md.xqleixing];
                    //自由竞价
                    ziyouLabel.text=[NSString stringWithFormat:@"自由竞价:%@",md.xqziyou];
                    //保留价
                    baoLiu.text=[NSString stringWithFormat:@"自由竞价:%@",md.xqbaoliujia];
                    //限时竞价
                    xianshiLabel.text=[NSString stringWithFormat:@"限时竞价:%@",md.xqxianshi];
                    //优先购买
                    youXian.text=[NSString stringWithFormat:@"优先购买权人:%@",md.xqyouxian];//@"优先购买权人:无";
                    [_tableView reloadData];
                }else{
                    [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
                }

    } error:^(NSError *error) {
        
    }];
    
    
    
    
    
    
    //还得找标的ID
//    [Engine mycenterMyBuyBiaoDiXiangQingBiaoDiID:@"10" success:^(NSDictionary *dic) {
//        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
//        if ([code isEqualToString:@"1"]) {
//            NSDictionary * dicc =[dic objectForKey:@"content"];
////            BuyBiaoDiModel * md =[[BuyBiaoDiModel alloc]initWithBiaoDiXiangQingDic:dicc];
//          //  _model=md;
//            //轮播图
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                cycleScrollView2.imageURLStringsGroup = md.xqImage;
//            });
//            //标题
//            titleLable.text=md.xqtitlename;
//            //起拍价
//            qiPaiJiaLable.text=[NSString stringWithFormat:@"起拍价：%@",md.xqprice];//@"起拍价：14万";
//            qiPaiJiaLable.attributedText= [ToolClass attrStrFrom:qiPaiJiaLable.text intFond:13 Color:[UIColor blackColor] numberStr:@"起拍价："];
//            //报名人数
//            baoming.text=[NSString stringWithFormat:@"%@报名人数",md.xqbaoming];
//            //提醒
//            tixingLabel.text=[NSString stringWithFormat:@"%@设置提醒",md.xqtixing];
//            //浏览次数
//            liuLanLabel.text=[NSString stringWithFormat:@"%@浏览次数",md.xqliulan];
//            //评估价
//            pinggujia.text=[NSString stringWithFormat:@"评估价:%@",md.xqpinggu];
//            //加价幅度
//            jiaLable.text=[NSString stringWithFormat:@"加价幅度:%@",md.xqjiajia];
//            //保证金
//            baozhengjin.text=[NSString stringWithFormat:@"保证金:%@",md.xqbaozhengjin];
//            //类型
//            typeLabel.text=[NSString stringWithFormat:@"类型:%@",md.xqleixing];
//            //自由竞价
//            ziyouLabel.text=[NSString stringWithFormat:@"自由竞价:%@",md.xqziyou];
//            //保留价
//            baoLiu.text=[NSString stringWithFormat:@"自由竞价:%@",md.xqbaoliujia];
//            //限时竞价
//            xianshiLabel.text=[NSString stringWithFormat:@"限时竞价:%@",md.xqxianshi];
//            //优先购买
//            youXian.text=[NSString stringWithFormat:@"优先购买权人:%@",md.xqyouxian];//@"优先购买权人:无";
//            [_tableView reloadData];
//        }else{
//            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
//        }
//    } error:^(NSError *error) {
//        
//    }];
    
    
    return headView;
}




-(void)LabelShuXing:(UILabel*)lab{
    lab.alpha=.6;
    lab.font=[UIFont systemFontOfSize:13];
    
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
