//
//  PaiMaiGongGaoXiangQingVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/28.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PaiMaiGongGaoXiangQingVC.h"
#import "PaiMaiBiaoDiModel.h"
#import "XYAlertView.h"
@interface PaiMaiGongGaoXiangQingVC ()<UITableViewDelegate,UITableViewDataSource>
{
    dispatch_source_t _timer;
}
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIView * view1;
@property(nonatomic,strong)UIView * view2;
@property(nonatomic,strong)NSMutableArray * nameArray;
@property(nonatomic,strong) UILabel *dayLabel;//天
@property(nonatomic,strong)UILabel *hourLabel;//时
@property(nonatomic,strong)UILabel *minuteLabel;//分
@property(nonatomic,strong) UILabel *secondLabel;//秒
@property(nonatomic,strong) NSMutableArray * dataArr;//存上一篇，下一篇
@property(nonatomic,strong) NSMutableArray * dataArrID;//存上一篇ID，下一篇ID
@end

@implementation PaiMaiGongGaoXiangQingVC
-(void)viewWillAppear:(BOOL)animated{
   // [ToolClass exitApplication];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"拍卖公告详情";
   
    _dataArr=[NSMutableArray new];
    _dataArrID=[NSMutableArray new];
    
     [self CreatTableView];
     [self twoBtn];
    
    
}

-(void)CreatNameArray{
    _nameArray=[NSMutableArray new];

}
#pragma mark --创建表
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-55) style:UITableViewStylePlain];
    }
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=BG_COLOR;
    _tableView.tableFooterView=[UIView new];
    _tableView.tableHeaderView=[self CreatView1:_messageID];
    [self.view addSubview:_tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UILabel * namelabel =[UILabel new];
        namelabel.tag=1;
        UILabel * contentLabel=[UILabel new];
        contentLabel.tag=2;
        [cell sd_addSubviews:@[namelabel,contentLabel]];
    }
    
    UILabel * nameLabel =[cell viewWithTag:1];
    UILabel * contentLabel=[cell viewWithTag:2];
    nameLabel.textColor=[UIColor redColor];
    nameLabel.alpha=.7;
    nameLabel.sd_layout
    .leftSpaceToView(cell,15)
    .centerYEqualToView(cell)
    .heightIs(20);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:120];
    contentLabel.alpha=.7;
    
    contentLabel.sd_layout
    .leftSpaceToView(nameLabel,15)
    .rightSpaceToView(cell,15)
    .centerYEqualToView(cell)
    .heightIs(20);
    
    if (indexPath.row==0) {
        nameLabel.text=@"上一篇";
    }else{
        nameLabel.text=@"下一篇";
    }
    contentLabel.text=_dataArr[indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"输出ID=%@",_dataArrID[indexPath.row]);
    _tableView.tableHeaderView=[self CreatView1:_dataArrID[indexPath.row]];
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView * bgView =[UIView new];
//    bgView.backgroundColor=[UIColor redColor];
//    UILabel * publicLabel =[UILabel new];
//    publicLabel.text=@"拍卖公告";
//    publicLabel.font=[UIFont systemFontOfSize:15];
//    publicLabel.alpha=.6;
//    [bgView sd_addSubviews:@[publicLabel]];
//    publicLabel.sd_layout
//    .leftSpaceToView(bgView,15)
//    .centerYEqualToView(bgView)
//    .heightIs(20);
//    [publicLabel setSingleLineAutoResizeWithMaxWidth:120];
//    return bgView;
//    
//}




