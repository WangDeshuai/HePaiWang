//
//  RegisteViewController.m
//  DistributionQuery
//
//  Created by Macx on 16/11/18.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "RegisteViewController.h"

@interface RegisteViewController ()
@property(nonatomic,strong)UITextField * phoneText;
@property(nonatomic,strong)UITextField * codeText;
@property(nonatomic,strong)UITextField * pwdText;
@property(nonatomic,strong)UITextField * pwddText;
@end

@implementation RegisteViewController
//-(void)viewWillAppear:(BOOL)animated
//{
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
//}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"注册";
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
    [self CreatTextField];
    
   
    
}
#pragma mark --chuangj文本框
-(void)CreatTextField
{
    //获取验证码
    UIButton * yanzhengMaBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [yanzhengMaBtn setTitle:@"获取验证码" forState:0];
    [yanzhengMaBtn setTitleColor:[UIColor whiteColor] forState:0];
    yanzhengMaBtn.backgroundColor=[UIColor redColor];
    yanzhengMaBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    yanzhengMaBtn.alpha=.6;
   // yanzhengMaBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [yanzhengMaBtn addTarget:self action:@selector(yanZhenMa:) forControlEvents:UIControlEventTouchUpInside];
    [self.view sd_addSubviews:@[yanzhengMaBtn]];
    yanzhengMaBtn.sd_layout
    .rightSpaceToView(self.view,15)
    .topSpaceToView(self.view,20)
    .widthIs(170/2)
    .heightIs(60/2);
    
    
    
//文本框
    _phoneText=[UITextField new];
    _phoneText.placeholder=@"请输入手机号";
    _phoneText.font=[UIFont systemFontOfSize:16];
    _phoneText.leftView =[self imageViewNameStr:@"zhuce_phone"];
    _phoneText.leftViewMode = UITextFieldViewModeAlways;
    _phoneText.keyboardType=UIKeyboardTypeNumberPad;
//    _phoneText.backgroundColor=[UIColor redColor];
    [self.view sd_addSubviews:@[_phoneText]];
    _phoneText.sd_layout
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(yanzhengMaBtn,10)
    .topSpaceToView(self.view,10)
    .heightIs(45);
   
    //验证码
    _codeText=[UITextField new];
    _codeText.placeholder=@"请输入手机验证码";
    _codeText.font=[UIFont systemFontOfSize:16];
    _codeText.leftView =[self imageViewNameStr:@"zhuce_yanzheng"];
    _codeText.leftViewMode = UITextFieldViewModeAlways;
    _codeText.keyboardType=UIKeyboardTypeNumberPad;
//    _codeText.backgroundColor=[UIColor redColor];
    [self.view sd_addSubviews:@[_codeText]];
    _codeText.sd_layout
    .leftEqualToView(_phoneText)
    .rightEqualToView(_phoneText)
    .topSpaceToView(_phoneText,10)
    .heightRatioToView(_phoneText,1);
   
    //密码
    _pwdText=[UITextField new];
    _pwdText.placeholder=@"请输入密码";
    _pwdText.font=[UIFont systemFontOfSize:16];
    _pwdText.leftView =[self imageViewNameStr:@"zhuce_mima"];
    _pwdText.leftViewMode = UITextFieldViewModeAlways;
//    _pwdText.backgroundColor=[UIColor redColor];
    [self.view sd_addSubviews:@[_pwdText]];
    _pwdText.sd_layout
    .leftEqualToView(_phoneText)
    .rightEqualToView(_phoneText)
    .topSpaceToView(_codeText,10)
    .heightRatioToView(_phoneText,1);
    
    //再次输入密码
    _pwddText=[UITextField new];
    _pwddText.placeholder=@"请再次输入密码";
    _pwddText.font=[UIFont systemFontOfSize:16];
    _pwddText.leftView =[self imageViewNameStr:@"zhuce_mima"];
    _pwddText.leftViewMode = UITextFieldViewModeAlways;
//    _pwddText.backgroundColor=[UIColor redColor];
    [self.view sd_addSubviews:@[_pwddText]];
    _pwddText.sd_layout
    .leftEqualToView(_phoneText)
    .rightEqualToView(_phoneText)
    .topSpaceToView(_pwdText,10)
    .heightRatioToView(_phoneText,1);
    
    
    //登录按钮
    UIButton * loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setImage:[UIImage imageNamed:@"zhuce_bt"] forState:0];
    [loginBtn addTarget:self action:@selector(loginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view sd_addSubviews:@[loginBtn]];
    loginBtn.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(_pwddText,20)
    .widthIs(650/2)
    .heightIs(91/2);
    
    
    
}

#pragma mark --验证码
-(void)yanZhenMa:(UIButton*)sender{
    [Engine getMessageCodePhone:_phoneText.text success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            __block int timeout=60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                        sender.userInteractionEnabled = YES;
                    });
                }
                else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        //NSLog(@"____%@",strTime);
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [sender setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        sender.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
        
    } error:^(NSError *error) {
        
    }];
}
#pragma mark --注册按钮
-(void)loginBtn{
    NSLog(@">>>%@",_phoneText.text);
    NSLog(@">>>%@",_codeText.text);
    NSLog(@">>>%@",_pwdText.text);
    NSLog(@">>>%@",_pwddText.text);
    [Engine registPhone:_phoneText.text Password:_pwdText.text password2:_pwddText.text Code:_codeText.text success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            self.loginPaswordBlock(_phoneText.text,_pwdText.text);
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    } error:^(NSError *error) {
        
    }];
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
-(UIButton*)imageViewNameStr:(NSString*)imageName{
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:0];
    
    btn.frame=CGRectMake(0, 0, 30, 30);
    return btn;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
