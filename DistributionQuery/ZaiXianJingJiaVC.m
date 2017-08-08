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
#import "AlertViewXY.h"
#import "UIColor+Wonderful.h"
#import "SXMarquee.h"
#import "SXHeadLine.h"
//颜色
@interface ZaiXianJingJiaVC ()<headLineDelegate,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate>
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
@property(nonatomic,strong)UITextField * priceLabel;//数字的价格
@property(nonatomic,assign)int daoQianTag;//记录当前价格(加 或者 减过的)
//
@property(nonatomic,strong)UIButton * butn1;
@property(nonatomic,strong)UIButton * butn2;
@property(nonatomic,strong)UIButton * butn3;
@property(nonatomic,strong)UIButton * butn4;
@property(nonatomic,strong)UIButton * butn5;
@property(nonatomic,strong)UIButton * butn6;

@property(nonatomic,strong)UILabel * priceYuan;// 元  万
//dangQianLab
//peopleLab
@property(nonatomic,strong)UILabel * dangQianLab;//当前出价
@property(nonatomic,assign)int dangqianprice;//当钱出价，数字！(最上面的当前出价)
@property(nonatomic,strong)UILabel* peopleLab;//记录出价人

@property(nonatomic,strong)UILabel * starLabel;//倒计时标题
@property(nonatomic,strong)UIView *bgView;//倒计时背景色

@property(nonatomic,strong)UITextField *liuYanTextfield;//留言版
@property(nonatomic,strong) UIAlertController * actionview;//自动关闭的弹框

//s15接口，弹框自动关闭
@property(nonatomic,assign)int secondsCountDown;
@property(nonatomic,strong)NSTimer * countDownTimer;
@property(nonatomic,strong)AlertViewXY * actionView;
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
//-(void)sendContent{
//    
//   
//    
//    NSDictionary  * param =@{@"auction_id":_paiMaiID,@"target_id":_biaoDiID,@"user_id":@"22",@"speak_content":_liuYanTextfield.text,@"dataSource":_dataSoure};
//    NSDictionary * dicc =@{@"action":@"app_speakInCompetePage",@"param":param};
//    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
//    [Engine socketLianJieJsonStr:jsonStr success:^(NSDictionary *dic) {
//        NSLog(@"发言的内容%@",dic);
//        NSString * msg_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg_type"]];
//       //请求对应的部分
//        if ([msg_type isEqualToString:@"response"]) {
//            NSDictionary * responseInfoDic =[dic objectForKey:@"responseInfo"];
//            NSString * action =[NSString stringWithFormat:@"%@",[responseInfoDic objectForKey:@"action"]];
//            NSString * code =[NSString stringWithFormat:@"%@",[responseInfoDic objectForKey:@"code"]];
//            [LCProgressHUD showMessage:[responseInfoDic objectForKey:@"msg"]];
//            if ([action isEqualToString:@"app_speakInCompetePage"] && [code isEqualToString:@"1"]) {
//                _liuYanTextfield.text=@"";
//                [_liuYanTextfield resignFirstResponder];
//            }
//
//        }//推送部分
//        else if ([msg_type isEqualToString:@"push"]){
//            NSDictionary * pushInfoDic =[dic objectForKey:@"pushInfo"];
//            NSDictionary * contentDic =[pushInfoDic objectForKey:@"push_content"];
//            ZaiXianModel * md =[[ZaiXianModel alloc]initWithLiuYanZhuanQu:contentDic];
//            if (_currentIndex==1) {
//                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//                [_dataArray1 insertObject:md atIndex:0];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                [indexPaths addObject: indexPath];
//                [self.tableView beginUpdates];
//                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//                [self.tableView endUpdates];
//                [_tableView reloadData];
//            }else if (_currentIndex==0){
//                 [_dataArray1 insertObject:md atIndex:0];
//                [_tableView reloadData];
//            }
//            
//        }
//        
//    }];
//}