#pragma mark --创建最底下2个按钮
-(void)twoBtn{
    
    int k =0;
    if (ScreenWidth==320) {
        k=140;
    }else{
        k=160;
    }
    int j= (ScreenWidth-k*2)/3;
    NSArray * arr =@[@"立即报名",@"查看联系方式"];
    for (int i =0; i<2; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=[UIColor redColor];
        [btn setTitle:arr[i] forState:0];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        btn.sd_cornerRadius=@(3);
        btn.tag=i;
        [btn addTarget:self action:@selector(btnClinkwo:) forControlEvents:UIControlEventTouchUpInside];
       // [btn setImage:[UIImage imageNamed:arr[i]] forState:0];
        [self.view sd_addSubviews:@[btn]];
        btn.sd_layout
        .leftSpaceToView(self.view,j+(j+k)*i)
        .bottomSpaceToView(self.view,10)
        .widthIs(k)
        .heightIs(35);
    }
    
}
#pragma mark --2个按钮点击状态
-(void)btnClinkwo:(UIButton*)btn{
    if (btn.tag==0) {
        //立即报名
        XYAlertView * xv =[[XYAlertView alloc]initWithTitle:@"我要报名" alerMessage:@"提交信息" canCleBtn:@"提交信息" otheBtn:@""];
         __weak __typeof(xv)weakSelf = xv;
        xv.NameBlock=^(NSString*people,NSString*phone,NSString*other){
         // 调用接口
            [LCProgressHUD showMessage:@"正在发布..."];
            [Engine BaoMingCanJianPaiMaiID:_messageID BiaoDiID:@"" Phone:phone PeopleName:people MessageName:other success:^(NSDictionary *dic) {
                [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
                NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                if ([code isEqualToString:@"1"]) {
                    [weakSelf dissmiss];
                }
            } error:^(NSError *error) {
                
            }];
        };
        
        [xv show];
    }else{
        //查看联系方式
    }
}
#pragma mark --区头
-(UIView*)CreatView1:(NSString*)messageID{
    _view1=[UIView new];
    _view1.backgroundColor=BG_COLOR;
    _view1.frame=CGRectMake(0, 0, ScreenWidth, 574+50);
//    if ([ToolClass isLogin]) {
//        _view1.frame=CGRectMake(0, 0, ScreenWidth, 574);
//    }else{
//       _view1.frame=CGRectMake(0, 0, ScreenWidth, 259);
//    }
    
    UIView * view11 =[UIView new];
    view11.backgroundColor=[UIColor whiteColor];
    [_view1 sd_addSubviews:@[view11]];
    view11.sd_layout
    .leftSpaceToView(_view1,0)
    .rightSpaceToView(_view1,0)
    .topSpaceToView(_view1,5)
    .heightIs(80);
//标题
    UILabel * titleLabel=[UILabel new];
    titleLabel.text=@"日产50吨烘干设备专线";
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.alpha=.8;
    titleLabel.numberOfLines=0;
    [view11 sd_addSubviews:@[titleLabel]];
    titleLabel.sd_layout
    .topSpaceToView(view11,15)
    .leftSpaceToView(view11,15)
    .rightSpaceToView(view11,15)
    .autoHeightRatio(0);
 //公告时间
    UILabel * timeLabel=[UILabel new];
    timeLabel.text=@"公告时间  2016-11-01";
    timeLabel.font=[UIFont systemFontOfSize:14];
    timeLabel.alpha=.6;
    [view11 sd_addSubviews:@[timeLabel]];
    timeLabel.sd_layout
    .topSpaceToView(titleLabel,10)
    .leftEqualToView(titleLabel)
    .rightEqualToView(titleLabel)
    .autoHeightRatio(0);
    [view11 setupAutoHeightWithBottomView:timeLabel bottomMargin:15];
    
    
    UIView * view22 =[UIView new];
    view22.backgroundColor=[UIColor whiteColor];
    [_view1 sd_addSubviews:@[view22]];
    view22.sd_layout
    .leftSpaceToView(_view1,0)
    .rightSpaceToView(_view1,0)
    .topSpaceToView(view11,5)
    .heightIs(80);
    //局开拍
    UILabel * strLabel=[UILabel new];
    strLabel.text=@"距下班";
    strLabel.font=[UIFont systemFontOfSize:20 weight:17];
    strLabel.alpha=.9;
    strLabel.textColor=[UIColor grayColor];
    [view22 sd_addSubviews:@[strLabel]];
    strLabel.sd_layout
    .topSpaceToView(view22,10)
    .leftSpaceToView(view22,60)
    .autoHeightRatio(0);
    [strLabel setSingleLineAutoResizeWithMaxWidth:120];
    //倒计时
    self.dayLabel=[UILabel new];
    self.dayLabel.font=[UIFont systemFontOfSize:18];
    self.dayLabel.textColor=[UIColor redColor];
    [view22 sd_addSubviews:@[self.dayLabel]];
    self.dayLabel.sd_layout
    .centerYEqualToView(strLabel)
    .leftSpaceToView(strLabel,30)
    .heightIs(20);
    [self.dayLabel setSingleLineAutoResizeWithMaxWidth:100];
    //时
    self.hourLabel=[UILabel new];
    self.hourLabel.font=[UIFont systemFontOfSize:18];
    self.hourLabel.textColor=[UIColor redColor];
    [view22 sd_addSubviews:@[self.hourLabel]];
    self.hourLabel.sd_layout
    .centerYEqualToView(strLabel)
    .leftSpaceToView(self.dayLabel,3)
    .heightIs(20);
    [self.hourLabel setSingleLineAutoResizeWithMaxWidth:100];
    //分
    self.minuteLabel=[UILabel new];
    self.minuteLabel.font=[UIFont systemFontOfSize:18];
    self.minuteLabel.textColor=[UIColor redColor];
    [view22 sd_addSubviews:@[self.minuteLabel]];
    self.minuteLabel.sd_layout
    .centerYEqualToView(strLabel)
    .leftSpaceToView(self.hourLabel,3)
    .heightIs(20);
    [self.minuteLabel setSingleLineAutoResizeWithMaxWidth:100];
    //秒
    self.secondLabel=[UILabel new];
    self.secondLabel.font=[UIFont systemFontOfSize:18];
    self.secondLabel.textColor=[UIColor redColor];
    [view22 sd_addSubviews:@[self.secondLabel]];
    self.secondLabel.sd_layout
    .centerYEqualToView(strLabel)
    .leftSpaceToView(self.minuteLabel,3)
    .heightIs(20);
    [self.secondLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self.secondLabel setupAutoWidthWithRightView:view22 rightMargin:20];
    [self dataRiqiTime:@"2016-11-22 12:00:00"];

//    UILabel * timeDaoLabel=[UILabel new];
//    timeDaoLabel.text=@"3 天 20 时 23 分 50 秒";
//    [timeDaoLabel setTextColor:[UIColor redColor]];
//    timeDaoLabel.font=[UIFont systemFontOfSize:18];
//    [view22 sd_addSubviews:@[timeDaoLabel]];
//    timeDaoLabel.sd_layout
//    .centerYEqualToView(strLabel)
//    .rightSpaceToView(view22,30)
//    .heightIs(20);
//    [timeDaoLabel setSingleLineAutoResizeWithMaxWidth:320];
  
    
    //线条
    UIView * lineView =[UIView new];
    lineView.backgroundColor=BG_COLOR;
    [view22 sd_addSubviews:@[lineView]];
    lineView.sd_layout
    .leftSpaceToView(view22,0)
    .rightSpaceToView(view22,0)
    .topSpaceToView(strLabel,15)
    .heightIs(1);


   
    [LCProgressHUD showMessage:@"正在加载..."];
    [Engine PaiMaiPublicMessageID:messageID success:^(NSDictionary *dic) {
       
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            
            if ([dic objectForKey:@"content"]==nil ) {
                
                [LCProgressHUD showMessage:@"暂无数据"];
                return ;
            }
             [LCProgressHUD hide];
            NSDictionary * contetDic =[dic objectForKey:@"content"];
            [_dataArr removeAllObjects];
            [_dataArrID removeAllObjects];
            //上一条
            [_dataArr addObject:[ToolClass isString:[NSString stringWithFormat:@"%@",[contetDic objectForKey:@"previous_auction_name"]]]];
            //下一条
             [_dataArr addObject:[ToolClass isString:[NSString stringWithFormat:@"%@",[contetDic objectForKey:@"next_auction_name"]]]];
            //上一条ID
            [_dataArrID addObject:[ToolClass isString:[NSString stringWithFormat:@"%@",[contetDic objectForKey:@"previous_auction_id"]]]];
            //下一条ID
            [_dataArrID addObject:[ToolClass isString:[NSString stringWithFormat:@"%@",[contetDic objectForKey:@"next_auction_id"]]]];
            
            
            //取出基本信息
            NSDictionary *infoDic =[contetDic objectForKey:@"auctionInfo"];
            //标题
            titleLabel.text=[ToolClass isString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"auction_name"]]];
            //公告时间
             timeLabel.text=[ToolClass isString:[NSString stringWithFormat:@"公告时间   %@",[infoDic objectForKey:@"auction_add_time"]]];
            //开始日期
             [self dataRiqiTime:[ToolClass isString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"auction_begin_time"]]]];
            //赋值
            NSString * str1 =[NSString stringWithFormat:@"保证金     %@",[ToolClass isString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"auction_deposit_value"]]]];
            NSString * str2 =[NSString stringWithFormat:@"保留价     %@",[ToolClass isString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"auction_use_reserve_price"]]]];
            NSString * str3 =[NSString stringWithFormat:@"优先购买权   %@",[ToolClass isString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"auction_use_preferential_buy"]]]];
            NSString * str4 =[NSString stringWithFormat:@"预展地点     %@",[ToolClass isString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"auction_preview_cityname"]]]];
            NSString * str5 =[NSString stringWithFormat:@"报名截止   %@",[ToolClass isString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"auction_preview_end_time"]]]];
            NSString * str6 =[NSString stringWithFormat:@"预展时间   %@",[ToolClass isString:[NSString stringWithFormat:@"%@至%@",[infoDic objectForKey:@"auction_preview_begin_time"],[infoDic objectForKey:@"auction_preview_end_time"]]]];
            NSArray * nameArr =@[str1,str2,str3,str4];
            NSArray * nameArr2=@[str5,str6];
            //保证金6个label
            int k=ScreenWidth/2-20;
            int d =(ScreenWidth-k*2)/3;
            for (int i=0; i<nameArr.count; i++) {
                UILabel * nameLabel =[UILabel new];
                nameLabel.alpha=.6;
                nameLabel.font=[UIFont systemFontOfSize:13];
                nameLabel.text=nameArr[i];
                [view22 sd_addSubviews:@[nameLabel]];
                nameLabel.sd_layout
                .leftSpaceToView(view22,d+(k+d)*(i%2))
                .topSpaceToView(lineView,15+(15+20)*(i/2))
                .widthIs(k)
                .heightIs(20);
                [view22 setupAutoHeightWithBottomView:nameLabel bottomMargin:15];
                
            }
            for (int i=0; i<nameArr2.count; i++) {
                UILabel * nameLabel =[UILabel new];
                nameLabel.alpha=.6;
                nameLabel.font=[UIFont systemFontOfSize:13];
                nameLabel.text=nameArr2[i];
                [view22 sd_addSubviews:@[nameLabel]];
                nameLabel.sd_layout
                .leftSpaceToView(view22,15)
                .topSpaceToView(lineView,80+(15+20)*i)
                .rightSpaceToView(view22,10)
                .heightIs(20);
                [view22 setupAutoHeightWithBottomView:nameLabel bottomMargin:15];
                
            }
            
            [self loginBefo:view22 Dic:infoDic ListView:[contetDic objectForKey:@"targetList"]];
            
            [_tableView reloadData];
        }else{
            [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        }
    } error:^(NSError *error) {
        [LCProgressHUD showMessage:@"网络错误"];
    }];
    
    
    
    return _view1;
}

