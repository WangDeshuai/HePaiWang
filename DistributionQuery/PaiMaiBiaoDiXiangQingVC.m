//
//  PaiMaiBiaoDiXiangQingVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PaiMaiBiaoDiXiangQingVC.h"
#import "ZaiXianJingJiaVC.h"
#import "HtmlViewController.h"
#import "Singleton.h"
#import "XYAlertView.h"
@interface PaiMaiBiaoDiXiangQingVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
     dispatch_source_t _timer;
}
@property(nonatomic,strong)UIView * view1;
@property(nonatomic,strong)UIView * view2;
@property(nonatomic,strong)UIView * view3;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong) UILabel *dayLabel;//天
@property(nonatomic,strong)UILabel *hourLabel;//时
@property(nonatomic,strong)UILabel *minuteLabel;//分
@property(nonatomic,strong) UILabel *secondLabel;//秒
@property(nonatomic,strong)NSMutableArray * htmlArr;
//没有创建model,必须单个独立往在线竞价界面传值
@property(nonatomic,strong)NSArray * lunbiArr;
@property(nonatomic,copy)NSString *titlename;
@property(nonatomic,copy)NSString * price1;
@property(nonatomic,copy)NSString * price2;
@property(nonatomic,copy)NSString * price3;
@property(nonatomic,strong)UILabel * starLabel;
@property(nonatomic,strong)UIView *bgView;

@end

@implementation PaiMaiBiaoDiXiangQingVC
-(void)viewWillAppear:(BOOL)animated{
   
    static dispatch_once_t hanwanjie;
    //只执行一次
    dispatch_once(&hanwanjie, ^{//119.29.83.154 192.168.1.103
        [Singleton sharedInstance].socketHost = SOCRT; //host设定
        [Singleton sharedInstance].socketPort = 8006; //port设定
        //在连接前先进行手动断开
        [Singleton sharedInstance].socket.userData = SocketOfflineByUser;
        [[Singleton sharedInstance] cutOffSocket];
        
        // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
        [Singleton sharedInstance].socket.userData = SocketOfflineByServer;
        [[Singleton sharedInstance] socketConnectHost];
        
    });
    
    [self socketData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [Singleton sharedInstance].socket.userData = SocketOfflineByUser;
//    [[Singleton sharedInstance] cutOffSocket];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"拍卖标的详情";
    _dataArr=[[NSMutableArray alloc]initWithObjects:@"竞买须知",@"竞买公告",@"标的物介绍", nil];
    _htmlArr=[NSMutableArray new];
    [self CreatRightBtn];
    [self CreatTableView];
    [self CreatButton];
    
    
 
    
}
#pragma mark --右按钮
-(void)CreatRightBtn{
    UIButton * rightbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame=CGRectMake(0, 0, 70, 30);
    [rightbtn setTitle:@"申请报名" forState:0];
    rightbtn.titleLabel.font=[UIFont systemFontOfSize:16];
    rightbtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [rightbtn addTarget:self action:@selector(backPopBtnPop2) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBtn2 =[[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItems=@[leftBtn2];
}
-(void)backPopBtnPop2{
    XYAlertView * xv =[[XYAlertView alloc]initWithTitle:@"我要报名" alerMessage:@"提交信息" canCleBtn:@"提交信息" otheBtn:@""];
    __weak __typeof(xv)weakSelf = xv;
    xv.NameBlock=^(NSString*people,NSString*phone,NSString*other){
        // 调用接口
        [LCProgressHUD showMessage:@"正在发布..."];
        [Engine BaoMingCanJianPaiMaiID:_paiMaiID BiaoDiID:_biaoDiID Phone:phone PeopleName:people MessageName:other success:^(NSDictionary *dic) {
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [weakSelf dissmiss];
            }
        } error:^(NSError *error) {
            
        }];
    };
    
    [xv show];
}

-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}

-(void)dataRiqiData:(NSString*)riqi{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //在这写上开始时间
   // NSDate *endDate = [dateFormatter dateFromString:riqi];
    //NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 24*3600)];
    //NSDate *startDate = [NSDate date];
     NSTimeInterval timeInterval=[riqi doubleValue] / 1000.0;
    if (timeInterval==0) {
        self.dayLabel.text = @"0天";
        self.hourLabel.text = @"0时";
        self.minuteLabel.text = @"0分";
        self.secondLabel.text = @"0秒";
    }
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.dayLabel.text = @"0天";
                        self.hourLabel.text = @"0时";
                        self.minuteLabel.text = @"0分";
                        self.secondLabel.text = @"0秒";
                        //时间到了，执行这
                    });
                }else{
                     [self timeJiShi:timeout];
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}
-(void)timeJiShi:(int)timeout{
    int days = (int)(timeout/(3600*24));
    if (days==0) {
        self.dayLabel.text = @"";
    }
    int hours = (int)((timeout-days*24*3600)/3600);
    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
    int second = timeout-days*24*3600-hours*3600-minute*60;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (days==0) {
            self.dayLabel.text = @"0天";
        }else{
            self.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
        }
        if (hours<10) {
            self.hourLabel.text = [NSString stringWithFormat:@"%d时",hours];
        }else{
            self.hourLabel.text = [NSString stringWithFormat:@"%d时",hours];
        }
        if (minute<10) {
            self.minuteLabel.text = [NSString stringWithFormat:@"%d分",minute];
        }else{
            self.minuteLabel.text = [NSString stringWithFormat:@"%d分",minute];
        }
        if (second<10) {
            self.secondLabel.text = [NSString stringWithFormat:@"%d秒",second];
        }else{
            self.secondLabel.text = [NSString stringWithFormat:@"%d秒",second];
        }
        
    });
    
}