#pragma mark --倒计时暂停区域(无倒计时)
-(void)timeDaoJiShi:(NSDictionary*)contentDic  Label:(UILabel*)starLabel uiview:(UIView*)bgView{
    
    NSString * buttonColor =[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"button_color_type"]];
    if ([buttonColor isEqualToString:@"1"]) {
        //红色正常状态
        _butn1.enabled = YES;
        _butn2.enabled = YES;
        _butn3.enabled = YES;
        _butn4.enabled = YES;
        _butn5.enabled = YES;
        _butn6.enabled = YES;
        self.priceLabel.enabled=YES;
        _butn3.backgroundColor=[UIColor redColor];;
        _butn4.backgroundColor=[UIColor redColor];
        _butn5.backgroundColor=[UIColor redColor];
        _butn6.backgroundColor=[UIColor redColor];
    }else if ([buttonColor isEqualToString:@"2"]){
        //蓝色
    }else if ([buttonColor isEqualToString:@"3"]){
        //灰色不能点击
        _butn1.enabled = NO;
        _butn2.enabled = NO;
        _butn3.enabled = NO;
        _butn4.enabled = NO;
        _butn5.enabled = NO;
        _butn6.enabled = NO;
        self.priceLabel.enabled=NO;
        _butn3.backgroundColor=JXColor(151, 151, 151, 1);
        _butn4.backgroundColor=JXColor(151, 151, 151, 1);
        _butn5.backgroundColor=JXColor(151, 151, 151, 1);
        _butn6.backgroundColor=JXColor(151, 151, 151, 1);
        
    }
    
    
    
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
            strTime=0;
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
    NSDictionary  * param =@{@"auction_id":_paiMaiID,@"target_id":_biaoDiID,@"dataSource":_dataSoure};
    NSDictionary * dicc =@{@"action":@"app_qryUserCompeteRecord",@"param":param};
    NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
    [Engine socketLianJieJsonStr:jsonStr success:^(NSDictionary *dic) {
        
    }];
    //2.请求时间的22 102
    NSDictionary  * param2 =@{@"auction_id":_paiMaiID,@"target_id":_biaoDiID,@"dataSource":_dataSoure};
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
                // 68.4 >>
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
                         _priceLabel.text=model.moneyPrice;
//                        if ([model.moneyPrice intValue]>10000) {
//                            _priceLabel.text=[NSString stringWithFormat:@"%.2f",[model.moneyPrice floatValue]/10000];
//                            _priceYuan.text=@"万";
//                        }else
//                        {
//                           
//                              _priceYuan.text=@"元";
//
//                        }
                        
                        
                        _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",model.moneyName];
                        _dangqianprice=[model.moneyPrice intValue];
                        _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",model.jingPaiNum];
                        _daoQianTag=[model.moneyPrice intValue];
                    }else{
                        
                        if ([_diJia floatValue]>10000) {
                            _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%.2f万",[_diJia floatValue]/10000];
                             _dangqianprice=[_diJia intValue];
                          //  _priceLabel.text=[NSString stringWithFormat:@"%.2f万",[_diJia floatValue]/10000];
                             _priceLabel.text=[NSString stringWithFormat:@"%d",[_diJia intValue]];
                        }else{
                            _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%d元",[_diJia intValue]];
                            _dangqianprice=[_diJia intValue];
                            _priceLabel.text=[NSString stringWithFormat:@"%d",[_diJia intValue]];
                        }
                        
                       
                        //_dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",@"暂无"];
                        _daoQianTag=[_diJia intValue];
                        _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",@"暂无"];
                          _dangqianprice=[_diJia intValue];
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
                //弹框
                if ([push_scene isEqualToString:@"confirm"]) {
                    
                    NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                    NSString * confirm_msg=[push_content objectForKey:@"confirm_msg"];
                    NSString *confirm_scene =[push_content objectForKey:@"confirm_scene"];
                    if ([confirm_scene isEqualToString:@"whetherEnterNextTargetCompete"]) {
                        UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"" message:confirm_msg preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * action =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSDictionary * yes_content=[push_content objectForKey:@"yes_content"];
                            //拍卖会ID
                            NSString * paiMaiHuiID =[NSString stringWithFormat:@"%@",[yes_content objectForKey:@"auction_id"]];
                            //标的id
                            NSString * baiDiID =[NSString stringWithFormat:@"%@",[yes_content objectForKey:@"next_target_id"]];
                            NSLog(@"拍卖会ID>>>>%@标的id>>>%@",paiMaiHuiID,baiDiID);
                            [NSUSE_DEFO setObject:paiMaiHuiID forKey:@"PMHID"];
                            [NSUSE_DEFO setObject:baiDiID forKey:@"BDID"];
                            [NSUSE_DEFO synchronize];
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        [actionview addAction:action];
                        [actionview addAction:action2];
                        [self presentViewController:actionview animated:YES completion:nil];
                    }
                    
                }else if ([push_scene isEqualToString:@"remind"]){
                    [self ZhongBianJieKou15:pushInfoDic];
                }
                
                
                
                
                
                
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
                    
                    
                    
                      _priceLabel.text=mode.moneyPrice;
                    
//                    if ([mode.moneyPrice intValue]>10000) {
//                        _priceLabel.text=[NSString stringWithFormat:@"%.2f",[mode.moneyPrice floatValue]/10000];
//                        _priceYuan.text=@"万";
//                    }else
//                    {
//                         _priceLabel.text=mode.moneyPrice;
//                        _priceYuan.text=@"元";
//                        
//                    }
                    
                    _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",mode.moneyName];
                    _dangqianprice=[mode.moneyPrice intValue];
                    _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",mode.jingPaiNum];
                }
                //更新竞价记录
                if ([push_scene isEqualToString:@"redisplay_compete_record"]) {
                    [_dataArray0 removeAllObjects];
                    NSArray * contentArr =[pushInfoDic objectForKey:@"push_content"];
                    for (NSDictionary * dicc in contentArr) {
                        ZaiXianModel * model =[[ZaiXianModel alloc]initWithChuJiaJiluDic:dicc];
                        [_dataArray0 addObject:model];
                    }
                    //当前出价
                    if (_dataArray0.count!=0) {
                        ZaiXianModel * model=_dataArray0[0];
                        _priceLabel.text=model.moneyPrice;
                        
//                        if ([model.moneyPrice intValue]>10000) {
//                            _priceLabel.text=[NSString stringWithFormat:@"%.2f",[model.moneyPrice floatValue]/10000];
//                            _priceYuan.text=@"万";
//                        }else
//                        {
//                            _priceLabel.text=model.moneyPrice;
//                            _priceYuan.text=@"元";
//                            
//                        }
                        
                        
                        _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",model.moneyName];
                        _dangqianprice=[model.moneyPrice intValue];
                        _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",model.jingPaiNum];
                    }else{
                        if ([_diJia floatValue]>10000) {
                            _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%.2f万",[_diJia floatValue]/10000];
                          _priceLabel.text=[NSString stringWithFormat:@"%d",[_diJia intValue]];
                        }else{
                            _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%d元",[_diJia intValue]];
                            _priceLabel.text=[NSString stringWithFormat:@"%d",[_diJia intValue]];
                        }
                        //_dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",@"暂无"];
                        _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",@"暂无"];
                    }
                    _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
                    _dangqianprice=[_diJia intValue];
                    [_tableView reloadData];
                }
                
                _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
                //推送的弹框提醒
                if ([push_scene isEqualToString:@"remind"]) {
                    NSDictionary * contentDic =[pushInfoDic objectForKey:@"push_content"];
                    //消息内容
                    NSString * mesg =[contentDic objectForKey:@"remind_msg"];
                    [self alertViewControleventMessage:mesg];
                    //判断是不是自动关闭 0不自动关闭 1自动关闭
                    NSString * colseStr =[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"autoClose"]];
                    if ([colseStr isEqualToString:@"1"]) {
                        //自动关闭
                        //获取推送时间
                        NSString * timeMiao =[contentDic objectForKey:@"remind_duration_time"];
                        [self performSelector:@selector(dissMissTanKuang) withObject:self afterDelay:[timeMiao intValue]/1000];
                    }
                    
                }
                
                
                
                
                
                
                
                
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
                
                
                
                
            }
            
            
            
            
            
            
            
            
        
        
        
    }];
    
    
    
   // [self liuYanZhuanQu];

}



