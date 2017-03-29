//
//  ZaiXianJingJiaVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/24.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ZaiXianJingJiaVC.h"
#import "HeadImageView.h"
#import "HeadLineView.h"
#import "Singleton.h"
#import "ZaiXianModel.h"
#import "ZaiXianJingJiaCell.h"
//颜色
@interface ZaiXianJingJiaVC ()<headLineDelegate,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
{
    dispatch_source_t _timer;
}
@property(nonatomic,strong)HeadImageView *headImageView;//头视图
@property(nonatomic,strong)HeadLineView *headLineView;//
//@property(nonatomic,strong)UIView * view1;
//@property(nonatomic,strong)UIView * view2;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSMutableArray *dataArray0;
@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)UIView * liuYanView;
@property(nonatomic,strong) UILabel *dayLabel;//天
@property(nonatomic,strong)UILabel *hourLabel;//时
@property(nonatomic,strong)UILabel *minuteLabel;//分
@property(nonatomic,strong) UILabel *secondLabel;//秒
@property(nonatomic,strong)UILabel * priceLabel;//数字的价格
@property(nonatomic,assign)int daoQianTag;//记录当前价格(加 或者 减过的)
//dangQianLab
//peopleLab
@property(nonatomic,strong)UILabel * dangQianLab;//当前出价
@property(nonatomic,strong)UILabel* peopleLab;//记录出价人

@end

@implementation ZaiXianJingJiaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"在线竞价";
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUpOrDown:) name:UIKeyboardWillChangeFrameNotification object:nil];
   // [self CreatGundong];//创建顶部滚动试图
//    
    [self loadData];//加载数据源
    [self createTableView];//创建表
    
//    NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10"};
//    
//    NSDictionary * dicc =@{@"action":@"app_qryTargetCompeteStatus",@"param":param};
//    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
//    
//    NSString * sss =[NSString stringWithFormat:@"%@#####",jsonStr];
//    
//    [[Singleton sharedInstance] sendMessage:sss];
//    [Singleton sharedInstance].cityNameBlock=^(NSDictionary*dic){
//        NSLog(@"数%@",dic);
//    };

}
- (void)keyboardUpOrDown:(NSNotification *)notifition
{
    NSDictionary * dic = notifition.userInfo;
    //用NSValue来接收，因为它是坐标（结构体）
    NSValue * value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    //结构体转化为对象类型
    CGRect rect = [value CGRectValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    _liuYanView.frame = CGRectMake(0,rect.origin.y-50-64, ScreenWidth, 50);
    //表的坐标
   _tableView.frame = CGRectMake(0, 0, ScreenWidth, _liuYanView.frame.origin.y);
    
    NSIndexPath * indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
     [UIView commitAnimations];
    
    
}

#pragma mark --倒计时代码
-(void)dataRiqiData:(NSString*)riqi{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //在这写上开始时间
    NSDate *endDate = [dateFormatter dateFromString:riqi];
    //NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 24*3600)];
    NSDate *startDate = [NSDate date];
    NSTimeInterval timeInterval =[endDate timeIntervalSinceDate:startDate];
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
                            self.hourLabel.text = [NSString stringWithFormat:@"0%d时",hours];
                        }else{
                            self.hourLabel.text = [NSString stringWithFormat:@"%d时",hours];
                        }
                        if (minute<10) {
                            self.minuteLabel.text = [NSString stringWithFormat:@"0%d分",minute];
                        }else{
                            self.minuteLabel.text = [NSString stringWithFormat:@"%d分",minute];
                        }
                        if (second<10) {
                            self.secondLabel.text = [NSString stringWithFormat:@"0%d秒",second];
                        }else{
                            self.secondLabel.text = [NSString stringWithFormat:@"%d秒",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}





#pragma mark --创建留言区
-(void)CreatLiuYan{
    _liuYanView=[UIView new];
    _liuYanView.backgroundColor=[UIColor yellowColor];
    _liuYanView.frame=CGRectMake(0, ScreenHeight-50-64, ScreenWidth, 50);
    [self.view addSubview:_liuYanView];
    
    UIButton * leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"zaixian_mg"] forState:0];
    leftBtn.adjustsImageWhenHighlighted=NO;
   
    UITextField * liuYanTextfield=[UITextField new];
    liuYanTextfield.font=[UIFont systemFontOfSize:15];
    liuYanTextfield.placeholder=@"想说点什么";
    liuYanTextfield.backgroundColor=[UIColor greenColor];
    
    UIButton * sendBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.sd_cornerRadius=@(5);
    sendBtn.backgroundColor=[UIColor redColor];
    [sendBtn setTitle:@"发送" forState:0];
    [_liuYanView sd_addSubviews:@[leftBtn,liuYanTextfield,sendBtn]];
   
    leftBtn.sd_layout
    .leftSpaceToView(_liuYanView,15)
    .centerYEqualToView(_liuYanView)
    .widthIs(25)
    .heightIs(25);
    
    sendBtn.sd_layout
    .rightSpaceToView(_liuYanView,15)
    .centerYEqualToView(_liuYanView)
    .widthIs(70)
    .heightIs(30);
    
    liuYanTextfield.sd_layout
    .leftSpaceToView(leftBtn,10)
    .centerYEqualToView(_liuYanView)
    .rightSpaceToView(sendBtn,10)
    .heightIs(30);
}