#pragma mark --创建按钮
-(void)CreatButton{
    UIButton * fabu =[UIButton buttonWithType:UIButtonTypeCustom];
    fabu.backgroundColor=[UIColor whiteColor];
    [fabu addTarget:self action:@selector(fabu) forControlEvents:UIControlEventTouchUpInside];
    fabu.frame=CGRectMake(0, ScreenHeight-55-64, ScreenWidth, 55);
    [fabu setImage:[UIImage imageNamed:@"nav_bottom_jinru"] forState:0];
    [self.view addSubview:fabu];
    
}
-(void)fabu{
    
    ZaiXianJingJiaVC * vc =[ZaiXianJingJiaVC new];
    vc.paiMaiID=_paiMaiID;
    vc.biaoDiID=_biaoDiID;
    vc.lunbiArr=_lunbiArr;
    vc.titlename=_titlename;
    vc.price1=_price1;
    vc.price2=_price2;
    vc.price3=_price3;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --创建表
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-50) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[UIView new];
    _tableView.tableHeaderView=[self CreatTableHeadView];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSString * cellID =[NSString stringWithFormat:@"%lu%lu",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text=_dataArr[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.alpha=.6;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HtmlViewController * vc =[HtmlViewController new];
    vc.str=_htmlArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UIView*)CreatTableHeadView{
    UIView * headView =[UIView new];
    headView.backgroundColor=BG_COLOR;
  //438+10
    headView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0);
//    .heightIs(468);
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
    //等待开始拍卖
    UIView * bgView =[UIView new];
    _bgView=bgView;
    bgView.backgroundColor=[UIColor redColor];
    [headView  sd_addSubviews:@[bgView]];
    bgView.sd_layout
    .rightSpaceToView(headView,15)
    .topSpaceToView(headView,10)
    .heightIs(120/2);
    //等带开始
    UILabel * starLabel=[UILabel new];
    _starLabel=starLabel;
    starLabel.text=@"等待开始";
    starLabel.textAlignment=1;
    starLabel.textColor=[UIColor whiteColor];
    starLabel.font=[UIFont systemFontOfSize:15 weight:18];
    [bgView sd_addSubviews:@[starLabel]];
    starLabel.sd_layout
    .leftSpaceToView(bgView,0)
    .rightSpaceToView(bgView,0)
    .topSpaceToView(bgView,3)
    .heightIs(20);
    
    
    
    UIView * timeView =[UIView new];
    timeView.backgroundColor=[UIColor whiteColor];
    [bgView sd_addSubviews:@[timeView]];
    timeView.sd_layout
    .topSpaceToView(starLabel,3)
    .leftSpaceToView(bgView,3)
    .rightSpaceToView(bgView,3)
    .bottomSpaceToView(bgView,3);
    
    
    //倒计时时间
    //(天数)
    self.dayLabel=[UILabel new];
    self.dayLabel.textColor=[UIColor blackColor];
    self.dayLabel.font=[UIFont systemFontOfSize:14];
    self.dayLabel.backgroundColor=[UIColor whiteColor];
    [bgView sd_addSubviews:@[self.dayLabel]];
    self.dayLabel.sd_layout
    .leftSpaceToView(bgView,10)
    .topSpaceToView(starLabel,3)
    .bottomSpaceToView(bgView,3);
    [self.dayLabel setSingleLineAutoResizeWithMaxWidth:80];
    //(时)
    self.hourLabel=[UILabel new];
    self.hourLabel.textColor=[UIColor blackColor];
    self.hourLabel.font=[UIFont systemFontOfSize:14];
    self.hourLabel.backgroundColor=[UIColor whiteColor];
    [bgView sd_addSubviews:@[self.hourLabel]];
    self.hourLabel.sd_layout
    .leftSpaceToView(_dayLabel,-1)
    .topSpaceToView(starLabel,3)
    .bottomSpaceToView(bgView,3);
    [self.hourLabel setSingleLineAutoResizeWithMaxWidth:80];
    //分
    self.minuteLabel=[UILabel new];
    self.minuteLabel.textColor=[UIColor blackColor];
    self.minuteLabel.font=[UIFont systemFontOfSize:14];
    self.minuteLabel.backgroundColor=[UIColor whiteColor];
    [bgView sd_addSubviews:@[self.minuteLabel]];
    self.minuteLabel.sd_layout
    .leftSpaceToView(self.hourLabel,-1)
    .topSpaceToView(starLabel,3)
    .bottomSpaceToView(bgView,3);
    [self.minuteLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    self.secondLabel=[UILabel new];
    self.secondLabel.textColor=[UIColor blackColor];
    self.secondLabel.font=[UIFont systemFontOfSize:14];
    self.secondLabel.backgroundColor=[UIColor whiteColor];
    [bgView sd_addSubviews:@[self.secondLabel]];
    self.secondLabel.sd_layout
    .leftSpaceToView(self.minuteLabel,-1)
    .topSpaceToView(starLabel,3)
    .bottomSpaceToView(bgView,3);
    [self.secondLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    [bgView setupAutoWidthWithRightView:self.secondLabel rightMargin:10];
    
    self.dayLabel.textAlignment=1;
    self.hourLabel.textAlignment=1;
    self.minuteLabel.textAlignment=1;
    self.secondLabel.textAlignment=1;
    
    //        self.dayLabel.backgroundColor=[UIColor redColor];
    //        self.hourLabel.backgroundColor=[UIColor blueColor];
    //        self.minuteLabel.backgroundColor=[UIColor magentaColor];
    //        self.secondLabel.backgroundColor=[UIColor yellowColor];
    [self dataRiqiData:@"0"];
    

    

    
    
    
//    UILabel * timeLabel =[UILabel new];
//    timeLabel.backgroundColor=[UIColor whiteColor];
//    timeLabel.text=@"0天0时0分";
//    timeLabel.textAlignment=1;
//    timeLabel.textColor=[UIColor blackColor];
//    timeLabel.font=[UIFont systemFontOfSize:14];
//    [bgView sd_addSubviews:@[timeLabel]];
//    timeLabel.sd_layout
//    .leftSpaceToView(bgView,3)
//    .rightSpaceToView(bgView,3)
//    .topSpaceToView(starLabel,3)
//    .bottomSpaceToView(bgView,3);

    
    
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
    //开拍提醒
    UIButton * tixingBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [tixingBtn setBackgroundImage:[UIImage imageNamed:@"biaodi_bt1"] forState:0];
    tixingBtn.hidden=YES;
    [_view1 sd_addSubviews:@[tixingBtn]];
    tixingBtn.sd_layout
    .rightSpaceToView(_view1,20)
    .topEqualToView(titleLable)
    .widthIs(100/2)
    .heightIs(78/2);
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
    ziyouLabel.text=@"自由竞价时间:1万";
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
    xianshiLabel.text=@"限时竞价时间:1万";
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
    
    //获取网络数据
    [Engine paiMaiLieBiaoXiangQingPaiMaiID:_paiMaiID BiaoDiID:_biaoDiID success:^(NSDictionary *dic) {
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        NSDictionary * contentDic =[dic objectForKey:@"content"];
        if ([code isEqualToString:@"1"]) {
           //1.轮播图赋值
            NSArray * arrimage =[contentDic objectForKey:@"targetImgList"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cycleScrollView2.imageURLStringsGroup =arrimage ;
            });
            _lunbiArr=arrimage;
            //2.标题
             titleLable.text=[contentDic objectForKey:@"target_name"];
            _titlename=[contentDic objectForKey:@"target_name"];
            _price1=[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"auction_compete_step1"]];
            _price2=[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"auction_compete_step2"]];
            _price3=[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"auction_compete_step3"]];
            //3.起拍价
             qiPaiJiaLable.text=[NSString stringWithFormat:@"起拍价：%@万",[contentDic objectForKey:@"target_start_price"]];
            qiPaiJiaLable.attributedText= [ToolClass attrStrFrom:qiPaiJiaLable.text intFond:13 Color:[UIColor blackColor] numberStr:@"起拍价："];
            //4.报名人数
             baoming.text=[NSString stringWithFormat:@"%@报名",[contentDic objectForKey:@"signup_number"]];
            //5.提醒人数
             tixingLabel.text=[NSString stringWithFormat:@"%@人设置提醒",[contentDic objectForKey:@"remaind_number"]];
            //6.浏览数
             liuLanLabel.text=[NSString stringWithFormat:@"%@人浏览",[contentDic objectForKey:@"browse_number"]];
            //7.评估价
             pinggujia.text=[NSString stringWithFormat:@"评估价:%@元",[contentDic objectForKey:@"target_estimated_price"]];
            //8. 加价幅度
            jiaLable.text=[NSString stringWithFormat:@"加价幅度:%@元",[contentDic objectForKey:@"auction_least_compete_step"]];
            //9.保证金
            baozhengjin.text=[NSString stringWithFormat:@"保证金:%@元",[contentDic objectForKey:@"auction_deposit_value"]];
            //10.类型
             typeLabel.text=[NSString stringWithFormat:@"类型:%@",[contentDic objectForKey:@"target_type_name"]];
            //11.自由竞价时间
            ziyouLabel.text=[NSString stringWithFormat:@"自由竞价时间:%@分",[contentDic objectForKey:@"auction_freely_compete_time"]];
            //12.保留价
             baoLiu.text=[NSString stringWithFormat:@"保留价:%@",[contentDic objectForKey:@"auction_use_reserve_price"]];
            //13.限时竞价时间
              xianshiLabel.text=[NSString stringWithFormat:@"限时竞价时间:%@分",[contentDic objectForKey:@"auction_limited_compete_time"]];
            //14.优先购买权
             youXian.text=[NSString stringWithFormat:@"优先购买权人:%@",[contentDic objectForKey:@"auction_use_preferential_buy"]];
            //15.竞买须知 竞买公告  标的物介绍
            NSString * str1 =[contentDic objectForKey:@"auction_compete_attention"];
            NSString * str2 =[contentDic objectForKey:@"auction_compete_declaration"];
            NSString * str3 =[contentDic objectForKey:@"target_description"];
             [_htmlArr addObject:str1];
             [_htmlArr addObject:str2];
             [_htmlArr addObject:str3];
            [_tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
    
    
 
    
    
    
    
    
    
    
    return headView;
}

-(void)socketData{
    NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10"};
    NSDictionary * dicc =@{@"action":@"app_connectTargetCompete",@"param":param};
    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
    
    NSString * sss =[NSString stringWithFormat:@"%@#####",jsonStr];
    
    [Singleton sharedInstance].messageContent=sss;
    [[Singleton sharedInstance] sendMessage:sss];
    [Singleton sharedInstance].cityNameBlock=^(NSDictionary*dic){
        NSLog(@"详情倒计时%@",dic);
        NSString * msgtype =[dic objectForKey:@"msg_type"];
        if ([msgtype isEqualToString:@"push"]) {
            //推送过来的
            NSDictionary * pushinfo=[dic objectForKey:@"pushInfo"];
            NSString * puhscene =[pushinfo objectForKey:@"push_scene"];
            //代表是倒计时
            if ([puhscene isEqualToString:@"resetCountDown"]) {
                
                NSDictionary * pushcontentDic =[pushinfo objectForKey:@"push_content"];
                [self timeDaoJiShi:pushcontentDic Label:_starLabel uiview:_bgView];
            }
        }else if ([msgtype isEqualToString:@"response"]){
            //请求相应的
        }
    };
}
-(void)timeDaoJiShi:(NSDictionary*)contentDic  Label:(UILabel*)starLabel uiview:(UIView*)bgView{
    
    //标题
    starLabel.text=[contentDic objectForKey:@"target_status_name"];
    //颜色
    NSString * colorStr =[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"color_type"]];
    if ([colorStr isEqualToString:@"1"]) {
        bgView.backgroundColor=[UIColor redColor];
    }else if ([colorStr isEqualToString:@"2"]){
        bgView.backgroundColor=JXColor(53, 152, 255, 1);
    }else if ([colorStr isEqualToString:@"3"]){
        bgView.backgroundColor=[UIColor grayColor];
    }
    
    //  countdown_remain_millisecond
    NSString * sj = [NSString stringWithFormat:@"%@",[contentDic objectForKey:@"countdown_remain_millisecond"]];
    long long timeSr =[sj longLongValue];
    
    //判断一下状态1.content 2.stop 3.finish 4.none
    NSString * statusStr =[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"countdown_status"]];
    
    if ([statusStr isEqualToString:@"finish"]) {
        NSLog(@"finish输出是%lld",timeSr);
        // [self dataRiqiData:[NSString stringWithFormat:@"%lld",timeSr]];
        _timer = nil;
        [self timeJiShi:(int)timeSr/1000];
        
    }else if ([statusStr isEqualToString:@"stop"]){
        NSLog(@"stop输出是%lld",timeSr);
        [self dataRiqiData:[NSString stringWithFormat:@"%lld",timeSr]];
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_source_cancel(_timer);
            _timer = nil;
            [self timeJiShi:(int)timeSr/1000];
        });
        
    }else if ([statusStr isEqualToString:@"none"]){
        // [self dataRiqiData:[NSString stringWithFormat:@"%lld",timeSr]];
        _timer = nil;
        [self timeJiShi:(int)timeSr/1000];
    }else if ([statusStr isEqualToString:@"continue"]){
        long long  strTime;
        if (timeSr<0) {
            strTime=-timeSr;
        }else{
            strTime=timeSr;
        }
        NSLog(@"continue输出是%lld",strTime);
        _timer = nil;
        [self dataRiqiData:[NSString stringWithFormat:@"%lld",strTime]];
    }else if ([statusStr isEqualToString:@"error"]){
        NSLog(@"error输出是%lld",timeSr);
        _timer = nil;
        [self timeJiShi:(int)timeSr/1000];
    }
    
    
}


-(void)shuju{
    NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10"};
    NSDictionary * dicc =@{@"action":@"app_connectTargetCompete",@"param":param};
    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
    
    NSString * sss =[NSString stringWithFormat:@"%@#####",jsonStr];
    
     [Singleton sharedInstance].messageContent=sss;
     [[Singleton sharedInstance] sendMessage:sss];
    [Singleton sharedInstance].cityNameBlock=^(NSDictionary*dic){
        NSLog(@"这不是输出吗%@",dic);
    };

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
-(void)LabelShuXing:(UILabel*)lab{
    lab.alpha=.6;
    lab.font=[UIFont systemFontOfSize:13];
    
}
@end
