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
#import "LiuYanZhuanQuCell.h"
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

@property(nonatomic,strong)UILabel * starLabel;//倒计时标题
@property(nonatomic,strong)UIView *bgView;//倒计时背景色

@property(nonatomic,strong)UITextField *liuYanTextfield;//留言版

@end

@implementation ZaiXianJingJiaVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"在线竞价";
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUpOrDown:) name:UIKeyboardWillChangeFrameNotification object:nil];
   // [self CreatGundong];//创建顶部滚动试图
    _dataArray0=[[NSMutableArray alloc]init];
    _dataArray1=[[NSMutableArray alloc]init];
   //加载数据源
    [self createTableView];//创建表
    
//    NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10"};
//    NSDictionary * dicc =@{@"action":@"app_qryTargetCompeteSpeakRecord",@"param":param};
//    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
//    
//    NSString * sss =[NSString stringWithFormat:@"%@#####",jsonStr];
//    
//    [[Singleton sharedInstance] sendMessage:sss];
//    [Singleton sharedInstance].cityNameBlock=^(NSDictionary*dic){
//        NSLog(@"aaaaa数%@",dic);
//    };

}
- (void)keyboardUpOrDown:(NSNotification *)notifition
{
    NSDictionary * dic = notifition.userInfo;
    //用NSValue来接收，因为它是坐标（结构体）
    NSValue * value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    //结构体转化为对象类型
    CGRect rect = [value CGRectValue];
    //[UIView beginAnimations:nil context:nil];
    //[UIView setAnimationDuration:0.25];
    _liuYanView.frame = CGRectMake(0,rect.origin.y-50-64, ScreenWidth, 50);
//    //表的坐标
//   _tableView.frame = CGRectMake(0, 0, ScreenWidth, _liuYanView.frame.origin.y);
    if (_dataArray1.count==0) {
        
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, _liuYanView.frame.origin.y);
        NSIndexPath * indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        [UIView commitAnimations];
    }
   
    
    
}

#pragma mark --倒计时代码   155555555
-(void)dataRiqiData:(NSString*)riqi{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //在这写上开始时间
    //NSDate *endDate = [dateFormatter dateFromString:riqi];
    //NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 24*3600)];
    //NSDate *startDate = [NSDate date];
   // NSTimeInterval timeInterval =[endDate timeIntervalSinceNow];//[endDate timeIntervalSinceDate:startDate];
    NSTimeInterval timeInterval=[riqi doubleValue] / 1000.0;
    if (timeInterval==0) {
        self.dayLabel.text = @"0天";
        self.hourLabel.text = @"0时";
        self.minuteLabel.text = @"0分";
        self.secondLabel.text = @"0秒";
        return;
    }
    
   else if (_timer==nil) {
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
                }
                else{
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

#pragma mark --创建留言区
-(void)CreatLiuYan{
    _liuYanView=[UIView new];
    _liuYanView.backgroundColor=[UIColor whiteColor];
    _liuYanView.frame=CGRectMake(0, ScreenHeight-50-64, ScreenWidth, 50);
    [self.view addSubview:_liuYanView];
    
    UIView * linview =[UIView new];
    linview.backgroundColor=BG_COLOR;
    [_liuYanView sd_addSubviews:@[linview]];
    linview.sd_layout
    .leftSpaceToView(_liuYanView,0)
    .rightSpaceToView(_liuYanView,0)
    .topSpaceToView(_liuYanView,0)
    .heightIs(1);
    
    
    UIButton * leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"zaixian_mg"] forState:0];
    leftBtn.adjustsImageWhenHighlighted=NO;
   
    UITextField * liuYanTextfield=[UITextField new];
    _liuYanTextfield=liuYanTextfield;
    liuYanTextfield.font=[UIFont systemFontOfSize:15];
    liuYanTextfield.placeholder=@"想说点什么";
//    liuYanTextfield.backgroundColor=[UIColor whiteColor];
//    liuYanTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    liuYanTextfield.layer.borderWidth=.5;
    
    UIButton * sendBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.sd_cornerRadius=@(5);
    sendBtn.backgroundColor=[UIColor redColor];
    [sendBtn setTitle:@"发送" forState:0];
    [sendBtn addTarget:self action:@selector(sendContent) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark --发送按钮点击事件
-(void)sendContent{
    
   
    
    NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10",@"user_id":@"22",@"speak_content":_liuYanTextfield.text};
    NSDictionary * dicc =@{@"action":@"app_speakInCompetePage",@"param":param};
    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
    [Engine socketLianJieJsonStr:jsonStr success:^(NSDictionary *dic) {
        NSLog(@"发言的内容%@",dic);
        NSString * msg_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg_type"]];
       //请求对应的部分
        if ([msg_type isEqualToString:@"response"]) {
            NSDictionary * responseInfoDic =[dic objectForKey:@"responseInfo"];
            NSString * action =[NSString stringWithFormat:@"%@",[responseInfoDic objectForKey:@"action"]];
            NSString * code =[NSString stringWithFormat:@"%@",[responseInfoDic objectForKey:@"code"]];
            [LCProgressHUD showMessage:[responseInfoDic objectForKey:@"msg"]];
            if ([action isEqualToString:@"app_speakInCompetePage"] && [code isEqualToString:@"1"]) {
                _liuYanTextfield.text=@"";
                [_liuYanTextfield resignFirstResponder];
            }

        }//推送部分
        else if ([msg_type isEqualToString:@"push"]){
            NSDictionary * pushInfoDic =[dic objectForKey:@"pushInfo"];
            NSDictionary * contentDic =[pushInfoDic objectForKey:@"push_content"];
            ZaiXianModel * md =[[ZaiXianModel alloc]initWithLiuYanZhuanQu:contentDic];
            if (_currentIndex==1) {
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                [_dataArray1 insertObject:md atIndex:0];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [indexPaths addObject: indexPath];
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                [_tableView reloadData];
            }else if (_currentIndex==0){
                 [_dataArray1 insertObject:md atIndex:0];
                [_tableView reloadData];
            }
            
        }
        
    }];
}



#pragma mark --倒计时暂停区域(无倒计时)
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
       // NSLog(@"continue输出是%lld",strTime);
        _timer = nil;
        [self dataRiqiData:[NSString stringWithFormat:@"%lld",strTime]];
    }else if ([statusStr isEqualToString:@"error"]){
        NSLog(@"error输出是%lld",timeSr);
        _timer = nil;
         [self timeJiShi:(int)timeSr/1000];
    }
    

}

