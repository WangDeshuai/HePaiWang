//
//  LoginViewController.m
//  DistributionQuery
//
//  Created by Macx on 16/11/18.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisteViewController.h"
@interface LoginViewController ()
@property(nonatomic,strong)UITextField * phoneText;
@property(nonatomic,strong)UITextField *pwdText;
@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated
{
//     [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
//     [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
}
-(void)viewWillDisappear:(BOOL)animated
{
//     [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
//     [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"登录";
    self.view.backgroundColor=[UIColor whiteColor];
    UIView * lineView =[UIView new];
    lineView.backgroundColor=[UIColor grayColor];
    lineView.alpha=.3;
    [self.view sd_addSubviews:@[lineView]];
    lineView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(1);
    
    
    
    [self CreatLogo];
}
-(void)CreatLogo{
    UIImageView * imageview =[[UIImageView alloc]init];
    imageview.image=[UIImage imageNamed:@"login_logo"];
    [self.view sd_addSubviews:@[imageview]];
    imageview.sd_layout
    .topSpaceToView(self.view,40)
    .centerXEqualToView(self.view)
    .widthIs(153/2)
    .heightIs(204/2);
    //文本框
    _phoneText=[UITextField new];
    _phoneText.placeholder=@"请输入手机号/用户名";
    _phoneText.font=[UIFont systemFontOfSize:16];
    _phoneText.leftView =[self imageViewNameStr:@"login_adimin"];
    _phoneText.leftViewMode = UITextFieldViewModeAlways;
    [self.view sd_addSubviews:@[_phoneText]];
    _phoneText.sd_layout
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .topSpaceToView(imageview,20)
    .heightIs(45);
    //密码框
    _pwdText=[UITextField new];
    _pwdText.placeholder=@"请输入手机号/用户名";
    _pwdText.font=[UIFont systemFontOfSize:16];
    _pwdText.leftView =[self imageViewNameStr:@"login_password"];
    _pwdText.leftViewMode = UITextFieldViewModeAlways;
   // _pwdText.backgroundColor=[UIColor redColor];
    [self.view sd_addSubviews:@[_pwdText]];
    _pwdText.sd_layout
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .topSpaceToView(_phoneText,10)
    .heightIs(45);
    //登录按钮
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"login_denglu"] forState:0];
    [btn addTarget:self action:@selector(loginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view sd_addSubviews:@[btn]];
    btn.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(_pwdText,30)
    .widthIs(624/2)
    .heightIs(44);
    //忘记密码
    UIButton * wangji =[UIButton buttonWithType:UIButtonTypeCustom];
    [wangji setTitle:@"忘记密码" forState:0];
    [wangji setTitleColor:[UIColor redColor] forState:0];
    wangji.titleLabel.font=[UIFont systemFontOfSize:14];
    wangji.alpha=.6;
    wangji.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [wangji addTarget:self action:@selector(wangji) forControlEvents:UIControlEventTouchUpInside];
    [self.view sd_addSubviews:@[wangji]];
    wangji.sd_layout
    .leftEqualToView(btn)
    .topSpaceToView(btn,20)
    .widthIs(100)
    .heightIs(20);
    //注册按钮
    UIButton * zhuce =[UIButton buttonWithType:UIButtonTypeCustom];
    [zhuce setTitle:@"还没注册?" forState:0];
    [zhuce setTitleColor:[UIColor redColor] forState:0];
    zhuce.titleLabel.font=[UIFont systemFontOfSize:14];
    zhuce.alpha=.6;
    zhuce.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [zhuce addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view sd_addSubviews:@[zhuce]];
    zhuce.sd_layout
    .rightEqualToView(btn)
    .topSpaceToView(btn,20)
    .widthIs(100)
    .heightIs(20);
    
    
    
}
#pragma mark --登录按钮
-(void)loginBtn{
    [NSUSE_DEFO setObject:@"token" forKey:@"token"];
    [NSUSE_DEFO synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --忘记密码
-(void)wangji{
    [NSUSE_DEFO removeObjectForKey:@"token"];
    [NSUSE_DEFO synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --注册按钮
-(void)zhuce{
    RegisteViewController * vc =[RegisteViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --文本框前面图片
-(UIButton*)imageViewNameStr:(NSString*)imageName{
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:0];
    
    btn.frame=CGRectMake(0, 0, 30, 30);
    return btn;
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
