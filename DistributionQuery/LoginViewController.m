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
-(void)viewWillAppear:(BOOL)animated
{
    _phoneText.text=@"15176862165";
    _pwdText.text=@"123456";
}
#pragma mark --登录按钮
-(void)loginBtn{
    
    NSLog(@"登录账户：%@",_phoneText.text);
    NSLog(@"密码账户：%@",_pwdText.text);
    
    [Engine loginAccount:_phoneText.text Password:_pwdText.text success:^(NSDictionary *dic) {
        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
        NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary * dicc =[dic objectForKey:@"content"];
            NSMutableDictionary * dicAr = [ToolClass isDictionary:dicc];
            NSLog(@"输出%@",dicAr);
            //1.把返回的字段内容缓存为plist文件
            [ToolClass savePlist:dicAr name:@"baseInfo"];
            //2.把idd当做token存起来，用以判断是否登录
            NSString * idd =[NSString stringWithFormat:@"%@",[dicc objectForKey:@"id"]];
            [NSUSE_DEFO setObject:idd forKey:@"token"];
            [NSUSE_DEFO synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } error:^(NSError *error) {
        
    }];
    

}
#pragma mark --忘记密码
-(void)wangji{
   
}
#pragma mark --注册按钮
-(void)zhuce{
    RegisteViewController * vc =[RegisteViewController new];
    vc.loginPaswordBlock=^(NSString*login,NSString*psw){
        _phoneText.text=login;
        _pwdText.text=psw;
    };
    
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

//-(NSMutableDictionary*)nsssss:(NSDictionary*)dic{
//    
//    
//    NSMutableArray * valueArr =[NSMutableArray new];
//    NSMutableArray * keyArr =[NSMutableArray new];
//    NSMutableDictionary * dicc =[NSMutableDictionary new];
//    //遍历所有的键值
//    for (NSString * value in [dic allValues]) {
//        NSString * str = [NSString stringWithFormat:@"%@",value];
//        NSString * str1 =[ToolClass isString:str];
//        [valueArr addObject:str1];
//
//    }
//    
//    //遍历所有的键名
//    for (NSString * key in [dic allKeys]) {
//        [keyArr addObject:key];
//    }
//
//    
//    if (keyArr.count==valueArr.count) {
//        
//        for (int i =0; i<keyArr.count; i++) {
//            [dicc setObject:valueArr[i] forKey:keyArr[i]];
//        }
//        return dicc;
//    }else{
//        [LCProgressHUD showMessage:@"键名键值对应不上，请联系开发人员"];
//        return nil;
//    }
//    
//    
//    
//}



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