//创建数据源
-(void)loadData{
    _currentIndex=0;
   
    
    //1.请求出价记录的
    NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10"};
    NSDictionary * dicc =@{@"action":@"app_qryUserCompeteRecord",@"param":param};
    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
    [Engine socketLianJieJsonStr:jsonStr success:^(NSDictionary *dic) {
        
    }];
    //2.请求时间的
    NSDictionary  * param2 =@{@"auction_id":@"12",@"target_id":@"10"};
    NSDictionary * dicc2 =@{@"action":@"app_qryTargetCompeteStatus",@"param":param2};
    NSString * jsonStr2 =[ToolClass getJsonStringFromObject:dicc2];
    [Engine socketLianJieJsonStr:jsonStr2 success:^(NSDictionary *dic) {
        NSLog(@"看看%@",dic);
            NSString * msg_type =[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg_type"]];
            [LCProgressHUD hide];
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
                    [self timeDaoJiShi:contentDic Label:_starLabel uiview:_bgView];
                    
                }
                //查询出价记录ZaiXianModel
                if ([code isEqualToString:@"1"] && [action isEqualToString:@"app_qryUserCompeteRecord"] ){
                    NSArray *contentArr =[responseInfo objectForKey:@"content"];
                    for (NSDictionary * dicc in contentArr) {
                        ZaiXianModel * model =[[ZaiXianModel alloc]initWithChuJiaJiluDic:dicc];
                        [_dataArray0 addObject:model];
                    }
                    //当前出价
                    if (_dataArray0.count!=0) {
                        ZaiXianModel * model=_dataArray0[0];
                        _priceLabel.text=model.moneyName;
                        _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",model.moneyName];
                        _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",model.jingPaiNum];
                    }else{
                        _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",@"暂无"];
                        _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",@"暂无"];
                    }
                    _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
                    
                    [_tableView reloadData];
                    
                    
                }
                //竞买留言区
                if ([code isEqualToString:@"1"]&&[action isEqualToString:@"app_qryTargetCompeteSpeakRecord"]) {
                    [self buyLiuYanQuResponseInfoDic:responseInfo];
                }
                
                
                //response那个括号
            }else if (([msg_type isEqualToString:@"push"])){
                NSDictionary * pushInfoDic =[dic objectForKey:@"pushInfo"];
                NSString * push_scene =[NSString stringWithFormat:@"%@",[pushInfoDic objectForKey:@"push_scene"]];
                //推送的倒计时
                if ([push_scene isEqualToString:@"resetCountDown"]) {
                    NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                    [self timeDaoJiShi:push_content Label:_starLabel uiview:_bgView];
                }
                
                //推送竞价记录增加数据
                if ([push_scene isEqualToString:@"newCompeteRecord"]) {
                    NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                    ZaiXianModel * mode =[[ZaiXianModel alloc]initWithChuJiaJiluDic:push_content];
                    
                    if (_currentIndex==0) {
                        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                        [_dataArray0 insertObject:mode atIndex:0];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                        [indexPaths addObject: indexPath];
                        [self.tableView beginUpdates];
                        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                        [self.tableView endUpdates];
                    }else if (_currentIndex==1){
                        [_dataArray0 insertObject:mode atIndex:0];
                        [_tableView reloadData];
                    }
                    
                    
                    
                    _priceLabel.text=mode.moneyName;
                    _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",mode.moneyName];
                    _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",mode.jingPaiNum];
                }
                _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
                //推送的留言
                if ([push_scene isEqualToString:@"newSpeakRecord"]) {
                    NSDictionary * contentDic =[pushInfoDic objectForKey:@"push_content"];
                    ZaiXianModel * md =[[ZaiXianModel alloc]initWithLiuYanZhuanQu:contentDic];
                    if (_currentIndex==1) {
                        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                        [_dataArray1 insertObject:md atIndex:0];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        [indexPaths addObject: indexPath];
                        [self.tableView beginUpdates];
                        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                        [self.tableView endUpdates];
                    }
                    else{
                        [_dataArray1 insertObject:md atIndex:0];
                        [_tableView reloadData];
                    }
                    
                }
                
                
                
                
                //
            }
            
            
            
            
            
            
            
            
        
        
        
    }];
    
    
    
   // [self liuYanZhuanQu];

}