-(void)ZhongBianJieKou15:(NSDictionary*)pushinfo{
    //弹框15提醒
    NSDictionary * push_content =[pushinfo objectForKey:@"push_content"];
    //是否自动关闭
    NSString * autoClose=[NSString stringWithFormat:@"%@",[push_content objectForKey:@"autoClose"]];//
    
    if ([autoClose isEqualToString:@"0"]) {
        //不自动关闭
        AlertViewXY * xy =[[AlertViewXY alloc]initWithTitle:@"温馨提示" contentName:[push_content objectForKey:@"remind_msg"] achiveBtn:@"确定"];
        
        [xy show];
    }else{
        //自动关闭
        NSString * time11 =[NSString stringWithFormat:@"%@",[push_content objectForKey:@"remind_duration_time"]];
        _secondsCountDown=[time11 intValue]/1000;
        //
        AlertViewXY * xy =[[AlertViewXY alloc]initWithTitle:@"温馨提示" contentName:[push_content objectForKey:@"remind_msg"] achiveBtn:@"确定"];
        _actionView=xy;
        
        [xy show];
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    }
    

}
-(void)timeFireMethod{
    //倒计时-1
    _secondsCountDown--;
    //修改倒计时标签现实内容
    // _actionView.message=[NSString stringWithFormat:@"剩余%d秒将自动关闭",_secondsCountDown];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(_secondsCountDown==0){
        [_countDownTimer invalidate];
        [_actionView dissmiss];
    }
    
    
}

//提示框
-(void)alertViewControleventMessage:(NSString*)message{
    UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    _actionview=actionview;
    UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionview addAction:action2];
    [self presentViewController:actionview animated:YES completion:nil];
}
-(void)dissMissTanKuang{
    NSLog(@"弹框消失了啊");
    [_actionview dismissViewControllerAnimated:YES completion:nil];
}