-(void)dataRiqiTime:(NSString*)timeStr{
    NSLog(@"开始日期%@",timeStr);
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *endDate = [dateFormatter dateFromString:timeStr];
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
                        self.dayLabel.text = @"";
                        self.hourLabel.text = @"00 时";
                        self.minuteLabel.text = @"00 分";
                        self.secondLabel.text = @"00 秒";
                        self.hourLabel.attributedText= [ToolClass attrStrFrom: self.hourLabel.text intFond:18 Color:[UIColor blackColor] numberStr:@"时"];
                        self.minuteLabel.attributedText= [ToolClass attrStrFrom: self.minuteLabel.text intFond:18 Color:[UIColor blackColor] numberStr:@"分"];
                        self.secondLabel.attributedText= [ToolClass attrStrFrom: self.secondLabel.text intFond:18 Color:[UIColor blackColor] numberStr:@"秒"];
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
                            self.dayLabel.text = @"0 天";
                            self.dayLabel.attributedText= [ToolClass attrStrFrom: self.dayLabel.text intFond:18 Color:[UIColor blackColor] numberStr:@"天"];
                        }else{
                            self.dayLabel.text = [NSString stringWithFormat:@"%d 天",days];
                            self.dayLabel.attributedText= [ToolClass attrStrFrom: self.dayLabel.text intFond:18 Color:[UIColor blackColor] numberStr:@"天"];
                        }
                        if (hours<10) {
                            self.hourLabel.text = [NSString stringWithFormat:@"0%d 时",hours];
                            self.hourLabel.attributedText= [ToolClass attrStrFrom: self.hourLabel.text intFond:18 Color:[UIColor blackColor] numberStr:@"时"];
                        }else{
                            self.hourLabel.text = [NSString stringWithFormat:@"%d 时",hours];
                            self.hourLabel.attributedText= [ToolClass attrStrFrom: self.hourLabel.text intFond:18 Color:[UIColor blackColor] numberStr:@"时"];
                        }
                        if (minute<10) {
                            self.minuteLabel.text = [NSString stringWithFormat:@"0%d 分",minute];
                            self.minuteLabel.attributedText= [ToolClass attrStrFrom: self.minuteLabel.text intFond:18 Color:[UIColor blackColor] numberStr:@"分"];
                        }else{
                            self.minuteLabel.text = [NSString stringWithFormat:@"%d 分",minute];
                            self.minuteLabel.attributedText= [ToolClass attrStrFrom: self.minuteLabel.text intFond:18 Color:[UIColor blackColor] numberStr:@"分"];
                        }
                        if (second<10) {
                            self.secondLabel.text = [NSString stringWithFormat:@"0%d 秒",second];
                            self.secondLabel.attributedText= [ToolClass attrStrFrom: self.secondLabel.text intFond:18 Color:[UIColor blackColor] numberStr:@"秒"];
                        }else{
                          self.secondLabel.text = [NSString stringWithFormat:@"%d 秒",second];
                          self.secondLabel.attributedText= [ToolClass attrStrFrom: self.secondLabel.text intFond:18 Color:[UIColor blackColor] numberStr:@"秒"];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//登录之后
-(void)loginBefo:(UIView*)view22 Dic:(NSDictionary*)dic ListView:(NSArray*)contentAr{
    //拍卖地点
    UIView * addressView =[UIView new];
    addressView.backgroundColor=[UIColor whiteColor];
    [_view1 sd_addSubviews:@[addressView]];
    addressView.sd_layout
    .leftSpaceToView(_view1,0)
    .rightSpaceToView(_view1,0)
    .topSpaceToView(view22,5)
    .heightIs(100);
    //拍卖地点
    UILabel * paiMaiLabel =[UILabel new];
   ;
    paiMaiLabel.text=[NSString stringWithFormat:@"拍卖地点  %@%@", [dic objectForKey:@"auction_provname"],[dic objectForKey:@"auction_cityname"]];//@"拍卖地点     河北石家庄长安区";
    paiMaiLabel.alpha=.6;
    paiMaiLabel.font=[UIFont systemFontOfSize:15];
    [addressView sd_addSubviews:@[paiMaiLabel]];
    paiMaiLabel.sd_layout
    .leftSpaceToView(addressView,15)
    .topSpaceToView(addressView,15)
    .rightSpaceToView(addressView,15)
    .heightIs(20);
    
    UIView * lineView =[UIView new];
    lineView.backgroundColor=BG_COLOR;
    [addressView sd_addSubviews:@[lineView]];
    lineView.sd_layout
    .leftSpaceToView(addressView,0)
    .rightSpaceToView(addressView,0)
    .topSpaceToView(paiMaiLabel,15)
    .heightIs(1);
//公告详情
    UIButton * gongGaoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [gongGaoBtn setImage:[UIImage imageNamed:@"bg11"] forState:0];
    [addressView sd_addSubviews:@[gongGaoBtn]];
    gongGaoBtn.sd_layout
    .leftSpaceToView(addressView,0)
    .rightSpaceToView(addressView,0)
    .topSpaceToView(paiMaiLabel,30)
    .heightIs(15);
    
    //标的目标
    UIView * biaoView =[UIView new];
    biaoView.backgroundColor=[UIColor whiteColor];
    [_view1 sd_addSubviews:@[biaoView]];
    biaoView.sd_layout
    .leftSpaceToView(_view1,0)
    .rightSpaceToView(_view1,0)
    .topSpaceToView(addressView,5)
    .heightIs(150);
    
    UILabel * mllabel =[UILabel new];
    mllabel.text=@"标的目录";
    mllabel.alpha=.6;
    mllabel.font=[UIFont systemFontOfSize:15];
    [biaoView sd_addSubviews:@[mllabel]];
    mllabel.sd_layout
    .leftSpaceToView(biaoView,15)
    .topSpaceToView(biaoView,15)
    .widthIs(130)
    .heightIs(20);
    //滚动试图
    UIScrollView * priceScrollview =[[UIScrollView alloc]init];
    priceScrollview.showsHorizontalScrollIndicator = NO;
   // priceScrollview.backgroundColor=[UIColor yellowColor];
    priceScrollview.contentSize=CGSizeMake(ScreenWidth+200, 120);
    [biaoView sd_addSubviews:@[priceScrollview]];
    priceScrollview.sd_layout
    .leftSpaceToView(biaoView,0)
    .rightSpaceToView(biaoView,0)
    .topSpaceToView(mllabel,10)
    .heightIs(160);
    [biaoView setupAutoHeightWithBottomView:priceScrollview bottomMargin:10];

    
        for (int i =0; i<contentAr.count; i++) {
            NSDictionary * dicc =contentAr[i];
            PaiMaiBiaoDiModel * model =[[PaiMaiBiaoDiModel alloc]initWithBiaoDiDic:dicc];
            UIButton * bgView =[UIButton new];
            bgView.backgroundColor=[UIColor magentaColor];
            bgView.tag=i;
            bgView.layer.borderWidth=.5;
            bgView.layer.borderColor=JXColor(205, 131, 137, 1).CGColor;
            bgView.backgroundColor=JXColor(247, 247, 247, 1);
           // [bgView addTarget:self action:@selector(bgviewClick:) forControlEvents:UIControlEventTouchUpInside];
            [priceScrollview sd_addSubviews:@[bgView]];
            bgView.sd_layout
            .leftSpaceToView(priceScrollview,15+(140+15)*i)
            .topSpaceToView(priceScrollview,0)
            .bottomSpaceToView(priceScrollview,0)
            .widthIs(140);
            //图片
            UIImageView * imageview =[UIImageView new];
            [imageview setImageWithURL:[NSURL URLWithString:model.leftImage] placeholderImage:[UIImage imageNamed:@"banner"]];
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
            .rightSpaceToView(bgView,5)
            .heightIs(15);
            
            
            
        }
     priceScrollview.contentSize=CGSizeMake(140*contentAr.count+30+15*(contentAr.count-1), 120);
    
    
    [_view1 setupAutoHeightWithBottomView:biaoView bottomMargin:5];
    

}









#pragma mark --/**********************未登录状态加载*********************/

//-(void)CreatView2{
//    _view2=[UIView new];
//    _view2.backgroundColor=[UIColor whiteColor];//BG_COLOR;
//    [self.view sd_addSubviews:@[_view2]];
//    _view2.sd_layout
//    .leftSpaceToView(self.view,0)
//    .rightSpaceToView(self.view,0)
//    .topSpaceToView(_view1,0)
//    .heightIs(60);
//
//    //拍卖地点
//    UILabel * strLabel=[UILabel new];
//    strLabel.text=@"拍卖地点        河北石家庄市长安区";
//    strLabel.font=[UIFont systemFontOfSize:16];
//    strLabel.alpha=.6;
//    [_view2 sd_addSubviews:@[strLabel]];
//    strLabel.sd_layout
//    .topSpaceToView(_view2,15)
//    .leftSpaceToView(_view2,15)
//    .autoHeightRatio(0);
//    [strLabel setSingleLineAutoResizeWithMaxWidth:ScreenWidth];
//    //线条
//    UIView * lineView =[UIView new];
//    lineView.backgroundColor=BG_COLOR;
//    [_view2 sd_addSubviews:@[lineView]];
//    lineView.sd_layout
//    .leftSpaceToView(_view2,0)
//    .rightSpaceToView(_view2,0)
//    .topSpaceToView(strLabel,15)
//    .heightIs(1);
//    //拍卖详情
//    UILabel * xiangQing =[UILabel new];
//    xiangQing.text=@"公告详情:日产50吨烘干设备专线，该公告被设定了权限，如果需要知道详情，请登录后点击查看";
//    xiangQing.font=[UIFont systemFontOfSize:14];
//    xiangQing.numberOfLines=0;
//    xiangQing.alpha=.6;
//    [_view2 sd_addSubviews:@[xiangQing]];
//    xiangQing.sd_layout
//    .topSpaceToView(lineView,15)
//    .leftSpaceToView(_view2,15)
//    .rightSpaceToView(_view2,15)
//    .autoHeightRatio(0);
//    [_view2 setupAutoHeightWithBottomView:xiangQing bottomMargin:10];
//    
//}
-(void)CreatView3{
    UIButton * upBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [upBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:0];
    [upBtn setTitle:@"帕萨特北京现代荣威雪佛兰别克" forState:0];
     [upBtn setTitleColor:JXColor(164, 164, 164, 1) forState:0];
    upBtn.titleLabel.font=[UIFont systemFontOfSize:14];
     upBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 30, 0, 0);
    upBtn.adjustsImageWhenHighlighted=NO;
    [self.view sd_addSubviews:@[upBtn]];
    upBtn.sd_layout
    .rightSpaceToView(self.view,0)
    .topSpaceToView(_view2,10)
    .leftSpaceToView(self.view,0)
    .heightIs(87/2);
    
    UIButton * nextBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:0];
    [nextBtn setTitle:@"吉利牌小型汽车拍卖公告" forState:0];
     nextBtn.titleLabel.font=[UIFont systemFontOfSize:14];
     nextBtn.adjustsImageWhenHighlighted=NO;
    [nextBtn setTitleColor:JXColor(164, 164, 164, 1) forState:0];
     nextBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 30, 0, 0);
    //nextBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [self.view sd_addSubviews:@[nextBtn]];
    nextBtn.sd_layout
    .rightSpaceToView(self.view,0)
    .topSpaceToView(upBtn,5)
    .leftSpaceToView(self.view,0)
    .heightIs(87/2);
    
    
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