#pragma mark --创建滚动试图
//-(UIView * )CreatGundong:(UIView*)headView{
//    
//    _view1=[UIView new];
//    _view1.backgroundColor=[UIColor whiteColor];
//    [headView sd_addSubviews:@[_view1]];
//    _view1.sd_layout
//    .leftSpaceToView(headView,0)
//    .rightSpaceToView(headView,0)
//    .topSpaceToView(headView,0)
//    .heightIs(200);
//    
//    //轮播图
//    NSArray * arr =_lunbiArr;//@[@"banner"];
//    SDCycleScrollView*  cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 540*ScreenWidth/1080) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
//    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    cycleScrollView2.currentPageDotColor = [UIColor whiteColor];
//    [_view1 addSubview:cycleScrollView2];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        cycleScrollView2.imageURLStringsGroup = arr;
//    });
//    cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
//        // NSLog(@">>>>>  %ld", (long)index);
//        
//    };
//    
//    
//    //等待开始拍卖
//    UIView * bgView =[UIView new];
//    bgView.backgroundColor=[UIColor redColor];
//    [_view1  sd_addSubviews:@[bgView]];
//    bgView.sd_layout
//    .rightSpaceToView(_view1,15)
//    .topSpaceToView(_view1,10)
//    .widthIs(100)
//    .heightIs(112/2);
//    //等带开始
//    UILabel * starLabel=[UILabel new];
//    starLabel.text=@"等待开始";
//    starLabel.textAlignment=1;
//    starLabel.textColor=[UIColor whiteColor];
//    starLabel.font=[UIFont systemFontOfSize:17 weight:18];
//    [bgView sd_addSubviews:@[starLabel]];
//    starLabel.sd_layout
//    .leftSpaceToView(bgView,0)
//    .rightSpaceToView(bgView,0)
//    .topSpaceToView(bgView,2)
//    .heightIs(20);
//    //倒计时时间
//    //(天数)
//    self.dayLabel=[UILabel new];
//    self.dayLabel.textColor=[UIColor blackColor];
//    self.dayLabel.font=[UIFont systemFontOfSize:14];
//    self.dayLabel.backgroundColor=[UIColor whiteColor];
//    [bgView sd_addSubviews:@[self.dayLabel]];
//    self.dayLabel.sd_layout
//    .leftSpaceToView(bgView,3)
//    .topSpaceToView(starLabel,3)
//    .bottomSpaceToView(bgView,3);
//    [self.dayLabel setSingleLineAutoResizeWithMaxWidth:80];
//    //(时)
//    self.hourLabel=[UILabel new];
//    self.hourLabel.textColor=[UIColor blackColor];
//    self.hourLabel.font=[UIFont systemFontOfSize:14];
//    self.hourLabel.backgroundColor=[UIColor whiteColor];
//    [bgView sd_addSubviews:@[self.hourLabel]];
//    self.hourLabel.sd_layout
//    .leftSpaceToView(_dayLabel,-1)
//    .topSpaceToView(starLabel,3)
//    .bottomSpaceToView(bgView,3);
//    [self.hourLabel setSingleLineAutoResizeWithMaxWidth:80];
//    //分
//    self.minuteLabel=[UILabel new];
//    self.minuteLabel.textColor=[UIColor blackColor];
//    self.minuteLabel.font=[UIFont systemFontOfSize:14];
//    self.minuteLabel.backgroundColor=[UIColor whiteColor];
//    [bgView sd_addSubviews:@[self.minuteLabel]];
//    self.minuteLabel.sd_layout
//    .leftSpaceToView(self.hourLabel,-1)
//    .topSpaceToView(starLabel,3)
//    .bottomSpaceToView(bgView,3);
//    [self.minuteLabel setSingleLineAutoResizeWithMaxWidth:80];
//    [bgView setupAutoWidthWithRightView:self.minuteLabel rightMargin:3];
//    [self dataRiqiData:@"2017-03-27 22:40:27"];
//    
//    
//    
//    //下一件btn
//    UIButton * nenxtbtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [nenxtbtn setBackgroundImage:[UIImage imageNamed:@"zaixian_bt2"] forState:0];
//    [_view1 sd_addSubviews:@[nenxtbtn]];
//    nenxtbtn.sd_layout//
//    .rightSpaceToView(_view1,15)
//    .topSpaceToView(cycleScrollView2,15)
//    .widthIs(137/2)
//    .heightIs(50/2);
//    //上一件btn
//    UIButton * upbtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [upbtn setBackgroundImage:[UIImage imageNamed:@"zaixian_bt1"] forState:0];
//    [_view1 sd_addSubviews:@[upbtn]];
//    upbtn.sd_layout//
//    .rightSpaceToView(nenxtbtn,10)
//    .centerYEqualToView(nenxtbtn)
//    .widthIs(137/2)
//    .heightIs(50/2);
//    
//    //标题
//    UILabel * titleLabel =[UILabel new];
//    titleLabel.text=_titlename;//@"日产50顿烘干设备专线王璇大山炮王璇大山";
//    titleLabel.font=[UIFont systemFontOfSize:16];
//    titleLabel.alpha=.8;
//    titleLabel.numberOfLines=0;
//    [_view1 sd_addSubviews:@[titleLabel]];
//    titleLabel.sd_layout
//    .leftSpaceToView(_view1,15)
//    .topSpaceToView(cycleScrollView2,15)
//    .rightSpaceToView(upbtn,10)
//    .autoHeightRatio(0);
//    //当前出价
//    UILabel * dangQianLab =[UILabel new];
//    dangQianLab.text=@"当前出价：14万";
//    dangQianLab.font=[UIFont systemFontOfSize:17];
//    dangQianLab.textColor=[UIColor redColor];
//    dangQianLab.attributedText= [ToolClass attrStrFrom:dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
//    dangQianLab.alpha=.6;
//    [_view1 sd_addSubviews:@[dangQianLab]];
//    dangQianLab.sd_layout
//    .leftEqualToView(titleLabel)
//    .topSpaceToView(titleLabel,20)
//    .widthIs(150)
//    .heightIs(20);
//    
//    //出价人
//    UILabel * peopleLab =[UILabel new];
//    peopleLab.text=@"出价人：033";
//    peopleLab.font=[UIFont systemFontOfSize:14];
//    peopleLab.alpha=.6;
//    peopleLab.numberOfLines=0;
//    [_view1 sd_addSubviews:@[peopleLab]];
//    peopleLab.sd_layout
//    .rightSpaceToView(_view1,15)
//    .centerYEqualToView(dangQianLab)
//    .heightIs(20);
//    [peopleLab setSingleLineAutoResizeWithMaxWidth:200];
//    
//    [_view1 setupAutoHeightWithBottomView:peopleLab bottomMargin:10];
//    
//    
//
//    
//    
//    
//    //_paiMaiID _biaoDiID
//    
//    NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10"};
//    
//    NSDictionary * dicc =@{@"action":@"app_qryTargetCompeteStatus",@"param":param};
//    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
//    
//    NSString * sss =[NSString stringWithFormat:@"%@#####",jsonStr];
//   
//    [[Singleton sharedInstance] sendMessage:sss];
//    [Singleton sharedInstance].cityNameBlock=^(NSDictionary*dic){
//        NSLog(@"数%@",dic);
//    };
//    
//    [Singleton sharedInstance].cityNameBlock=^(NSDictionary*dic){
//       NSLog(@"在线竞价%@",dic);
//                NSString * msg_type =[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg_type"]];
//                    //对应请求返回的信息
//                if ([msg_type isEqualToString:@"response"]) {
//                    NSDictionary * responseInfo =[dic objectForKey:@"responseInfo"];
//                    NSString * code =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[responseInfo objectForKey:@"code"]]];
//                    NSString * action =[responseInfo objectForKey:@"action"];
//                    /*
//                     1.如果action=app_qryTargetCompeteStatus 倒计时接口
//                     2.如果action=app_qryUserCompeteRecord   出价记录接口
//                     */
//                    //倒计时
//                    if ([code isEqualToString:@"1"] && [action isEqualToString:@"app_qryTargetCompeteStatus"] ) {
//                        NSDictionary * contentDic =[responseInfo objectForKey:@"content"];
//                        [self timeDaoJiShi:contentDic Label:starLabel uiview:bgView];
//                        
//                    }
//                    //查询出价记录ZaiXianModel
//                    if ([code isEqualToString:@"1"] && [action isEqualToString:@"app_qryUserCompeteRecord"] ){
//                        NSArray *contentArr =[responseInfo objectForKey:@"content"];
//                        for (NSDictionary * dicc in contentArr) {
//                            ZaiXianModel * model =[[ZaiXianModel alloc]initWithChuJiaJiluDic:dicc];
//                            [_dataArray0 addObject:model];
//                            [_dataArray1 addObject:model];
//                        }
//                        //当前出价
//                        if (_dataArray0.count!=0) {
//                            ZaiXianModel * model=_dataArray0[0];
//                            dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",model.moneyName];
//                            peopleLab.text=[NSString stringWithFormat:@"出价人：%@",model.jingPaiNum];
//                        }else{
//                            dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",@"暂无"];
//                            peopleLab.text=[NSString stringWithFormat:@"出价人：%@",@"暂无"];
//                        }
//                        dangQianLab.attributedText= [ToolClass attrStrFrom:dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
//                        
//                        [_tableView reloadData];
//                    
//                    
//                    }
//                    
//                    
//                    
//                    
//                    
//                //response那个括号
//                }else if (([msg_type isEqualToString:@"push"])){
//                    NSDictionary * pushInfoDic =[dic objectForKey:@"pushInfo"];
//                    NSString * push_scene =[NSString stringWithFormat:@"%@",[pushInfoDic objectForKey:@"push_scene"]];
//                    //推送的倒计时
//                    if ([push_scene isEqualToString:@"resetCountDown"]) {
//                        NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
//                         [self timeDaoJiShi:push_content Label:starLabel uiview:bgView];
//                    }
//                    
//
//                    
//                    
//                    
//                    
//                    
//                    
//                    //竞价记录增加数据
//                    if ([push_scene isEqualToString:@"newCompeteRecord"]) {
//                        NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
//                        ZaiXianModel * mode =[[ZaiXianModel alloc]initWithChuJiaJiluDic:push_content];
//                        [_dataArray0 insertObject:mode atIndex:0];
//                        dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",mode.moneyName];
//                        peopleLab.text=[NSString stringWithFormat:@"出价人：%@",mode.jingPaiNum];
//                    }
//                     dangQianLab.attributedText= [ToolClass attrStrFrom:dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
//                    [_tableView reloadData];
//                }
//        
//        
//        
//    };
//
//    
//    
//    return _view1;
//}