-(void)liuYanZhuanQu{
    //4.请求留言专区的
    NSDictionary  * param1 =@{@"auction_id":_paiMaiID,@"target_id":_biaoDiID,@"dataSource":_dataSoure};
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
                    _priceLabel.text=model.moneyPrice;
                    
//                    if ([model.moneyPrice intValue]>10000) {
//                        _priceLabel.text=[NSString stringWithFormat:@"%.2f",[model.moneyPrice floatValue]/10000];
//                        _priceYuan.text=@"万";
//                    }else
//                    {
//                        _priceLabel.text=model.moneyPrice;
//                        _priceYuan.text=@"元";
//                        
//                    }
                    
                    _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",model.moneyName];
                    _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",model.jingPaiNum];
                     _daoQianTag=[model.moneyPrice intValue];
                    _dangqianprice=[model.moneyPrice intValue];
                }else{
                    if ([_diJia floatValue]>10000) {
                        _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%.2f万",[_diJia floatValue]/10000];
                         _priceLabel.text=[NSString stringWithFormat:@"%d",[_diJia intValue]];
                    }else{
                        _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%d元",[_diJia intValue]];
                        _priceLabel.text=[NSString stringWithFormat:@"%d",[_diJia intValue]];
                    }
                    _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",@"暂无"];
                    _dangqianprice=[_diJia intValue];
                }
                 _daoQianTag=[_diJia intValue];
                _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
//                _dangqianprice=[_dangQianLab.text intValue];
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
          
            //弹框
            if ([push_scene isEqualToString:@"confirm"]) {
                
                NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                NSString * confirm_msg=[push_content objectForKey:@"confirm_msg"];
                NSString *confirm_scene =[push_content objectForKey:@"confirm_scene"];
                if ([confirm_scene isEqualToString:@"whetherEnterNextTargetCompete"]) {
                    UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"" message:confirm_msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSDictionary * yes_content=[push_content objectForKey:@"yes_content"];
                        //拍卖会ID
                        NSString * paiMaiHuiID =[NSString stringWithFormat:@"%@",[yes_content objectForKey:@"auction_id"]];
                        //标的id
                        NSString * baiDiID =[NSString stringWithFormat:@"%@",[yes_content objectForKey:@"next_target_id"]];
                        NSLog(@"拍卖会ID>>>>%@标的id>>>%@",paiMaiHuiID,baiDiID);
                       
                        [NSUSE_DEFO setObject:paiMaiHuiID forKey:@"PMHID"];
                        [NSUSE_DEFO setObject:baiDiID forKey:@"BDID"];
                        [NSUSE_DEFO synchronize];
                        [self.navigationController popViewControllerAnimated:YES];
                        //[_tableView setTableHeaderView:[self headImageView]];
                    }];
                    UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [actionview addAction:action];
                    [actionview addAction:action2];
                    [self presentViewController:actionview animated:YES completion:nil];
                }
                
            }else if ([push_scene isEqualToString:@"remind"]){
                [self ZhongBianJieKou15:pushInfoDic];
            }
            
            
            
            
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
                
                
                 _priceLabel.text=mode.moneyPrice;
              
