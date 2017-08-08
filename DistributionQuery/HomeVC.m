//
//  HomeVC.m
//  DistributionQuery
//
//  Created by Macx on 16/10/8.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "HomeVC.h"
#import "PaiMaiBiaoDiVC.h"
#import "PaiMaiGongGaoVC.h"
#import "PaiMaiZiXunVC.h"
#import "ChengJiaoAnLiVC.h"
#import "PaiMaiBiaoDiModel.h"//拍卖标的model(横着的滚动图用)
#import "PaiMaiGongGaoModel.h"//拍卖公告model(table用)
#import "PaiMaiGongGaoXiangQingVC.h"//拍卖公告详情
#import "PaiMaiBiaoDiXiangQingVC.h"//拍卖标的详情
@interface HomeVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UIView * headView;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, strong) MJRefreshComponent *myRefreshView;
@property(nonatomic,assign)int AAA;
@property(nonatomic,strong)NSMutableArray * paiMaiBiaoDiArr;//存放拍卖标的的model
@end

@implementation HomeVC
-(void)viewWillAppear:(BOOL)animated
{
    self.textHomeField.text=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.backHomeBtn.hidden=YES;
    // Do any additional setup after loading the view.
    _dataArray=[NSMutableArray new];
    _paiMaiBiaoDiArr=[NSMutableArray new];
   
    NSLog(@">>>%f",ScreenWidth);
    
    
//    if ([ToolClass versionGenXinAppID:@"1246651525"]==YES) {
//        UIAlertController * actionView =[UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSUSE_DEFO objectForKey:@"更新内容"] preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction * action1 =[UIAlertAction actionWithTitle:@"立即更新" style:0 handler:^(UIAlertAction * _Nonnull action) {
//            //跳转到AppStore
//            NSString  *urlStr = @"https://itunes.apple.com/us/app/%E5%92%8C%E6%8B%8D%E7%BD%91/id1246651525?mt=8";
//            NSURL *url = [NSURL URLWithString:urlStr];
//            
//            [[UIApplication sharedApplication]openURL:url];
//            
//        }];
//        UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"稍后更新" style:0 handler:nil];
//        [actionView addAction:action2];
//        [actionView addAction:action1];
//        [self presentViewController:actionView animated:YES completion:nil];
//    }else{
//        [NSUSE_DEFO removeObjectForKey:@"更新内容"];
//        [NSUSE_DEFO synchronize];
//    }
//
    
    
    [self.navigationItem setTitle:@""];
    [self CreatNavBtn];
    [self CreatTableView];
}

#pragma mark --创建导航条按钮
-(void)CreatNavBtn{
    UIButton * logoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn.frame=CGRectMake(0, 0, 146/2, 50);
    logoBtn.showsTouchWhenHighlighted=NO;
    [logoBtn setImage:[UIImage imageNamed:@"logo"] forState:0];
    UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithCustomView:logoBtn];
    UIButton * logoBtn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn2.frame=CGRectMake(0, 0, 5, 47/2);
    
    UIBarButtonItem *leftBtn2 =[[UIBarButtonItem alloc]initWithCustomView:logoBtn2];

    self.navigationItem.leftBarButtonItems=@[leftBtn,leftBtn2];
    self.textHomeField.hidden=NO;
    self.textHomeField.delegate=self;
//    self.textHomeField.frame=CGRectMake(0, 0, ScreenWidth-150, 30);
    
}

#pragma mark --解析表格数据
-(void)jieXiDataPage:(int)page{
    [Engine upDataPaiMaiPublicViewSearchStr:@"" BiaoDiLeiXing:@"" ProvCode:@"" CityCode:@"" BeginTime:@"" Page:[NSString stringWithFormat:@"%d",page] PageSize:@"10" success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray * contentArr =[dic objectForKey:@"content"];
            NSMutableArray * array2 =[NSMutableArray new];
            for (NSDictionary * dicc in contentArr) {
                PaiMaiGongGaoModel * md =[[PaiMaiGongGaoModel alloc]initWithPaiMaiPublicDic:dicc];
                [array2 addObject:md];
            }
            
            if (self.myRefreshView ==_tableView.header) {
                _dataArray=array2;
                _tableView.footer.hidden=_dataArray.count==0?YES:NO;
            }else if (self.myRefreshView == _tableView.footer){
                [_dataArray addObjectsFromArray:array2];
            }
            [_tableView reloadData];
            [_myRefreshView  endRefreshing];
            
            
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];

        }
    } error:^(NSError *error) {
        
    }];
}

