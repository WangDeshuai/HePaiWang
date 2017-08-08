//
//  MyVC.m
//  DistributionQuery
//
//  Created by Macx on 16/10/8.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "MyVC.h"
#import "LoginViewController.h"//登录
#import "MyWeiTuoViewController.h"//我委托的标的
#import "MyPublicYuGaoVC.h"//我发布的预告
#import "BgBuyDaoViewController.h"//已买到的标的
#import "PaiMaiGongGaoVC.h"//参加的拍卖会
#import "BgXiaoXiViewController.h"//消息列表
#import "MessageVC.h"//个人信息
#import "PublicYuGaoBVC.h"//发布预告
#import "ShiMingRenZhengVC.h"//实名认证
#import "BaseTableBarVC.h"
#import "PublicXInBiaoDiVC.h"//发布新标的
#import "BaseNavigationController.h"
#import "ChangeThePasswordVC.h"//修改密码
#import "SignTextViewController.h"//签名
//#import "PhotoXuanZeViewController.h"
//#import "<#header#>"
@interface MyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView * bgImage;
}
@property(nonatomic,assign)float backImgHeight;
@property(nonatomic,assign)float backImgWidth;
@property(nonatomic,assign)float backImgOrgy;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * nameArray;
@property(nonatomic,strong)NSMutableArray * imageArray;
@end

@implementation MyVC
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBarHidden=YES;
    _tableView.tableHeaderView=[self tableViewHead];
    [self addFooterButton];

    
    
}






/**
 *  添加底部按钮
 */
-(void)addFooterButton
{
   
    UIView * footView =[UIView new];
    footView.backgroundColor=BG_COLOR;
    footView.frame=CGRectMake(0, 10, ScreenWidth, 100);
    
   // 1.初始化Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    //2.设置文字和文字颜色
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //3.设置圆角幅度
    button.layer.cornerRadius = 10.0;
//
    [button addTarget:self action:@selector(buttonClink) forControlEvents:UIControlEventTouchUpInside];
//    //4.设置frame
    button.frame =CGRectMake(30, 30, ScreenWidth-60, 40);;
//
//    //5.设置背景色
    button.backgroundColor = [UIColor redColor];
   
    if ([ToolClass isLogin]) {
         [footView addSubview:button];
    }else{
        [button removeFromSuperview];
    }
   
    self.tableView.tableFooterView = footView;
}



-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backHomeBtn.hidden=YES;
   
   //2764109822@qq.com   2764109822
    //
    [self tankuang];
    [self dataArr];
    [self CreatTableView];
    UIView*backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    backView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:backView];
    self.view.backgroundColor=[UIColor whiteColor];
//[self addFooterButton];
}


#pragma mark --弹框
-(void)tankuang{
    if ([ToolClass isLogin]==YES) {
        [Engine weiDuMessageTanKuangsuccess:^(NSDictionary *dic) {
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                if ([dic objectForKey:@"content"]==[NSNull null]) {
                    return ;
                }else{
                    NSDictionary * dicContent =[dic objectForKey:@"content"];
                    NSString *str =[ToolClass isString:[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"remaindMsg"]]];
                    if ([str isEqualToString:@""]) {
                        
                    }else{
                        UIAlertController * actionView =[UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * action1 =[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
                        
                        [actionView addAction:action1];
                        [self presentViewController:actionView animated:YES completion:nil];
                    }
                    
                    
                    
                    
                }
            }
        } error:^(NSError *error) {
            
        }];
    }
}

#pragma mark --创建数据源
-(void)dataArr{
    NSArray * arr1 =@[@"发布新标的",@"发布预告"];
    NSArray * arr2 =@[@"个人信息",@"实名认证"];
    NSArray * arr3=@[@"消息列表",@"账户消息"];
    NSArray * arr4=@[@"修改密码"];
    
     NSArray * image1 =@[@"person_mg",@"person_fb"];
     NSArray * image2 =@[@"person_xcc",@"person_yz"];
     NSArray * image3 =@[@"person_lb",@"person_xx"];
     NSArray * image4 =@[@"person_xg"];
    
    
    _nameArray=[[NSMutableArray alloc]initWithObjects:arr1,arr2,arr3,arr4, nil];
    _imageArray=[[NSMutableArray alloc]initWithObjects:image1,image2,image3,image4, nil];
}
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight-49-20) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
//    _tableView.bounces=NO;
    _tableView.backgroundColor=BG_COLOR;
   // _tableView.tableHeaderView=[self tableViewHead];
