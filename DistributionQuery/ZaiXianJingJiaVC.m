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
//颜色
@interface ZaiXianJingJiaVC ()<headLineDelegate,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic,strong)HeadImageView *headImageView;//头视图
@property(nonatomic,strong)HeadLineView *headLineView;//
@property(nonatomic,strong)UIView * view1;
@property(nonatomic,strong)UIView * view2;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSMutableArray *dataArray0;
@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)UIView * liuYanView;

@end

@implementation ZaiXianJingJiaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"在线竞价";
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUpOrDown:) name:UIKeyboardWillChangeFrameNotification object:nil];
   // [self CreatGundong];//创建顶部滚动试图
    [self loadData];//加载数据源
    [self createTableView];//创建表
   
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
-(UIView * )CreatGundong:(UIView*)headView{
    
    _view1=[UIView new];
    _view1.backgroundColor=[UIColor whiteColor];
    [headView sd_addSubviews:@[_view1]];
    _view1.sd_layout
    .leftSpaceToView(headView,0)
    .rightSpaceToView(headView,0)
    .topSpaceToView(headView,0)
    .heightIs(200);
    
    //轮播图
    NSArray * arr =@[@"banner"];
    SDCycleScrollView*  cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 540*ScreenWidth/1080) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor];
    [_view1 addSubview:cycleScrollView2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = arr;
    });
    cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
        // NSLog(@">>>>>  %ld", (long)index);
        
    };
    
    //下一件btn
    UIButton * nenxtbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [nenxtbtn setBackgroundImage:[UIImage imageNamed:@"zaixian_bt2"] forState:0];
    [_view1 sd_addSubviews:@[nenxtbtn]];
    nenxtbtn.sd_layout//
    .rightSpaceToView(_view1,15)
    .topSpaceToView(cycleScrollView2,15)
    .widthIs(137/2)
    .heightIs(50/2);
    //上一件btn
    UIButton * upbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [upbtn setBackgroundImage:[UIImage imageNamed:@"zaixian_bt1"] forState:0];
    [_view1 sd_addSubviews:@[upbtn]];
    upbtn.sd_layout//
    .rightSpaceToView(nenxtbtn,10)
    .centerYEqualToView(nenxtbtn)
    .widthIs(137/2)
    .heightIs(50/2);
    
    //标题
    UILabel * titleLabel =[UILabel new];
    titleLabel.text=@"日产50顿烘干设备专线王璇大山炮王璇大山";
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.alpha=.8;
    titleLabel.numberOfLines=0;
    [_view1 sd_addSubviews:@[titleLabel]];
    titleLabel.sd_layout
    .leftSpaceToView(_view1,15)
    .topSpaceToView(cycleScrollView2,15)
    .rightSpaceToView(upbtn,10)
    .autoHeightRatio(0);
    //当前出价
    UILabel * dangQianLab =[UILabel new];
    dangQianLab.text=@"当前出价：14万";
    dangQianLab.font=[UIFont systemFontOfSize:17];
    dangQianLab.textColor=[UIColor redColor];
    dangQianLab.attributedText= [ToolClass attrStrFrom:dangQianLab.text intFond:14 Color:[UIColor blackColor] numberStr:@"当前出价："];
    dangQianLab.alpha=.6;
    [_view1 sd_addSubviews:@[dangQianLab]];
    dangQianLab.sd_layout
    .leftEqualToView(titleLabel)
    .topSpaceToView(titleLabel,20)
    .widthIs(150)
    .heightIs(20);
    
    //出价人
    UILabel * peopleLab =[UILabel new];
    peopleLab.text=@"出价人：033";
    peopleLab.font=[UIFont systemFontOfSize:14];
    peopleLab.alpha=.6;
    peopleLab.numberOfLines=0;
    [_view1 sd_addSubviews:@[peopleLab]];
    peopleLab.sd_layout
    .rightSpaceToView(_view1,15)
    .centerYEqualToView(dangQianLab)
    .heightIs(20);
    [peopleLab setSingleLineAutoResizeWithMaxWidth:200];
    
    [_view1 setupAutoHeightWithBottomView:peopleLab bottomMargin:10];
    return _view1;
}