//                if ([mode.moneyPrice intValue]>10000) {
//                    _priceLabel.text=[NSString stringWithFormat:@"%.2f",[mode.moneyPrice floatValue]/10000];
//                    _priceYuan.text=@"万";
//                }else
//                {
//                     _priceLabel.text=mode.moneyPrice;
//                    _priceYuan.text=@"元";
//                    
//                }
                
                
                _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",mode.moneyName];
                _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",mode.jingPaiNum];
                _dangqianprice=[mode.moneyPrice intValue];
                 _daoQianTag=[mode.moneyPrice intValue];
            }
            
            
            //推送的弹框提醒
            if ([push_scene isEqualToString:@"remind"]) {
                NSDictionary * contentDic =[pushInfoDic objectForKey:@"push_content"];
                //消息内容
                NSString * mesg =[contentDic objectForKey:@"remind_msg"];
                [self alertViewControleventMessage:mesg];
                //判断是不是自动关闭 0不自动关闭 1自动关闭
                NSString * colseStr =[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"autoClose"]];
                if ([colseStr isEqualToString:@"1"]) {
                    //自动关闭
                    //获取推送时间
                    NSString * timeMiao =[contentDic objectForKey:@"remind_duration_time"];
                    [self performSelector:@selector(dissMissTanKuang) withObject:self afterDelay:[timeMiao intValue]/1000];
                }
                
            }

            
            
            
            
            
            //更新竞价记录
            if ([push_scene isEqualToString:@"redisplay_compete_record"]) {
                [_dataArray0 removeAllObjects];
                NSArray * contentArr =[pushInfoDic objectForKey:@"push_content"];
                for (NSDictionary * dicc in contentArr) {
                    ZaiXianModel * model =[[ZaiXianModel alloc]initWithChuJiaJiluDic:dicc];
                    [_dataArray0 addObject:model];
                }
                //当前出价
                if (_dataArray0.count!=0) {
                    ZaiXianModel * model=_dataArray0[0];
                    _priceLabel.text=model.moneyPrice;
                    
//                    if ([model.moneyPrice intValue]>10000) {
//                        _priceLabel.text=[NSString stringWithFormat:@"%.2f",[model.moneyPrice floatValue]/10000];
//                        _priceYuan.text=@"万";
//                    }else
//                    {
//                        _priceLabel.text=model.moneyPrice;
//                        _priceYuan.text=@"元";
//                        
//                    }

                    
                    
                    
                    _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",model.moneyName];
                    _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",model.jingPaiNum];
                    _dangqianprice=[model.moneyPrice intValue];
                }else{
                    if ([_diJia floatValue]>10000) {
                        _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%.2f万",[_diJia floatValue]/10000];
//                        _priceLabel.text=[NSString stringWithFormat:@"%.2f",[_diJia floatValue]/10000];
                        _priceLabel.text=[NSString stringWithFormat:@"%d",[_diJia intValue]];
//                        _priceYuan.text=@"万";
                    }else{
                        _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%d元",[_diJia intValue]];
                        _priceLabel.text=[NSString stringWithFormat:@"%d",[_diJia intValue]];
//                        _priceYuan.text=@"元";
                    }
                    //_dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",@"暂无"];
                    _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",@"暂无"];
                   
                }
                _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
//                _dangqianprice=[_dangQianLab.text intValue];
                 _dangqianprice=[_diJia intValue];
                [_tableView reloadData];
            }
            

            
            
            
            
            _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
//            _dangqianprice=[_dangQianLab.text intValue];
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
//        NSString * str =[NSString stringWithFormat:@"您的竞买牌号是%@",_jingMaiPai];
//        
//        SXMarquee *mar = [[SXMarquee alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35) speed:4 Msg:str bgColor:[UIColor whiteColor] txtColor:[UIColor redColor]];;
//        [mar changeMarqueeLabelFont:[UIFont systemFontOfSize:14]];
//        [mar changeTapMarqueeAction:^{
////            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"点击事件" message:@"可以设置弹窗，当然也能设置别的" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
////            [alert show];
//        }];
//        [mar start];
//        
//        [_headImageView addSubview:mar];
        
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
        
        UILabel * namelaebl =[UILabel new];
        namelaebl.text=[NSString stringWithFormat:@"您的竞买号牌:%@",_jingMaiPai];
         namelaebl.textColor=[UIColor redColor];
        namelaebl.textAlignment=2;
        namelaebl.alpha=.6;
        namelaebl.attributedText= [ToolClass attrStrFrom:namelaebl.text intFond:14 Color:[UIColor blackColor] numberStr:@"您的竞买号牌:"];
        namelaebl.font=[UIFont systemFontOfSize:14];
        [view1 sd_addSubviews:@[namelaebl]];
        namelaebl.sd_layout
        .leftEqualToView(titleLabel)
        .topSpaceToView(titleLabel,10)
        .rightSpaceToView(view1,15)
        .heightIs(20);
        
        
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
        .topSpaceToView(namelaebl,10)
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
        _butn1=jianBtn;
        [jianBtn setBackgroundImage:[UIImage imageNamed:@"zaixian_jia"] forState:0];
        [view2 sd_addSubviews:@[jianBtn]];
        jianBtn.sd_layout
        .leftSpaceToView(dangQianLab2,15)
        .centerYEqualToView(dangQianLab2)
        .widthIs(70/2)
        .heightIs(70/2);
        //数字价钱
        UITextField * priceLabel =[UITextField new];
        _priceLabel=priceLabel;
        priceLabel.delegate=self;
        _priceLabel.keyboardType=UIKeyboardTypeNumberPad;
        priceLabel.layer.borderWidth=1;
        priceLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
        priceLabel.alpha=.8;
        priceLabel.textAlignment=1;
        NSLog(@"这是低价格>>>%@",_diJia);
        
        priceLabel.font=[UIFont systemFontOfSize:18];
        [view2 sd_addSubviews:@[priceLabel]];
        if (ScreenWidth==320) {
            priceLabel.sd_layout
            .leftSpaceToView(jianBtn,0)
            .centerYEqualToView(jianBtn)
            .heightRatioToView(jianBtn,1)
            .widthIs(80);

        }else{
            priceLabel.sd_layout
            .leftSpaceToView(jianBtn,0)
            .centerYEqualToView(jianBtn)
            .heightRatioToView(jianBtn,1)
            .widthIs(150);

        }
        
        
        UILabel * yuanLable =[UILabel new];
        _priceYuan=yuanLable;