-(void)liuYanZhuanQu{
    //4.请求留言专区的
    NSDictionary  * param1 =@{@"auction_id":@"12",@"target_id":@"10"};
    NSDictionary * dicc1 =@{@"action":@"app_qryTargetCompeteSpeakRecord",@"param":param1};
    NSString * jsonStr1 =[ToolClass getJsonStringFromObject:dicc1];
    [Engine socketLianJieJsonStr:jsonStr1 success:^(NSDictionary *dic) {
        
        //            NSLog(@"请求留言专区的%@",dic);
        NSString * msg_type =[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg_type"]];
        [LCProgressHUD hide];
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
                [self timeDaoJiShi:contentDic Label:_starLabel uiview:_bgView];
                
            }
            //查询出价记录ZaiXianModel
            if ([code isEqualToString:@"1"] && [action isEqualToString:@"app_qryUserCompeteRecord"] ){
                NSArray *contentArr =[responseInfo objectForKey:@"content"];
                for (NSDictionary * dicc in contentArr) {
                    ZaiXianModel * model =[[ZaiXianModel alloc]initWithChuJiaJiluDic:dicc];
                    [_dataArray0 addObject:model];
                }
                //当前出价
                if (_dataArray0.count!=0) {
                    ZaiXianModel * model=_dataArray0[0];
                    _priceLabel.text=model.moneyName;
                    _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",model.moneyName];
                    _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",model.jingPaiNum];
                }else{
                    _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",@"暂无"];
                    _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",@"暂无"];
                }
                _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
                
                [_tableView reloadData];
                
                
            }
            //竞买留言区
            if ([code isEqualToString:@"1"]&&[action isEqualToString:@"app_qryTargetCompeteSpeakRecord"]) {
                [self buyLiuYanQuResponseInfoDic:responseInfo];
            }
            
            
            //response那个括号
        }else if (([msg_type isEqualToString:@"push"])){
            NSDictionary * pushInfoDic =[dic objectForKey:@"pushInfo"];
            NSString * push_scene =[NSString stringWithFormat:@"%@",[pushInfoDic objectForKey:@"push_scene"]];
            //推送的倒计时
            if ([push_scene isEqualToString:@"resetCountDown"]) {
                NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                [self timeDaoJiShi:push_content Label:_starLabel uiview:_bgView];
            }
            
            //推送竞价记录增加数据
            if ([push_scene isEqualToString:@"newCompeteRecord"]) {
                NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                ZaiXianModel * mode =[[ZaiXianModel alloc]initWithChuJiaJiluDic:push_content];
                
                if (_currentIndex==0) {
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    [_dataArray0 insertObject:mode atIndex:0];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    [indexPaths addObject: indexPath];
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView endUpdates];
                }else if (_currentIndex==1){
                    [_dataArray0 insertObject:mode atIndex:0];
                    [_tableView reloadData];
                }
                
                
                
                _priceLabel.text=mode.moneyName;
                _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",mode.moneyName];
                _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",mode.jingPaiNum];
            }
            _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
            //推送的留言
            if ([push_scene isEqualToString:@"newSpeakRecord"]) {
                NSDictionary * contentDic =[pushInfoDic objectForKey:@"push_content"];
                ZaiXianModel * md =[[ZaiXianModel alloc]initWithLiuYanZhuanQu:contentDic];
                if (_currentIndex==1) {
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    [_dataArray1 insertObject:md atIndex:0];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [indexPaths addObject: indexPath];
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView endUpdates];
                }
                else{
                    [_dataArray1 insertObject:md atIndex:0];
                    [_tableView reloadData];
                }
                
            }
            
            
            
            
            //
        }
        
        
        
        
        
        
        
        
    }];
    

}