//创建数据源
-(void)loadData{
    _currentIndex=0;
    _dataArray0=[[NSMutableArray alloc]init];
    _dataArray1=[[NSMutableArray alloc]init];
    for (int i=0; i < 2; i++) {
        if (i == 0) {
            for (int i=0; i<100; i++) {
                NSString * string=[NSString stringWithFormat:@"第%d行",i];
                [_dataArray0 addObject:string];
            }
        }else if(i == 1){
            for (int i=1; i<80; i++) {
                NSString * string=[NSString stringWithFormat:@"%d 娃",i];
                [_dataArray1 addObject:string];
            }
        }
    }
}
//创建TableView
-(void)createTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];

    }
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
//头视图
-(HeadImageView *)headImageView{
    if (!_headImageView) {
        _headImageView=[[HeadImageView alloc]init];
        _headImageView.frame=CGRectMake(0, 0, ScreenWidth, 161+300);
        _headImageView.backgroundColor=BG_COLOR;
        UIView * view1 =[self CreatGundong:_headImageView];
        [_headImageView addSubview:view1];
        
        
//        //创建_view2
        _view2=[UIView new];
        _view2.backgroundColor=[UIColor whiteColor];
        [_headImageView sd_addSubviews:@[_view2]];
        _view2.sd_layout
        .leftSpaceToView(_headImageView,0)
        .rightSpaceToView(_headImageView,0)
        .topSpaceToView(view1,0);
//
        //当前出价
        UILabel * dangQianLab =[UILabel new];
        dangQianLab.text=@"当前出价";
        dangQianLab.font=[UIFont systemFontOfSize:14];
        dangQianLab.alpha=.6;
        [_view2 sd_addSubviews:@[dangQianLab]];
        dangQianLab.sd_layout
        .leftSpaceToView(_view2,15)
        .topSpaceToView(_view2,25)
        .heightIs(20);
        [dangQianLab setSingleLineAutoResizeWithMaxWidth:130];
        //减号
        UIButton * jianBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [jianBtn setBackgroundImage:[UIImage imageNamed:@"zaixian_jia"] forState:0];
        [_view2 sd_addSubviews:@[jianBtn]];
        jianBtn.sd_layout
        .leftSpaceToView(dangQianLab,15)
        .centerYEqualToView(dangQianLab)
        .widthIs(70/2)
        .heightIs(70/2);
        //数字价钱
        UILabel * priceLabel =[UILabel new];
        priceLabel.text=@"14万";
        priceLabel.alpha=.8;
        priceLabel.textAlignment=1;
        priceLabel.font=[UIFont systemFontOfSize:18];
        [_view2 sd_addSubviews:@[priceLabel]];
        priceLabel.sd_layout
        .leftSpaceToView(jianBtn,0)
        .centerYEqualToView(jianBtn)
        .heightRatioToView(jianBtn,1)
        .widthIs(100);
        //加
        UIButton * addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"zaixian_jian"] forState:0];
        [_view2 sd_addSubviews:@[addBtn]];
        addBtn.sd_layout
        .leftSpaceToView(priceLabel,0)
        .centerYEqualToView(priceLabel)
        .widthRatioToView(jianBtn,1)
        .heightRatioToView(jianBtn,1);
        //200
        UIButton * twoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [twoBtn setBackgroundImage:[UIImage imageNamed:@"zaixian_b4"] forState:0];
        [_view2 sd_addSubviews:@[twoBtn]];
        twoBtn.sd_layout
        .leftEqualToView(jianBtn)
        .topSpaceToView(jianBtn,20)
        .widthIs(126/2)
        .heightIs(25);
        //500
        UIButton * wubaiBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [wubaiBtn setBackgroundImage:[UIImage imageNamed:@"zaixian_bt5"] forState:0];
        [_view2 sd_addSubviews:@[wubaiBtn]];
        wubaiBtn.sd_layout
        .leftSpaceToView(twoBtn,15)
        .centerYEqualToView(twoBtn)
        .widthIs(126/2)
        .heightIs(25);
        //1000
        UIButton * yiqianBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [yiqianBtn setBackgroundImage:[UIImage imageNamed:@"zaixian_bt6"] forState:0];
        [_view2 sd_addSubviews:@[yiqianBtn]];
        yiqianBtn.sd_layout
        .leftSpaceToView(wubaiBtn,15)
        .centerYEqualToView(twoBtn)
        .widthIs(126/2)
        .heightIs(25);
     //确认出价
        UIButton * btnSure =[UIButton buttonWithType:UIButtonTypeCustom];
        [btnSure setBackgroundImage:[UIImage imageNamed:@"zaixian_bt7"] forState:0];
        [_view2 sd_addSubviews:@[btnSure]];
        btnSure.sd_layout
        .leftEqualToView(twoBtn)
        .topSpaceToView(twoBtn,15)
        .widthIs(466/2)
        .heightIs(58/2);
        [_view2 setupAutoHeightWithBottomView:btnSure bottomMargin:10];
        _view1.didFinishAutoLayoutBlock=^(CGRect rect){
            NSLog(@">>>>%f",rect.size.height+rect.origin.y);
        };
    }
    return _headImageView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentIndex==0) {
        return _dataArray0.count;
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
    //创建一个静态标识符  来给每一个cell 加上标记  方便我们从复用队列里面取到 名字为该标记的cell
    static NSString *reusID=@"ID";
    //我创建一个cell 先从复用队列dequeue 里面 用上面创建的静态标识符来取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusID];
    //做一个if判断  如果没有cell  我们就创建一个新的 并且 还要给这个cell 加上复用标识符
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusID];
    }
   // cell.backgroundColor=[UIColor clearColor];
    if (_currentIndex==0) {
        cell.textLabel.text=[_dataArray0 objectAtIndex:indexPath.row];
        
        cell.detailTextLabel.text=[_dataArray0 objectAtIndex:indexPath.row];
        
       // [cell.imageView setImage:[UIImage imageNamed:@"23.jpg"]];
        return cell;
        
    }else if(_currentIndex==1){
        cell.textLabel.text=[_dataArray1 objectAtIndex:indexPath.row];
        
        cell.detailTextLabel.text=[_dataArray1 objectAtIndex:indexPath.row];
        
       // [cell.imageView setImage:[UIImage imageNamed:@"5.jpg"]];
        
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