-(void)timeDaoJiShi:(NSDictionary*)contentDic  Label:(UILabel*)starLabel uiview:(UIView*)bgView{
    
    //标题
    starLabel.text=[contentDic objectForKey:@"target_status_name"];
    //颜色
    NSString * colorStr =[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"color_type"]];
    if ([colorStr isEqualToString:@"1"]) {
        bgView.backgroundColor=[UIColor redColor];
    }else if ([colorStr isEqualToString:@"2"]){
        bgView.backgroundColor=[UIColor yellowColor];
    }else if ([colorStr isEqualToString:@"3"]){
        bgView.backgroundColor=[UIColor grayColor];
    }
    
    //  countdown_remain_millisecond
    NSString * sj = [NSString stringWithFormat:@"%@",[contentDic objectForKey:@"countdown_remain_millisecond"]];
    long long timeSr =[sj longLongValue];
    NSLog(@"sj>>>%@",sj);
    //判断一下状态1.content 2.stop 3.finish 4.none
    NSString * statusStr =[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"countdown_status"]];
    long long  strTime;
    if ([statusStr isEqualToString:@"finish"]) {
        
    }else if ([statusStr isEqualToString:@"stop"]){
        
    }else if ([statusStr isEqualToString:@"none"]){
        
    }else if ([statusStr isEqualToString:@"continue"]){
        if (timeSr<0) {
            strTime=-timeSr;
        }else{
            strTime=timeSr+1000000;
        }
        NSString * str= [ToolClass ConvertStrToTime:strTime];
        NSLog(@"输出是%@",str);
        [self dataRiqiData:str];
    }
    

}