//    _tableView.tableFooterView=[UIView new];
    [self.view addSubview:_tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _nameArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameArray[section] count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        UIButton * imageview =[[UIButton alloc]init];
        imageview.tag=1;
        [cell sd_addSubviews:@[imageview]];
        UILabel * nameLabel =[UILabel new];
        nameLabel.tag=2;
        [cell sd_addSubviews:@[nameLabel]];
       
    }
    UIButton * imageview =(UIButton*)[cell viewWithTag:1];
    imageview.adjustsImageWhenHighlighted=NO;
    [imageview setImage:[UIImage imageNamed:_imageArray[indexPath.section][indexPath.row]] forState:0];
    imageview.sd_layout
    .leftSpaceToView(cell,15)
    .centerYEqualToView(cell)
    .widthIs(25)
    .heightIs(25);
    
    UILabel * namelable =(UILabel*)[cell viewWithTag:2];
    namelable.font=[UIFont systemFontOfSize:15];
    namelable.text=_nameArray[indexPath.section][indexPath.row];
    namelable.alpha=.7;
    namelable.sd_layout
    .leftSpaceToView(imageview,10)
    .centerYEqualToView(imageview)
    .heightIs(20)
    .rightSpaceToView(cell,40);//17186013071
//    [namelable setSingleLineAutoResizeWithMaxWidth:120];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    if (indexPath.section==3) {
//        if (indexPath.row==1) {
//            namelable.font=[UIFont systemFontOfSize:17];
//            namelable.textAlignment=1;
//            namelable.textColor=[UIColor redColor];
//        }
//    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([ToolClass isLogin]==NO) {
        LoginViewController * vc =[LoginViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            //发布新标的
            PublicXInBiaoDiVC * vc =[PublicXInBiaoDiVC new];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //发布预告
            PublicYuGaoBVC * vc =[PublicYuGaoBVC new];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            //个人信息
            MessageVC * vc =[MessageVC new];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //实名认证
            ShiMingRenZhengVC* vc =[ShiMingRenZhengVC new];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.section==2){
       
    //消息列表  //账户信息
     BgXiaoXiViewController * vc =[BgXiaoXiViewController new];
     vc.tagg=indexPath.row+1;
     vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
            
            
        
    }else{
        if (indexPath.row==0) {
            //修改密码ChangeThePasswordVC   SignTextViewController PhotoXuanZeViewController
            ChangeThePasswordVC * vc =[ChangeThePasswordVC new];
           // vc.tagg=0;
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==1){
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(UIView*)tableViewHead{
    UIView * headView=[UIView new];
    headView.backgroundColor=[UIColor whiteColor];
    headView.frame=CGRectMake(0, 0, ScreenWidth, 332/2+ScreenWidth/4);
    
    //背景图
    bgImage =[UIImageView new];
    bgImage.image=[UIImage imageNamed:@"person_bg"];
    bgImage.userInteractionEnabled=YES;
    _backImgHeight=bgImage.frame.size.height;
    _backImgWidth=bgImage.frame.size.width;
    _backImgOrgy=bgImage.frame.origin.y;
    [headView sd_addSubviews:@[bgImage]];
    bgImage.sd_layout
    .leftSpaceToView(headView,0)
    .rightSpaceToView(headView,0)
    .topSpaceToView(headView,-20)
    .heightIs(332/2+20);
    //头像
    UIButton * headImage =[[UIButton alloc]init];
    [headImage setImageForState:0 withURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"headImage"]];
    headImage.sd_cornerRadius=@(130/4);
    [headImage addTarget:self action:@selector(headBtnClink) forControlEvents:UIControlEventTouchUpInside];
    [bgImage sd_addSubviews:@[headImage]];
    headImage.sd_layout
    .widthIs(130/2)
    .centerXEqualToView(bgImage)
    .topSpaceToView(bgImage,30)
    .heightIs(130/2);
    
    if ([ToolClass isLogin]) {
        NSDictionary * baseInfoDic =[ToolClass duquPlistWenJianPlistName:@"baseInfo"];
        ;
        //已登录
        UILabel * accountLab =[UILabel new];
        accountLab.text=[baseInfoDic objectForKey:@"account"];
        accountLab.font=[UIFont systemFontOfSize:15];
        accountLab.textColor=[UIColor whiteColor];
        [bgImage sd_addSubviews:@[accountLab]];
        accountLab.sd_layout
        .centerXEqualToView(headImage)
        .topSpaceToView(headImage,10)
        .heightIs(20);
        [accountLab setSingleLineAutoResizeWithMaxWidth:120];
        
        
        UILabel * nameLabel =[UILabel new];
        nameLabel.text=[baseInfoDic objectForKey:@"user_name"];
        nameLabel.font=[UIFont systemFontOfSize:15];
        nameLabel.textColor=[UIColor whiteColor];
        [bgImage sd_addSubviews:@[nameLabel]];
        nameLabel.sd_layout
        .centerXEqualToView(accountLab)
        .topSpaceToView(accountLab,5)
        .heightIs(20);
        [nameLabel setSingleLineAutoResizeWithMaxWidth:120];
        [headImage setImageForState:0 withURL:[NSURL URLWithString:[baseInfoDic objectForKey:@"head_img"]] placeholderImage:[UIImage imageNamed:@"headImage"]];
        
        //认证图片
        UIImageView * renZheng =[UIImageView new];
        [bgImage sd_addSubviews:@[renZheng]];
        renZheng.sd_layout
        .centerXEqualToView(bgImage)
        .topSpaceToView(nameLabel,10)
        .widthIs(54)
        .heightIs(15);
        
        [Engine houQuShiMingRenZhengUserIDsuccess:^(NSDictionary *dic) {
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSString * contentStr =[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]]];
                //-1未认证 0未通过  1已认证   2待审核
                if ([contentStr isEqualToString:@"-1"]) {
                    renZheng.image=[UIImage imageNamed:@"person_rz_no"];
                }else if ([contentStr isEqualToString:@"0"]){
                    
                    renZheng.image=[UIImage imageNamed:@"person_rz_none"];
                }else if ([contentStr isEqualToString:@"1"]){
                     renZheng.image=[UIImage imageNamed:@"person_rz"];
                }else if ([contentStr isEqualToString:@"2"]){
                     renZheng.image=[UIImage imageNamed:@"person_rz_sh"];
                }
                
            }
        } error:^(NSError *error) {
            
        }];
        
        
        
        
    }else{
        //未登录
        //立即登录
    
        UIButton * loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"person_login"] forState:0];
        [loginBtn addTarget:self action:@selector(btnn:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn setTitle:@"立即登录" forState:0];
        loginBtn.titleLabel.font=[UIFont systemFontOfSize:15 weight:15];
        [bgImage sd_addSubviews:@[loginBtn]];
        loginBtn.sd_layout
        .centerXEqualToView(headImage)
        .topSpaceToView(headImage,10)
        .widthIs(176/2)
        .heightIs(56/2);

    }
    
    
    
    
    
    NSArray * imageName =@[@"person_bt1",@"person_bt2",@"person_bt3",@"person_bt4"];
    //for循环btn
    for (int i =0; i<4; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageName[i]] forState:0];
        btn.tag=i;
        [btn addTarget:self action:@selector(forBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView sd_addSubviews:@[btn]];
        btn.sd_layout
        .leftSpaceToView(headView,ScreenWidth/4*i)
        .topSpaceToView(bgImage,0)
        .widthIs(ScreenWidth/4)
        .heightIs(ScreenWidth/4);
    }
    
    return headView;
}
#pragma mark --创建的4个按钮点击事件
-(void)forBtnClick:(UIButton*)btn{
    if ([ToolClass isLogin]==NO) {
        LoginViewController * vc =[LoginViewController new];
          vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (btn.tag==0) {
        //我委托的标的
        MyWeiTuoViewController * vc =[MyWeiTuoViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (btn.tag==1){
        //我发布的预告
        MyPublicYuGaoVC * vc =[MyPublicYuGaoVC new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag==2){
        //已买到的标的
        BgBuyDaoViewController *vc =[BgBuyDaoViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else {
        //参加的拍卖会
        PaiMaiGongGaoVC *vc =[PaiMaiGongGaoVC new];
        vc.tagg=2;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    
}
#pragma mark --点击头像
-(void)headBtnClink{
    if ([ToolClass isLogin]==NO) {
        LoginViewController * vc =[LoginViewController new];
          vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    MessageVC * vc =[MessageVC new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)btnn:(UIButton*)btn{
    LoginViewController * vc =[LoginViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --退出
-(void)buttonClink{
    UIAlertController * alertView =[UIAlertController alertControllerWithTitle:@"" message:@"是否确认退出" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 =[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //1.清楚token
        [NSUSE_DEFO removeObjectForKey:@"token"];
        [NSUSE_DEFO removeObjectForKey:@"people"];
        [NSUSE_DEFO removeObjectForKey:@"phone"];
        [NSUSE_DEFO synchronize];
        //2.清楚plist文件
        [ToolClass deleagtePlistName:@"baseInfo"];
        [ToolClass deleagtePlistName:@"shiMingInfo"];
        //                [self.navigationController popViewControllerAnimated:YES];
        self.tabBarController.selectedIndex=0;
    }];
    UIAlertAction * action2 =[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:action2];
    [alertView addAction:action1];
    [self presentViewController:alertView animated:YES completion:nil];
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