//        if ([_diJia floatValue]>10000) {
//            priceLabel.text=[NSString stringWithFormat:@"%.2f",[_diJia floatValue]/10000];
//            yuanLable.text=@"万";
//        }else{
            priceLabel.text=[NSString stringWithFormat:@"%d",[_diJia intValue]];
             yuanLable.text=@"元";
        
     //   }
        
        yuanLable.textAlignment=1;
        [view2 sd_addSubviews:@[yuanLable]];
        yuanLable.sd_layout
        .leftSpaceToView(priceLabel,0)
        .centerYEqualToView(priceLabel)
        .widthRatioToView(jianBtn,1)
        .heightRatioToView(jianBtn,1);
        //加
        UIButton * addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _butn2=addBtn;
        [addBtn setBackgroundImage:[UIImage imageNamed:@"zaixian_jian"] forState:0];
        [view2 sd_addSubviews:@[addBtn]];
        addBtn.sd_layout
        .leftSpaceToView(yuanLable,0)
        .centerYEqualToView(priceLabel)
        .widthRatioToView(jianBtn,1)
        .heightRatioToView(jianBtn,1);
        //200
        UIButton * twoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        twoBtn.backgroundColor=[UIColor redColor];//[UIColor redColor];
        [twoBtn setTitle:[NSString stringWithFormat:@"+%@",_price1] forState:0];
        _butn3=twoBtn;
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
        _butn4=wubaiBtn;
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
        _butn5=yiqianBtn;
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
        [btnSure setTitle:@"确认出价" forState:0];
        btnSure.titleLabel.font=[UIFont systemFontOfSize:15];
//        [btnSure setBackgroundImage:[UIImage imageNamed:@"zaixian_bt7"] forState:0];
        _butn6=btnSure;
        [view2 sd_addSubviews:@[btnSure]];
        [btnSure addTarget:self action:@selector(chuJiaPrice) forControlEvents:UIControlEventTouchUpInside];
        btnSure.sd_layout
        .leftEqualToView(twoBtn)
        .topSpaceToView(twoBtn,15)
        .widthIs(466/2)
        .heightIs(58/2);
        [view2 setupAutoHeightWithBottomView:btnSure bottomMargin:10];
        
        if (ScreenWidth==320) {
            twoBtn.sd_layout
            .leftSpaceToView(view2,50)
            .topSpaceToView(jianBtn,20)
            .widthIs(126/2)
            .heightIs(25);
            
            wubaiBtn.sd_layout
            .leftSpaceToView(twoBtn,15)
            .centerYEqualToView(twoBtn)
            .widthIs(126/2)
            .heightIs(25);
            
            yiqianBtn.sd_layout
            .leftSpaceToView(wubaiBtn,15)
            .centerYEqualToView(twoBtn)
            .widthIs(126/2)
            .heightIs(25);

            
            btnSure.sd_layout
            .leftEqualToView(twoBtn)
            .topSpaceToView(twoBtn,15)
            .widthIs(466/2)
            .heightIs(58/2);
        }
        
        
        
 
        
        
        
        
        
        [_headImageView setupAutoHeightWithBottomView:view2 bottomMargin:10];
        
        __weak __typeof(_headImageView)weakSelf = _headImageView;
        __weak __typeof(self)weakSelf2 = self;
        _headImageView.didFinishAutoLayoutBlock=^(CGRect rect){
            //NSLog(@">>>>%f",rect.size.height+rect.origin.y);
            weakSelf.sd_layout
            .heightIs( rect.size.height+rect.origin.y);
            weakSelf2.tableView.tableHeaderView=[weakSelf2 headImageView];
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
    _priceLabel.text=[NSString stringWithFormat:@"%d",d];
}
-(void)jianBtnClick{
    int d ;
    if (_daoQianTag==0) {
        d=[_priceLabel.text intValue]-100;
    }else{
        d =_daoQianTag-100;
    }
    
    _daoQianTag=d;
    _priceLabel.text=[NSString stringWithFormat:@"%d",d];
}
-(void)jiaBtn2{
    int d ;
    if (_daoQianTag==0) {
        d=[_priceLabel.text intValue];
    }else{
        d =_daoQianTag;
    }
    _daoQianTag=d+[_price1 intValue];
    _priceLabel.text=[NSString stringWithFormat:@"%d",_daoQianTag];
    
    
}
-(void)jiaBtn3{
    int d ;
    if (_daoQianTag==0) {
        d=[_priceLabel.text intValue];
    }else{
        d =_daoQianTag;
    }
    _daoQianTag=d+[_price2 intValue];
    _priceLabel.text=[NSString stringWithFormat:@"%d",_daoQianTag];
}
-(void)jiaBtn4{
    int d ;
    if (_daoQianTag==0) {
        d=[_priceLabel.text intValue];
    }else{
        d =_daoQianTag;
    }
    _daoQianTag=d+[_price3 intValue];
    _priceLabel.text=[NSString stringWithFormat:@"%d",_daoQianTag];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([ToolClass isPureInt:textField.text]) {
        _daoQianTag=[textField.text intValue];
    }else{
        [LCProgressHUD showMessage:@"请输入正确的价格"];
        _daoQianTag=0;
    }
    
//    NSLog(@"开始输入的时候>>>%@",textField.text);
//

}