//创建TableView
-(void)createTableView{
   // if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableFooterView = [UIView new];
        [_tableView setTableHeaderView:[self headImageView]];
        [self.view addSubview:_tableView];

   // }
    
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
        _bgView=bgView;
        bgView.backgroundColor=[UIColor redColor];
        [view1  sd_addSubviews:@[bgView]];
        bgView.sd_layout
        .rightSpaceToView(view1,15)
        .topSpaceToView(view1,10)
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
        view2.backgroundColor=[UIColor whiteColor];
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
        
         //[self loadData];
        
        
        //_paiMaiID _biaoDiID
        //2.倒计时时间(返回的结果中还包含了)
//        NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10"};
//        NSDictionary * dicc =@{@"action":@"app_qryTargetCompeteStatus",@"param":param};
//        NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
//        [LCProgressHUD showLoading:@"请稍后..."];
//        [Engine socketLianJieJsonStr:jsonStr success:^(NSDictionary *dic) {
//                NSLog(@"2.在线竞价%@",dic);
//                NSString * msg_type =[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg_type"]];
//                [LCProgressHUD hide];
//                //对应请求返回的信息
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
//                        }
//                        //当前出价
//                        if (_dataArray0.count!=0) {
//                            ZaiXianModel * model=_dataArray0[0];
//                            priceLabel.text=model.moneyName;
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
//                    //竞买留言区
//                    if ([code isEqualToString:@"1"]&&[action isEqualToString:@"app_qryTargetCompeteSpeakRecord"]) {
//                        [self buyLiuYanQuResponseInfoDic:responseInfo];
//                    }
//                    
//                    
//                    //response那个括号
//                }else if (([msg_type isEqualToString:@"push"])){
//                    NSDictionary * pushInfoDic =[dic objectForKey:@"pushInfo"];
//                    NSString * push_scene =[NSString stringWithFormat:@"%@",[pushInfoDic objectForKey:@"push_scene"]];
//                    //推送的倒计时
//                    if ([push_scene isEqualToString:@"resetCountDown"]) {
//                        NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
//                        [self timeDaoJiShi:push_content Label:starLabel uiview:bgView];
//                    }
//                    
//                    //推送竞价记录增加数据
//                    if ([push_scene isEqualToString:@"newCompeteRecord"]) {
//                        NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
//                        ZaiXianModel * mode =[[ZaiXianModel alloc]initWithChuJiaJiluDic:push_content];
//                        
//                        if (_currentIndex==0) {
//                            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//                            [_dataArray0 insertObject:mode atIndex:0];
//                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//                            [indexPaths addObject: indexPath];
//                            [self.tableView beginUpdates];
//                            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//                            [self.tableView endUpdates];
//                        }else if (_currentIndex==1){
//                            [_dataArray0 insertObject:mode atIndex:0];
//                            [_tableView reloadData];
//                        }
//                        
//                        
//                        
//                        priceLabel.text=mode.moneyName;
//                        dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",mode.moneyName];
//                        peopleLab.text=[NSString stringWithFormat:@"出价人：%@",mode.jingPaiNum];
//                    }
//                    dangQianLab.attributedText= [ToolClass attrStrFrom:dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
//                    //推送的留言
//                    if ([push_scene isEqualToString:@"newSpeakRecord"]) {
//                        NSDictionary * contentDic =[pushInfoDic objectForKey:@"push_content"];
//                        ZaiXianModel * md =[[ZaiXianModel alloc]initWithLiuYanZhuanQu:contentDic];
//                        if (_currentIndex==1) {
//                            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//                            [_dataArray1 insertObject:md atIndex:0];
//                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                            [indexPaths addObject: indexPath];
//                            [self.tableView beginUpdates];
//                            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//                            [self.tableView endUpdates];
//                        }
//                        else{
//                            [_dataArray1 insertObject:md atIndex:0];
//                            [_tableView reloadData];
//                        }
//                    
//                    }
//                    
//                    
//                    
//                    
//                    //
//                }
//                
//                
//                
//            
//        }];
        
        

        
        
        
        
       
        
        
        
        
        [_headImageView setupAutoHeightWithBottomView:view2 bottomMargin:10];
        
        __weak __typeof(_headImageView)weakSelf = _headImageView;
        _headImageView.didFinishAutoLayoutBlock=^(CGRect rect){
            //NSLog(@">>>>%f",rect.size.height+rect.origin.y);
            weakSelf.sd_layout
            .heightIs( rect.size.height+rect.origin.y);
        };
    }
    return _headImageView;
}
//竞买留言区数据解析
-(void)buyLiuYanQuResponseInfoDic:(NSDictionary*)ResInfoDic{
    NSArray * contenArr =[ResInfoDic objectForKey:@"content"];
    for (NSDictionary * dicc in contenArr) {
        ZaiXianModel * md =[[ZaiXianModel alloc]initWithLiuYanZhuanQu:dicc];
        [_dataArray1 addObject:md];
    }
     [_tableView reloadData];
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
        [LCProgressHUD showMessage:@"请您先登录在拍卖"];
        return;
    }
    
  
    
   //3.出价记录
    NSDictionary  * param =@{@"auction_id":@"12",@"target_id":@"10",@"user_id":token,@"bid_money":[NSString stringWithFormat:@"%d",_daoQianTag]};
    NSDictionary * dicc =@{@"action":@"app_bidToTargetCompete",@"param":param};
    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
    
    [Engine socketLianJieJsonStr:jsonStr success:^(NSDictionary *dic) {
        
            NSLog(@"3出价记录%@",dic);
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
                    
                    if (_currentIndex==0) {
                        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                        [_dataArray0 insertObject:mode atIndex:0];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                        [indexPaths addObject: indexPath];
                        [self.tableView beginUpdates];
                        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                        [self.tableView endUpdates];
                    }else{
                         [_dataArray0 insertObject:mode atIndex:0];
                        [_tableView reloadData];
                    }
                   
                    
                    
                    
                    _priceLabel.text=mode.moneyName;
                    _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",mode.moneyName];
                    _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",mode.jingPaiNum];
                }
                //更新推送时间
                 if ([push_scene isEqualToString:@"resetCountDown"]){
                    NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                    [self timeDaoJiShi:push_content Label:_starLabel uiview:_bgView];
                }
                //更新当前出价
                _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
            //更新留言记录
                //推送的留言
                if ([push_scene isEqualToString:@"newSpeakRecord"]) {
                    NSDictionary * contentDic =[pushInfoDic objectForKey:@"push_content"];
                    ZaiXianModel * md =[[ZaiXianModel alloc]initWithLiuYanZhuanQu:contentDic];
                    if (_currentIndex==1) {
                        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                        [_dataArray1 insertObject:md atIndex:0];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        [indexPaths addObject: indexPath];
                        [self.tableView beginUpdates];
                        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                        [self.tableView endUpdates];
                    }
                    else{
                        [_dataArray1 insertObject:md atIndex:0];
                    }
                    
                }
                
                
                

                
            }
        
        
    }];
    
    
    
    
    
    
}
#pragma mark --区头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}
#pragma mark --行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentIndex==0) {
        return 44;
    }else{
         return [_tableView cellHeightForIndexPath:indexPath model:_dataArray1[indexPath.row] keyPath:@"model" cellClass:[LiuYanZhuanQuCell class] contentViewWidth:[ToolClass  cellContentViewWith]];;
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
#pragma mark --点击区头 0  1
-(void)refreshHeadLine:(NSInteger)currentIndex
{
    _currentIndex=currentIndex;
    if (currentIndex==0) {
        [_liuYanView removeFromSuperview];
        _tableView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    }else{
         [self CreatLiuYan];
        _liuYanView.hidden=NO;
        _tableView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-50);
        if (_dataArray1.count==0) {
            NSLog(@"等于0了");
            [self liuYanZhuanQu];
        }
        
        
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
            if ([md.jingPaiNum isEqualToString:@""]) {
                cell.leftLabel.text=@"暂无";
            }else{
                 cell.leftLabel.text=md.jingPaiNum;
            }
            cell.centerLabel.text=md.moneyName;
            cell.rightLabel.text=md.timeName;
        }
        
        return cell;
        
    }else if(_currentIndex==1){
        static NSString *reusID=@"ID";
        
        LiuYanZhuanQuCell * cell =[LiuYanZhuanQuCell cellWithTableView:_tableView CellID:reusID];
        cell.model=_dataArray1[indexPath.row];
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
