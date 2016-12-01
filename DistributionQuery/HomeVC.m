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
@interface HomeVC ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView * headView;
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation HomeVC
-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.backHomeBtn.hidden=YES;
    // Do any additional setup after loading the view.
     //[self.navigationItem setTitle:@"配电查询"];
    // [self CreatLunBoTu];
   // [self CreatBtn];
    //self.title=@"";
    [self.navigationItem setTitle:@""];
    [self CreatNavBtn];
    [self CreatTableView];
   // [self CreatView1];
}

#pragma mark --创建导航条按钮
-(void)CreatNavBtn{
    UIButton * logoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn.frame=CGRectMake(0, 0, 146/2, 47/2);
    [logoBtn setImage:[UIImage imageNamed:@"logo"] forState:0];
    UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithCustomView:logoBtn];
    UIButton * logoBtn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn2.frame=CGRectMake(0, 0, 5, 47/2);
    UIBarButtonItem *leftBtn2 =[[UIBarButtonItem alloc]initWithCustomView:logoBtn2];
    
    UIButton * searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(0, -10, 489/2, 65/2);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search-1"] forState:0];//489   65
    [searchBtn setTitle:@"搜索标的物" forState:0];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:0];
    searchBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    searchBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 30, 0, 0);
    searchBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    UIBarButtonItem *leftBtn3 =[[UIBarButtonItem alloc]initWithCustomView:searchBtn];
   // [self.navigationItem setTitleView:searchBtn];
    self.navigationItem.leftBarButtonItems=@[leftBtn,leftBtn2,leftBtn3];
    
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
    //轮播图
    SDCycleScrollView*  cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 540*ScreenWidth/1080) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    [_headView addSubview:cycleScrollView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = arr;
    });
    cycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
        // NSLog(@">>>>>  %ld", (long)index);
        
    };
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
   //priceScrollview.backgroundColor=[UIColor yellowColor];
    priceScrollview.contentSize=CGSizeMake(ScreenWidth+200, 120);
    [view2 sd_addSubviews:@[priceScrollview]];
    priceScrollview.sd_layout
    .leftSpaceToView(view2,0)
    .rightSpaceToView(view2,0)
    .topSpaceToView(lineImage,0)
    .heightIs(150);
    [view2 setupAutoHeightWithBottomView:priceScrollview bottomMargin:10];
   
    for (int i =0; i<5; i++) {
        UIView * bgView =[UIView new];
        bgView.layer.borderWidth=.5;
        bgView.layer.borderColor=[UIColor colorWithRed:205/255.0 green:131/255.0 blue:137/255.0 alpha:1].CGColor;
        bgView.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        [priceScrollview sd_addSubviews:@[bgView]];
        bgView.sd_layout
        .leftSpaceToView(priceScrollview,15+(130+15)*i)
        .topSpaceToView(priceScrollview,10)
        .bottomSpaceToView(priceScrollview,0)
        .widthIs(130);
        
//        UIImageView * imageview =[UIImageView new];
//        imageview.image=[UIImage imageNamed:@"banner"];
//        [priceScrollview sd_addSubviews:@[imageview]];
        
        
    }
    
    
    
    
//    view2.didFinishAutoLayoutBlock=^(CGRect rect){
//        int d =rect.origin.y+rect.size.height;
//        NSLog(@"%d",d);
//       _headView.sd_layout.heightIs(d+10);
//    };
    _headView.sd_layout.heightIs(459+30);
   
    return _headView;
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
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"第%lu行",indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.alpha=.7;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view =[UIView new];
    view.backgroundColor=[UIColor whiteColor];
    
    //拍卖标的
    UIImageView * imageBD =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_title12"]];
    [view sd_addSubviews:@[imageBD]];
    imageBD.sd_layout
    .leftSpaceToView(view,15)
    .topSpaceToView(view,10)
    .widthIs(159/2)
    .heightIs(28/2);
    //更多
    UIButton * moreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"home_fanhui"] forState:0];
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
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}














@end