//创建数据源
-(void)loadData{
    _currentIndex=0;
    _dataArray0=[[NSMutableArray alloc]init];
    _dataArray1=[[NSMutableArray alloc]init];
    
    
    NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10"};
    
    NSDictionary * dicc =@{@"action":@"app_qryUserCompeteRecord",@"param":param};
    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
    NSString * sss =[NSString stringWithFormat:@"%@#####",jsonStr];
    [[Singleton sharedInstance] sendMessage:sss];
    [Singleton sharedInstance].cityNameBlock=^(NSDictionary*dic){
        NSLog(@"竞价记录%@",dic);
    };
//
    
    
    

}
//创建TableView
-(void)createTableView{
   // if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.dataSource=self;
        _tableView.delegate=self;
//        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];

   // }
    [_tableView setTableHeaderView:[self headImageView]];
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    UIView *targetview = sender.view;
    if(targetview.tag == 1) {
        return;
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_currentIndex>1) {
            return;
        }
        _currentIndex++;
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_currentIndex<=0) {
            return;
        }
        _currentIndex--;
    }
    [_headLineView setCurrentIndex:_currentIndex];
}
#pragma mark --头视图
-(HeadImageView *)headImageView{
    
    if (!_headImageView) {
        _headImageView=[[HeadImageView alloc]init];
       // _headImageView.frame=CGRectMake(0, 0, ScreenWidth, 161+260);
        _headImageView.backgroundColor=BG_COLOR;
      _headImageView.sd_layout
        .leftSpaceToView(_tableView,0)
        .rightSpaceToView(_tableView,0)
        .topSpaceToView(_tableView,0)
        .heightIs( 453);
        
        
        
        UIView * view1=[UIView new];
        view1.backgroundColor=[UIColor whiteColor];
        [_headImageView sd_addSubviews:@[view1]];
        view1.sd_layout
        .leftSpaceToView(_headImageView,0)
        .rightSpaceToView(_headImageView,0)
        .topSpaceToView(_headImageView,0)
        .heightIs(200);
        
        //轮播图
        NSArray * arr =_lunbiArr;//@[@"banner"];
        SDCycleScrollView*  cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 540*ScreenWidth/1080) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView2.currentPageDotColor = [UIColor whiteColor];
        [view1 addSubview:cycleScrollView2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cycleScrollView2.imageURLStringsGroup = arr;
        });
        cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
            // NSLog(@">>>>>  %ld", (long)index);
            
        };
        

        //等待开始拍卖
        UIView * bgView =[UIView new];
        bgView.backgroundColor=[UIColor redColor];
        [view1  sd_addSubviews:@[bgView]];
        bgView.sd_layout
        .rightSpaceToView(view1,15)
        .topSpaceToView(view1,10)
        .widthIs(100)
        .heightIs(112/2);
        //等带开始
        UILabel * starLabel=[UILabel new];
        starLabel.text=@"等待开始";
        starLabel.textAlignment=1;
        starLabel.textColor=[UIColor whiteColor];
        starLabel.font=[UIFont systemFontOfSize:17 weight:18];
        [bgView sd_addSubviews:@[starLabel]];
        starLabel.sd_layout
        .leftSpaceToView(bgView,0)
        .rightSpaceToView(bgView,0)
        .topSpaceToView(bgView,2)
        .heightIs(20);
        //倒计时时间
        //(天数)
        self.dayLabel=[UILabel new];
        self.dayLabel.textColor=[UIColor blackColor];
        self.dayLabel.font=[UIFont systemFontOfSize:14];
        self.dayLabel.backgroundColor=[UIColor whiteColor];
        [bgView sd_addSubviews:@[self.dayLabel]];
        self.dayLabel.sd_layout
        .leftSpaceToView(bgView,3)
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
        [bgView setupAutoWidthWithRightView:self.minuteLabel rightMargin:3];
        [self dataRiqiData:@"2017-03-27 22:40:27"];
        
        
        