#pragma mark --区头
-(UIView*)CreatView1{
    _headView=[UIView new];
    _headView.backgroundColor=BG_COLOR;
    //[self.view sd_addSubviews:@[_headView]];
    _headView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0);
    NSArray * arr=@[@"banner"];
    //轮播图540*ScreenWidth/1080
    SDCycleScrollView*  cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 64+50) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    [_headView addSubview:cycleScrollView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = arr;
    });
    cycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
        // NSLog(@">>>>>  %ld", (long)index);
        
    };
    [Engine huoQuFirstLunBoImageArrsuccess:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray * contentArr =[dic objectForKey:@"content"];
            NSMutableArray * array2 =[NSMutableArray new];
            for (NSDictionary * dicc in contentArr) {
                [array2 addObject:[dicc objectForKey:@"imgUrl"]];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cycleScrollView.imageURLStringsGroup = array2;
            });
            
        }
    } error:^(NSError *error) {
        
    }];
    
    //4个btn
    UIView * view1 =[UIView new];
    view1.backgroundColor=[UIColor whiteColor];
    [_headView sd_addSubviews:@[view1]];
    view1.sd_layout
    .leftSpaceToView(_headView,0)
    .rightSpaceToView(_headView,0)
    .topSpaceToView(cycleScrollView,10);
    NSArray * imageBtnArr =@[@"home_bt1",@"home_bt2",@"home_bt3",@"home_bt4"];
    //100  134
    int d =(ScreenWidth-50*4)/5;
    for (int i=0; i<4; i++) {
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageBtnArr[i]] forState:0];
        btn.tag=i;
        [btn addTarget:self action:@selector(Forbtn:) forControlEvents:UIControlEventTouchUpInside];
        [view1 sd_addSubviews:@[btn]];
        btn.sd_layout
        .leftSpaceToView(view1,d+(50+d)*i)
        .topSpaceToView(view1,5)
        .widthIs(50)
        .heightIs(134/2);
        [view1 setupAutoHeightWithBottomView:btn bottomMargin:5];
    }
    //view2
    UIView * view2 =[UIView new];
    view2.backgroundColor=[UIColor whiteColor];
    [_headView sd_addSubviews:@[view2]];
    view2.sd_layout
    .leftEqualToView(view1)
    .rightEqualToView(view1)
    .topSpaceToView(view1,10);
  
    //拍卖标的
    UIImageView * imageBD =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_title1"]];
    [view2 sd_addSubviews:@[imageBD]];
    imageBD.sd_layout
    .leftSpaceToView(view2,15)
    .topSpaceToView(view2,10)
    .widthIs(160/2)
    .heightIs(29/2);
    //更多
    UIButton * moreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn addTarget:self action:@selector(paiMaiMore) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:[UIImage imageNamed:@"home_fanhui"] forState:0];
    [view2 sd_addSubviews:@[moreBtn]];
    moreBtn.sd_layout
    .rightSpaceToView(view2,15)
    .centerYEqualToView(imageBD)
    .widthIs(20)
    .heightIs(20);
    
    
    //红线条
    UIImageView * lineImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_index"]];
  //  lineImage.backgroundColor=[UIColor redColor];
    [view2 sd_addSubviews:@[lineImage]];
    lineImage.sd_layout
    .leftSpaceToView(view2,0)
    .rightSpaceToView(view2,0)
    .topSpaceToView(imageBD,10)
    .heightIs(0.5);
    //滚动试图
    UIScrollView * priceScrollview =[[UIScrollView alloc]init];
    priceScrollview.showsHorizontalScrollIndicator = NO;
    priceScrollview.userInteractionEnabled=YES;
  //  priceScrollview.backgroundColor=[UIColor yellowColor];
    priceScrollview.contentSize=CGSizeMake(ScreenWidth+200, 120);
    [view2 sd_addSubviews:@[priceScrollview]];
    priceScrollview.sd_layout
    .leftSpaceToView(view2,0)
    .rightSpaceToView(view2,0)
    .topSpaceToView(lineImage,10)
    .heightIs(160+10);
    [view2 setupAutoHeightWithBottomView:priceScrollview bottomMargin:10];
   
    [Engine firstPaiMaiBiaoDiViewSearchStr:@"" BiaoDiStyle:@"" ProvCode:@"" CityCode:@"" Staus:@"" PageSize:@"5" PageIndex:@"1" success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSArray * contentAr =[dic objectForKey:@"content"];
            if (contentAr.count!=0) {
                for (int i =0; i<contentAr.count; i++) {
                    NSDictionary * dicc =contentAr[i];
                    PaiMaiBiaoDiModel * model =[[PaiMaiBiaoDiModel alloc]initWithBiaoDiDic:dicc];
                    [_paiMaiBiaoDiArr addObject:model];
                    UIButton * bgView =[UIButton new];
                    bgView.tag=i;
                    bgView.layer.borderWidth=.5;
                    bgView.layer.borderColor=JXColor(205, 131, 137, 1).CGColor;
                    bgView.backgroundColor=JXColor(247, 247, 247, 1);
                    [bgView addTarget:self action:@selector(bgviewClick:) forControlEvents:UIControlEventTouchUpInside];
                    [priceScrollview sd_addSubviews:@[bgView]];
                    bgView.sd_layout
                    .leftSpaceToView(priceScrollview,7+(175+7)*i)
                    .topSpaceToView(priceScrollview,0)
                    .bottomSpaceToView(priceScrollview,0)
                    .widthIs(175);
                    //图片
                    UIImageView * imageview =[UIImageView new];
                    [imageview setImageWithURL:[NSURL URLWithString:model.leftImage] placeholderImage:[UIImage imageNamed:@"banner"]];
                    [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
                      imageview.contentMode =  UIViewContentModeScaleAspectFill;
                    imageview.clipsToBounds  = YES;
                    [bgView sd_addSubviews:@[imageview]];
                    imageview.sd_layout
                    .leftSpaceToView(bgView,0)
                    .rightSpaceToView(bgView,0)
                    .topSpaceToView(bgView,0)
                    .heightIs(80);
                    
                    
                    
                    //标题
                    UILabel * titileLabel =[UILabel new];
                    titileLabel.numberOfLines=1;
                    titileLabel.font=[UIFont systemFontOfSize:15];
                    titileLabel.alpha=.8;
                    titileLabel.text=model.titleName;//@"一大批闲置机械常淑萍沙发";
                    [bgView sd_addSubviews:@[titileLabel]];
                    titileLabel.sd_layout
                    .leftSpaceToView(bgView,5)
                    .topSpaceToView(imageview,10)
                    .rightSpaceToView(bgView,5)
                    .heightIs(15);
                    //[titileLabel setSingleLineAutoResizeWithMaxWidth:130];
                    //起拍价
                    UILabel * qiPaiLabel =[UILabel new];
                    qiPaiLabel.numberOfLines=1;
                    qiPaiLabel.font=[UIFont systemFontOfSize:16];
                    qiPaiLabel.alpha=.7;
                    qiPaiLabel.textColor=[UIColor redColor];
                    qiPaiLabel.text=[NSString stringWithFormat:@"起拍价:%@",model.price];//@"起拍价:3.34万";
                    qiPaiLabel.attributedText=[ToolClass attrStrFrom:qiPaiLabel.text intFond:13 Color:[UIColor blackColor] numberStr:@"起拍价:"];
                    [bgView sd_addSubviews:@[qiPaiLabel]];
                    qiPaiLabel.sd_layout
                    .leftSpaceToView(bgView,5)
                    .topSpaceToView(titileLabel,10)
                    .widthIs(130)
                    .heightIs(15);
                    //时间
                    UILabel * timeLabel =[UILabel new];
                    timeLabel.text=[NSString stringWithFormat:@"%@开始",model.time];//@"11月04日 10:05 开始";
                    timeLabel.font=[UIFont systemFontOfSize:13];
                    timeLabel.textColor=[UIColor redColor];
                    timeLabel.alpha=.7;
                    timeLabel.attributedText=[ToolClass attrStrFrom:timeLabel.text intFond:13 Color:[UIColor blackColor] numberStr:@"开始"];
                    [bgView sd_addSubviews:@[timeLabel]];
                    timeLabel.sd_layout
                    .leftSpaceToView(bgView,5)
                    .topSpaceToView(qiPaiLabel,10)
                    .rightSpaceToView(bgView,0)
                    .heightIs(15);
                    
                    
                    
                }
                //140 每一个的宽度，14两边的宽度，15*(contentAr.count-1)中间间隔的宽度
                priceScrollview.contentSize=CGSizeMake(175*contentAr.count+14+7*(contentAr.count-1), 120);
                

            }
            
            
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        [LCProgressHUD hide];
    }];
    
    
    //459+40
 //   _headView.backgroundColor=[UIColor greenColor];
   // NSLog(@">>>>scre=%f",ScreenWidth);
    if (ScreenWidth==414) {
        //6p
         _headView.sd_layout.heightIs(459-30);
    }else if (ScreenWidth==375){
        //6
         _headView.sd_layout.heightIs(459-20);
    }else {
        //6以下
        _headView.sd_layout.heightIs(459+10+10-30-15);
    }
   
   
    return _headView;
}