#pragma mark --确认出价
-(void)chuJiaPrice{
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"请您先登录在拍卖"];
        return;
    }
//    NSLog(@"现在价格>>%d之前的价格>>>%d",_daoQianTag,_dangqianprice);
   
    NSString * idd=@"";
    if (_dataArray0.count==0) {
        idd=@"";
    }else{
        ZaiXianModel * model=_dataArray0[0];
        idd=model.userID;
    }
//    NSLog(@">>>%@",model.userID);
    NSString * priceStr =nil;
    if (_daoQianTag>10000) {
        float c =_daoQianTag;
        priceStr=[NSString stringWithFormat:@"确认出价%.2f万",c/10000];
    }else{
        priceStr=[NSString stringWithFormat:@"确认出价%d元",_daoQianTag];
    }

//    @""
    NSDictionary  * param =@{@"auction_id":_paiMaiID,@"target_id":_biaoDiID,@"user_id":token,@"bid_money":[NSString stringWithFormat:@"%d",_daoQianTag],@"dataSource":_dataSoure};
    
    if (_daoQianTag>_dangqianprice*2) {
        UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您的价格超过当前价格2倍以上，您%@",priceStr] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self queRenChuJiaDic:param];
        }];
        UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [actionview addAction:action];
        [actionview addAction:action2];
        [self presentViewController:actionview animated:YES completion:nil];
    }else if ([idd isEqualToString:token] && ![idd isEqualToString:@""]){
        
        NSString * str=[NSString stringWithFormat:@"当前最高的价格%d是您的，您又将出价超出当前价格，您确定出价%d元",_dangqianprice,_daoQianTag];
        
        UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self queRenChuJiaDic:param];
        }];
        UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [actionview addAction:action];
        [actionview addAction:action2];
        [self presentViewController:actionview animated:YES completion:nil];
    }
    else{
        UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"温馨提示" message:priceStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self queRenChuJiaDic:param];
        }];
        UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [actionview addAction:action];
        [actionview addAction:action2];
        [self presentViewController:actionview animated:YES completion:nil];
    }
    
    
    
    
}