//        //下一件btn
//        UIButton * nenxtbtn =[UIButton buttonWithType:UIButtonTypeCustom];
//        [nenxtbtn setBackgroundImage:[UIImage imageNamed:@"zaixian_bt2"] forState:0];
//        [view1 sd_addSubviews:@[nenxtbtn]];
//        nenxtbtn.sd_layout//
//        .rightSpaceToView(view1,15)
//        .topSpaceToView(cycleScrollView2,15)
//        .widthIs(137/2)
//        .heightIs(50/2);
//        //上一件btn
//        UIButton * upbtn =[UIButton buttonWithType:UIButtonTypeCustom];
//        [upbtn setBackgroundImage:[UIImage imageNamed:@"zaixian_bt1"] forState:0];
//        [view1 sd_addSubviews:@[upbtn]];
//        upbtn.sd_layout//
//        .rightSpaceToView(nenxtbtn,10)
//        .centerYEqualToView(nenxtbtn)
//        .widthIs(137/2)
//        .heightIs(50/2);
        
        //标题
        UILabel * titleLabel =[UILabel new];
        titleLabel.text=_titlename;//@"日产50顿烘干设备专线王璇大山炮王璇大山";
        titleLabel.font=[UIFont systemFontOfSize:16];
        titleLabel.alpha=.8;
        titleLabel.numberOfLines=0;
        [view1 sd_addSubviews:@[titleLabel]];
        titleLabel.sd_layout
        .leftSpaceToView(view1,15)
        .topSpaceToView(cycleScrollView2,15)
        .rightSpaceToView(view1,15)
        .autoHeightRatio(0);
        //当前出价
        UILabel * dangQianLab =[UILabel new];
        _dangQianLab=dangQianLab;
        dangQianLab.text=@"当前出价：14万";
        dangQianLab.font=[UIFont systemFontOfSize:17];
        dangQianLab.textColor=[UIColor redColor];
        dangQianLab.attributedText= [ToolClass attrStrFrom:dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
        dangQianLab.alpha=.6;
        [view1 sd_addSubviews:@[dangQianLab]];
        dangQianLab.sd_layout
        .leftEqualToView(titleLabel)
        .topSpaceToView(titleLabel,20)
        .widthIs(250)
        .heightIs(20);
        
        //出价人
        UILabel * peopleLab =[UILabel new];
        _peopleLab=peopleLab;
        peopleLab.text=@"出价人：033";
        peopleLab.font=[UIFont systemFontOfSize:14];
        peopleLab.alpha=.6;
        peopleLab.numberOfLines=0;
        [view1 sd_addSubviews:@[peopleLab]];
        peopleLab.sd_layout
        .rightSpaceToView(view1,15)
        .centerYEqualToView(dangQianLab)
        .heightIs(20);
        [peopleLab setSingleLineAutoResizeWithMaxWidth:200];
        
        [view1 setupAutoHeightWithBottomView:peopleLab bottomMargin:10];
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        //创建_view2
       UIView* view2=[UIView new];
        view2.backgroundColor=[UIColor greenColor];
        [_headImageView sd_addSubviews:@[view2]];
        view2.sd_layout
        .leftSpaceToView(_headImageView,0)
        .rightSpaceToView(_headImageView,0)
        .topSpaceToView(view1,0);
//
        //当前出价
        UILabel * dangQianLab2 =[UILabel new];
        dangQianLab2.text=@"当前出价";
        dangQianLab2.font=[UIFont systemFontOfSize:14];
        dangQianLab2.alpha=.6;
        [view2 sd_addSubviews:@[dangQianLab2]];
        dangQianLab2.sd_layout
        .leftSpaceToView(view2,15)
        .topSpaceToView(view2,25)
        .heightIs(20);
        [dangQianLab2 setSingleLineAutoResizeWithMaxWidth:130];
        //减号
        UIButton * jianBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [jianBtn addTarget:self action:@selector(jianBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [jianBtn setBackgroundImage:[UIImage imageNamed:@"zaixian_jia"] forState:0];
        [view2 sd_addSubviews:@[jianBtn]];
        jianBtn.sd_layout
        .leftSpaceToView(dangQianLab2,15)
        .centerYEqualToView(dangQianLab2)
        .widthIs(70/2)
        .heightIs(70/2);
        //数字价钱
        UILabel * priceLabel =[UILabel new];
        _priceLabel=priceLabel;
        priceLabel.layer.borderWidth=1;
        priceLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
        priceLabel.alpha=.8;
        priceLabel.textAlignment=1;
        priceLabel.font=[UIFont systemFontOfSize:18];
        [view2 sd_addSubviews:@[priceLabel]];
        priceLabel.sd_layout
        .leftSpaceToView(jianBtn,0)
        .centerYEqualToView(jianBtn)
        .heightRatioToView(jianBtn,1)
        .widthIs(100);
        //加
        UIButton * addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"zaixian_jian"] forState:0];
        [view2 sd_addSubviews:@[addBtn]];
        addBtn.sd_layout
        .leftSpaceToView(priceLabel,0)
        .centerYEqualToView(priceLabel)
        .widthRatioToView(jianBtn,1)
        .heightRatioToView(jianBtn,1);
        //200
        UIButton * twoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        twoBtn.backgroundColor=JXColor(255, 140, 144, 1);//[UIColor redColor];
        [twoBtn setTitle:[NSString stringWithFormat:@"+%@",_price1] forState:0];
        
        [view2 sd_addSubviews:@[twoBtn]];
        twoBtn.sd_layout
        .leftEqualToView(jianBtn)
        .topSpaceToView(jianBtn,20)
        .widthIs(126/2)
        .heightIs(25);
        //500
        UIButton * wubaiBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        wubaiBtn.backgroundColor=[UIColor redColor];
         [wubaiBtn setTitle:[NSString stringWithFormat:@"+%@",_price2] forState:0];
        [view2 sd_addSubviews:@[wubaiBtn]];
        wubaiBtn.sd_layout
        .leftSpaceToView(twoBtn,15)
        .centerYEqualToView(twoBtn)
        .widthIs(126/2)
        .heightIs(25);
        //1000
        UIButton * yiqianBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        yiqianBtn.backgroundColor=JXColor(239, 0, 13, 1);
        [yiqianBtn setTitle:[NSString stringWithFormat:@"+%@",_price3] forState:0];
        [view2 sd_addSubviews:@[yiqianBtn]];
        yiqianBtn.sd_layout
        .leftSpaceToView(wubaiBtn,15)
        .centerYEqualToView(twoBtn)
        .widthIs(126/2)
        .heightIs(25);
        
        
        [twoBtn addTarget:self action:@selector(jiaBtn2) forControlEvents:UIControlEventTouchUpInside];
        [wubaiBtn addTarget:self action:@selector(jiaBtn3) forControlEvents:UIControlEventTouchUpInside];
        [yiqianBtn addTarget:self action:@selector(jiaBtn4) forControlEvents:UIControlEventTouchUpInside];
        
        
     //确认出价
        UIButton * btnSure =[UIButton buttonWithType:UIButtonTypeCustom];
        [btnSure setBackgroundImage:[UIImage imageNamed:@"zaixian_bt7"] forState:0];
        [view2 sd_addSubviews:@[btnSure]];
        [btnSure addTarget:self action:@selector(chuJiaPrice) forControlEvents:UIControlEventTouchUpInside];
        btnSure.sd_layout
        .leftEqualToView(twoBtn)
        .topSpaceToView(twoBtn,15)
        .widthIs(466/2)
        .heightIs(58/2);
        [view2 setupAutoHeightWithBottomView:btnSure bottomMargin:10];
        
        
        
        
        //_paiMaiID _biaoDiID
        
        NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10"};
        
        NSDictionary * dicc =@{@"action":@"app_qryTargetCompeteStatus",@"param":param};
        NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
        
        NSString * sss =[NSString stringWithFormat:@"%@#####",jsonStr];
        
        [[Singleton sharedInstance] sendMessage:sss];
        [Singleton sharedInstance].cityNameBlock=^(NSDictionary*dic){
            NSLog(@"数%@",dic);
        };
        
        [Singleton sharedInstance].cityNameBlock=^(NSDictionary*dic){
            NSLog(@"在线竞价%@",dic);
            NSString * msg_type =[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg_type"]];
            //对应请求返回的信息
            if ([msg_type isEqualToString:@"response"]) {
                NSDictionary * responseInfo =[dic objectForKey:@"responseInfo"];
                NSString * code =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[responseInfo objectForKey:@"code"]]];
                NSString * action =[responseInfo objectForKey:@"action"];
                /*
                 1.如果action=app_qryTargetCompeteStatus 倒计时接口
                 2.如果action=app_qryUserCompeteRecord   出价记录接口
                 */
                //倒计时
                if ([code isEqualToString:@"1"] && [action isEqualToString:@"app_qryTargetCompeteStatus"] ) {
                    NSDictionary * contentDic =[responseInfo objectForKey:@"content"];
                    [self timeDaoJiShi:contentDic Label:starLabel uiview:bgView];
                    
                }
                //查询出价记录ZaiXianModel
                if ([code isEqualToString:@"1"] && [action isEqualToString:@"app_qryUserCompeteRecord"] ){
                    NSArray *contentArr =[responseInfo objectForKey:@"content"];
                    for (NSDictionary * dicc in contentArr) {
                        ZaiXianModel * model =[[ZaiXianModel alloc]initWithChuJiaJiluDic:dicc];
                        [_dataArray0 addObject:model];
                        [_dataArray1 addObject:model];
                    }
                    //当前出价
                    if (_dataArray0.count!=0) {
                        ZaiXianModel * model=_dataArray0[0];
                          priceLabel.text=model.moneyName;
                        dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",model.moneyName];
                        peopleLab.text=[NSString stringWithFormat:@"出价人：%@",model.jingPaiNum];
                    }else{
                        dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",@"暂无"];
                        peopleLab.text=[NSString stringWithFormat:@"出价人：%@",@"暂无"];
                    }
                    dangQianLab.attributedText= [ToolClass attrStrFrom:dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
                    
                    [_tableView reloadData];
                    
                    
                }
                
                
                
                
                
                //response那个括号
            }else if (([msg_type isEqualToString:@"push"])){
                NSDictionary * pushInfoDic =[dic objectForKey:@"pushInfo"];
                NSString * push_scene =[NSString stringWithFormat:@"%@",[pushInfoDic objectForKey:@"push_scene"]];
                //推送的倒计时
                if ([push_scene isEqualToString:@"resetCountDown"]) {
                    NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                    [self timeDaoJiShi:push_content Label:starLabel uiview:bgView];
                }
                
                //竞价记录增加数据
                if ([push_scene isEqualToString:@"newCompeteRecord"]) {
                    NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                    ZaiXianModel * mode =[[ZaiXianModel alloc]initWithChuJiaJiluDic:push_content];
                    [_dataArray0 insertObject:mode atIndex:0];
                    priceLabel.text=mode.moneyName;
                    dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",mode.moneyName];
                    peopleLab.text=[NSString stringWithFormat:@"出价人：%@",mode.jingPaiNum];
                }
                dangQianLab.attributedText= [ToolClass attrStrFrom:dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
                [_tableView reloadData];
            }
            
            
            
        };
        
        
        
        

        
        
        
        
        [_headImageView setupAutoHeightWithBottomView:view2 bottomMargin:10];
        
        
        _headImageView.didFinishAutoLayoutBlock=^(CGRect rect){
            NSLog(@">>>>%f",rect.size.height+rect.origin.y);
            _headImageView.sd_layout
            .heightIs( rect.size.height+rect.origin.y);
        };
    }
    return _headImageView;
}
#pragma mark --加号
-(void)addBtnClick{
    int zhi =[_priceLabel.text intValue];
    int d =zhi+100;
    _daoQianTag=d;
    _priceLabel.text=[NSString stringWithFormat:@"%d元",d];
}
-(void)jianBtnClick{
    int d ;
    if (_daoQianTag==0) {
        d=[_priceLabel.text intValue]-100;
    }else{
        d =_daoQianTag-100;
    }
    
    _daoQianTag=d;
    _priceLabel.text=[NSString stringWithFormat:@"%d元",d];
}
-(void)jiaBtn2{
    int d ;
    if (_daoQianTag==0) {
        d=[_priceLabel.text intValue];
    }else{
        d =_daoQianTag;
    }
    _daoQianTag=d+[_price1 intValue];
    _priceLabel.text=[NSString stringWithFormat:@"%d元",_daoQianTag];
    
    
}
-(void)jiaBtn3{
    int d ;
    if (_daoQianTag==0) {
        d=[_priceLabel.text intValue];
    }else{
        d =_daoQianTag;
    }
    _daoQianTag=d+[_price2 intValue];
    _priceLabel.text=[NSString stringWithFormat:@"%d元",_daoQianTag];
}
-(void)jiaBtn4{
    int d ;
    if (_daoQianTag==0) {
        d=[_priceLabel.text intValue];
    }else{
        d =_daoQianTag;
    }
    _daoQianTag=d+[_price3 intValue];
    _priceLabel.text=[NSString stringWithFormat:@"%d元",_daoQianTag];
}