#pragma mark --滚动视图的button的点击事件
-(void)bgviewClick:(UIButton*)btn{
    PaiMaiBiaoDiModel * md=_paiMaiBiaoDiArr[btn.tag];
    PaiMaiBiaoDiXiangQingVC* vc =[PaiMaiBiaoDiXiangQingVC new];
    vc.biaoDiID=md.biaoDiID;
    vc.paiMaiID=md.paiMaiID;
    vc.dataScore=md.dataSoure;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --拍卖标的更多
-(void)paiMaiMore{
    PaiMaiBiaoDiVC * vc =[PaiMaiBiaoDiVC new];
      vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --4个按钮点击状态
-(void)Forbtn:(UIButton*)btn{
    if (btn.tag==0) {
        //拍卖标的
        PaiMaiBiaoDiVC * vc =[PaiMaiBiaoDiVC new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag==1){
        //拍卖公告
        PaiMaiGongGaoVC * vc =[PaiMaiGongGaoVC new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag==2){
        //拍卖咨询
        PaiMaiZiXunVC * vc=[PaiMaiZiXunVC new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
       //成交按理
        ChengJiaoAnLiVC* vc=[ChengJiaoAnLiVC new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
#pragma mark --创建表
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.tableHeaderView=[self CreatView1];
    _tableView.backgroundColor=BG_COLOR;
    [self.view addSubview:_tableView];
    
    __weak typeof (self) weakSelf =self;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.myRefreshView = weakSelf.tableView.header;
        _AAA=1;
        [self jieXiDataPage:_AAA];
    }];
    
    [_tableView.header beginRefreshing];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
//    cell.backgroundColor=[UIColor magentaColor];
    PaiMaiGongGaoModel * md =_dataArray[indexPath.row];
    cell.textLabel.text=md.titleName;//[NSString stringWithFormat:@"第%lu行",indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.alpha=.7;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaiMaiGongGaoModel * md =_dataArray[indexPath.row];
    PaiMaiGongGaoXiangQingVC * vc =[PaiMaiGongGaoXiangQingVC new];
      vc.hidesBottomBarWhenPushed=YES;
    vc.paiMaiHuiID=md.paiMaiHuiID;
    vc.datasoure=md.dataSource;
    [self.navigationController pushViewController:vc animated:YES];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * bgview =[UIView new];
   // view.backgroundColor=[UIColor blueColor];//BG_COLOR;
    
    
    UIView * view =[UIView new];
    view.backgroundColor=[UIColor whiteColor];
    [bgview sd_addSubviews:@[view]];
    view.sd_layout
    .leftSpaceToView(bgview,0)
    .rightSpaceToView(bgview,0)
    .topSpaceToView(bgview,10)
    .heightIs(44);
    
    
    
    //拍卖标的
    UIImageView * imageBD =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_title12"]];
    [view sd_addSubviews:@[imageBD]];
    imageBD.sd_layout
    .leftSpaceToView(view,15)
    .centerYEqualToView(view)
    .widthIs(159/2)
    .heightIs(28/2);
    //更多
    UIButton * moreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"home_fanhui"] forState:0];
    [moreBtn addTarget:self action:@selector(publicBtn) forControlEvents:UIControlEventTouchUpInside];
    [view sd_addSubviews:@[moreBtn]];
    moreBtn.sd_layout
    .rightSpaceToView(view,15)
    .centerYEqualToView(imageBD)
    .widthIs(20)
    .heightIs(20);
    
    
    //红线条
    UIImageView * lineImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_index"]];
    //lineImage.backgroundColor=[UIColor redColor];
    [view sd_addSubviews:@[lineImage]];
    lineImage.sd_layout
    .leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .topSpaceToView(imageBD,10)
    .heightIs(.5);
    
    return bgview;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}
#pragma mark --区头点击更多
-(void)publicBtn{
    PaiMaiGongGaoVC * vc =[PaiMaiGongGaoVC new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --点击了搜索事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
     [textField resignFirstResponder];//关闭键盘
    PaiMaiBiaoDiVC * vc =[PaiMaiBiaoDiVC new];
    vc.searStr=textField.text;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"点击了搜索十几号");
    return YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   [self.navigationController.view endEditing:YES];
}

//-(void)viewWillAppear:(BOOL)animated{
//    
//}






@end