-(void)queRenChuJiaDic:(NSDictionary*)param{
    
    
        //3.出价记录
//        NSDictionary  * param =@{@"auction_id":_paiMaiID,@"target_id":_biaoDiID,@"user_id":token,@"bid_money":[NSString stringWithFormat:@"%d",_daoQianTag]};
        NSDictionary * dicc =@{@"action":@"app_bidToTargetCompete",@"param":param};
        NSString * jsonStr =[ToolClass getJsonStringFromObject:dicc];
        
        [Engine socketLianJieJsonStr:jsonStr success:^(NSDictionary *dic) {
            NSLog(@"3出价记录%@",dic);
            NSString * msg_type =[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg_type"]];
            //请求接口相应状态
            if ([msg_type isEqualToString:@"response"]) {
                NSLog(@"111111111111111111111111111111");
                NSDictionary * responseInfoDic=[dic objectForKey:@"responseInfo"];
                NSString * action =[responseInfoDic objectForKey:@"action"];
                //app_bidToTargetCompete代表的是出价状态
                if ([action isEqualToString:@"app_bidToTargetCompete"]) {
                    [self wenXinTiShiMsg:[responseInfoDic objectForKey:@"msg"]];
                }
                
            }//推送状态
            else if ([msg_type isEqualToString:@"push"]){
                
                 NSLog(@"22222222222222222222222");
                
                NSDictionary * pushInfoDic =[dic objectForKey:@"pushInfo"];
                NSString * push_scene =[NSString stringWithFormat:@"%@",[pushInfoDic objectForKey:@"push_scene"]];
                
                //弹框
                if ([push_scene isEqualToString:@"confirm"]) {
                    
                    NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                    NSString * confirm_msg=[push_content objectForKey:@"confirm_msg"];
                    NSString *confirm_scene =[push_content objectForKey:@"confirm_scene"];
                    if ([confirm_scene isEqualToString:@"whetherEnterNextTargetCompete"]) {
                        UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"" message:confirm_msg preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * action =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSDictionary * yes_content=[push_content objectForKey:@"yes_content"];
                            //拍卖会ID
                            NSString * paiMaiHuiID =[NSString stringWithFormat:@"%@",[yes_content objectForKey:@"auction_id"]];
                            //标的id
                            NSString * baiDiID =[NSString stringWithFormat:@"%@",[yes_content objectForKey:@"next_target_id"]];
                            NSLog(@"拍卖会ID>>>>%@标的id>>>%@",paiMaiHuiID,baiDiID);
                            [NSUSE_DEFO setObject:paiMaiHuiID forKey:@"PMHID"];
                            [NSUSE_DEFO setObject:baiDiID forKey:@"BDID"];
                            [NSUSE_DEFO synchronize];
                            [self.navigationController popViewControllerAnimated:YES];
                            // [_tableView setTableHeaderView:[self headImageView]];
                        }];
                        UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        [actionview addAction:action];
                        [actionview addAction:action2];
                        [self presentViewController:actionview animated:YES completion:nil];
                    }
                    
                }else if ([push_scene isEqualToString:@"remind"]){
                    [self ZhongBianJieKou15:pushInfoDic];
                }
                
                
                
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
                    
                    
                    
                    _daoQianTag=[mode.moneyPrice intValue];
                    _priceLabel.text=mode.moneyPrice;
                    
                    _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",mode.moneyName];
                    _dangqianprice=[mode.moneyPrice intValue];
                    _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",mode.jingPaiNum];
                }
                
                //更新竞价记录
                if ([push_scene isEqualToString:@"redisplay_compete_record"]) {
                    [_dataArray0 removeAllObjects];
                    NSArray * contentArr =[pushInfoDic objectForKey:@"push_content"];
                    for (NSDictionary * dicc in contentArr) {
                        ZaiXianModel * model =[[ZaiXianModel alloc]initWithChuJiaJiluDic:dicc];
                        [_dataArray0 addObject:model];
                    }
                    //当前出价
                    if (_dataArray0.count!=0) {
                        ZaiXianModel * model=_dataArray0[0];
                        _priceLabel.text=model.moneyPrice;
                        
                        _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%@",model.moneyName];
                        _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",model.jingPaiNum];
                        _daoQianTag=[model.moneyPrice intValue];
                        _dangqianprice=[model.moneyPrice intValue];
                    }else{
                        
                        if ([_diJia floatValue]>10000) {
                            _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%.2f万",[_diJia floatValue]/10000];
                            _priceLabel.text=[NSString stringWithFormat:@"%d",[_diJia intValue]];
                            
                        }else{
                            _dangQianLab.text=[NSString stringWithFormat:@"当前出价：%d元",[_diJia intValue]];
                            _priceLabel.text=[NSString stringWithFormat:@"%d",[_diJia intValue]];
                        }
                        
                        _peopleLab.text=[NSString stringWithFormat:@"出价人：%@",@"暂无"];
                         _dangqianprice=[_diJia intValue];
                    }
                    _daoQianTag=[_diJia intValue];
                    _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
                    [_tableView reloadData];
                }
                
                
                
                
                //更新推送时间
                if ([push_scene isEqualToString:@"resetCountDown"]){
                    NSDictionary * push_content =[pushInfoDic objectForKey:@"push_content"];
                    [self timeDaoJiShi:push_content Label:_starLabel uiview:_bgView];
                }
                //更新当前出价
                _dangQianLab.attributedText= [ToolClass attrStrFrom:_dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
                
//                _dangqianprice=[_dangQianLab.text intValue];
                //推送的弹框提醒
                if ([push_scene isEqualToString:@"remind"]) {
                    NSDictionary * contentDic =[pushInfoDic objectForKey:@"push_content"];
                    //消息内容
                    NSString * mesg =[contentDic objectForKey:@"remind_msg"];
                    [self alertViewControleventMessage:mesg];
                    //判断是不是自动关闭 0不自动关闭 1自动关闭
                    NSString * colseStr =[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"autoClose"]];
                    if ([colseStr isEqualToString:@"1"]) {
                        //自动关闭
                        //获取推送时间
                        NSString * timeMiao =[contentDic objectForKey:@"remind_duration_time"];
                        [self performSelector:@selector(dissMissTanKuang) withObject:self afterDelay:[timeMiao intValue]/1000];
                    }
                    
                }
                
                
                
                
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



-(void)wenXinTiShiMsg:(NSString*)msg{
    UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action =[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
//    UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
    [actionview addAction:action];
//    [actionview addAction:action2];
    [self presentViewController:actionview animated:YES completion:nil];
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
        [_headLineView setTitleArray:@[@"竞价记录",@"拍卖师发言记录"]];
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
        // [self CreatLiuYan]; //ScreenHeight-64-50
        _liuYanView.hidden=NO;
        _tableView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
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