#pragma mark --确认出价
-(void)chuJiaPrice{
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"出价token空"];
        return;
    }
   
    NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10",@"user_id":token,@"bid_money":[NSString stringWithFormat:@"%d",_daoQianTag]};
    NSDictionary * dicc =@{@"action":@"app_bidToTargetCompete",@"param":param};
    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
    NSString * sss =[NSString stringWithFormat:@"%@#####",jsonStr];
    [[Singleton sharedInstance] sendMessage:sss];
        [Singleton sharedInstance].cityNameBlock=^(NSDictionary*dic){
            NSLog(@"出价记录%@",dic);
            NSString * msg_type =[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg_type"]];
            //请求接口相应状态
            if ([msg_type isEqualToString:@"response"]) {
                NSDictionary * responseInfoDic=[dic objectForKey:@"responseInfo"];
                NSString * action =[responseInfoDic objectForKey:@"action"];
                //app_bidToTargetCompete代表的是出价状态
                if ([action isEqualToString:@"app_bidToTargetCompete"]) {
                    [LCProgressHUD showMessage:[responseInfoDic objectForKey:@"msg"]];
                }
                
                
            }//推送状态
            else if ([msg_type isEqualToString:@"push"]){
                NSDictionary * pushInfoDic =[dic objectForKey:@"pushInfo"];
                NSString * push_scene =[NSString stringWithFormat:@"%@",[pushInfoDic objectForKey:@"push_scene"]];
                //竞价记录增加数据
                if ([push_scene isEqualToString:@"newCompeteRecord"]) {
                    NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                    ZaiXianModel * mode =[[ZaiXianModel alloc]initWithChuJiaJiluDic:push_content];
                    [_dataArray0 insertObject:mode atIndex:0];
                    _priceLabel.text=mode.moneyName;
                    _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",mode.moneyName];
                    _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",mode.jingPaiNum];
                }
                _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
                [_tableView reloadData];
            }
            
        };
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentIndex==0) {
        return 44;
    }else{
         return 50;
    }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentIndex==0) {
        return _dataArray0.count+1;
    }else if(_currentIndex==1){
        return _dataArray1.count;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headLineView) {
        _headLineView=[[HeadLineView alloc]init];
        _headLineView.frame=CGRectMake(0, 0, ScreenWidth, 48);
        _headLineView.delegate=self;
        [_headLineView setTitleArray:@[@"竞价记录",@"竞买留言区"]];
    }
    //如果headLineView需要添加图片，请到HeadLineView.m中去设置就可以了，里面有注释
    
    return _headLineView;
}
-(void)refreshHeadLine:(NSInteger)currentIndex
{
    _currentIndex=currentIndex;
    if (currentIndex==0) {
        [_liuYanView removeFromSuperview];
        _tableView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    }else{
         [self CreatLiuYan];
    }
    [_tableView reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * idd =[NSString stringWithFormat:@"%lu%lu",(long)indexPath.row,(long)indexPath.section];
    
   
    

    
    if (_currentIndex==0) {
        ZaiXianJingJiaCell * cell =[ZaiXianJingJiaCell cellWithTableView:_tableView CellID:idd];
        if (indexPath.row==0) {
            cell.leftLabel.text=@"竞买号牌";
            cell.centerLabel.text=@"出价(元)";
            cell.rightLabel.text=@"出价时间";
            cell.leftLabel.font=[UIFont systemFontOfSize:16];
            cell.centerLabel.font=[UIFont systemFontOfSize:16];
            cell.rightLabel.font=[UIFont systemFontOfSize:16];
            cell.centerLabel.textColor=[UIColor blackColor];
            
        }else{
            ZaiXianModel * md =_dataArray0[indexPath.row-1];
            
            cell.leftLabel.text=md.jingPaiNum;
            cell.centerLabel.text=md.moneyName;
            cell.rightLabel.text=md.timeName;
        }
        
        return cell;
        
    }else if(_currentIndex==1){
        static NSString *reusID=@"ID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusID];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusID];
        }
         cell.textLabel.text=[NSString stringWithFormat:@"第%lu行",(long)indexPath.row];
        
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell被点击恢复
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_currentIndex==0) {
    }else if (_currentIndex==1){
    }else{
    }
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
