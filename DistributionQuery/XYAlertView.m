//
//  XYAlertView.m
//  DistributionQuery
//
//  Created by Macx on 17/3/10.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "XYAlertView.h"
@interface XYAlertView()<UITextViewDelegate>
@property(nonatomic,strong)UITextField * nameText;
@property(nonatomic,strong)UITextField * phoneText;
@property(nonatomic,strong)UITextView * otherText;
@property(nonatomic,assign)int selfWith;
@end
@implementation XYAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString*)title alerMessage:(NSString*)message canCleBtn:(NSString*)btnName1 otheBtn:(NSString*)btnName2{
    self=[super init];
    if (self) {
        if (ScreenWidth==320) {
            _selfWith=ScreenWidth-60;
        }else{
            _selfWith=ScreenWidth-100;
        }
        self.bounds=CGRectMake(0, 0, _selfWith, _selfWith);
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=5;
        self.clipsToBounds=YES;
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUpOrDown:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        //标题
        UILabel * titlelabel =[UILabel new];
        titlelabel.text=title;
        titlelabel.textAlignment=1;
        if (ScreenWidth==320) {
            titlelabel.font=[UIFont systemFontOfSize:15];
        }else{
              titlelabel.font=[UIFont systemFontOfSize:17];
        }
      
        titlelabel.backgroundColor=[UIColor lightGrayColor];
        titlelabel.textColor=[UIColor redColor];
        titlelabel.alpha=.7;
        [self sd_addSubviews:@[titlelabel]];
        titlelabel.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(self,0)
        .heightIs(50);
        
        
        
        
        
        
        NSDictionary * dic =[ToolClass duquPlistWenJianPlistName:@"baseInfo"];
        
        
        
        //提交信息
        UIButton * tijiaoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        tijiaoBtn.backgroundColor=[UIColor redColor];
        [tijiaoBtn setTitle:btnName1 forState:0];
        tijiaoBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        tijiaoBtn.layer.cornerRadius=5;
        tijiaoBtn.clipsToBounds=YES;
        [tijiaoBtn addTarget:self action:@selector(tijaoBtn) forControlEvents:UIControlEventTouchUpInside];
        [self sd_addSubviews:@[tijiaoBtn]];
        tijiaoBtn.sd_layout
        .centerXEqualToView(self)
        .bottomSpaceToView(self,10)
        .widthIs(self.frame.size.width/2)
        .heightIs(35);
        
        
        //姓名
        _nameText=[[UITextField alloc]init];
        _nameText.placeholder=@"请输入您的姓名";
        _nameText.alpha=1;
        _nameText.leftView =[self imageViewNameStr:@"login_adimin"];
        _nameText.leftViewMode = UITextFieldViewModeAlways;
        _nameText.font=[UIFont systemFontOfSize:15];
        if ([ToolClass isLogin]) {
            _nameText.text=[dic objectForKey:@"liaisons_name"];
        }
        
        [self sd_addSubviews:@[_nameText]];
        _nameText.sd_layout
        .leftSpaceToView(self,10)
        .rightSpaceToView(self,10)
        .heightIs(30)
        .topSpaceToView(titlelabel,20);
        
        //手机号
        _phoneText=[[UITextField alloc]init];
        _phoneText.placeholder=@"请输入您的手机号";
        _phoneText.alpha=1;
        _phoneText.leftView =[self imageViewNameStr:@"zhuce_phone"];
        _phoneText.leftViewMode = UITextFieldViewModeAlways;
        _phoneText.font=[UIFont systemFontOfSize:15];
        if ([ToolClass isLogin]) {
            _phoneText.text=[dic objectForKey:@"regist_tel"];
            _phoneText.enabled=NO;
        }
        [self sd_addSubviews:@[_phoneText]];
        _phoneText.sd_layout
        .leftSpaceToView(self,10)
        .rightSpaceToView(self,10)
        .heightIs(30)
        .topSpaceToView(_nameText,10);
        
        //textView
        _otherText=[UITextView new];
        _otherText.layer.borderColor=BG_COLOR.CGColor;
        _otherText.layer.borderWidth=1;
        _otherText.text=@"请输入其它补充信息...";
        _otherText.textColor=JXColor(76, 76, 76, 1);
         _otherText.font=[UIFont systemFontOfSize:15];
        _otherText.delegate=self;
        [self sd_addSubviews:@[_otherText]];
        _otherText.sd_layout
        .leftEqualToView(_phoneText)
        .rightEqualToView(_phoneText)
        .topSpaceToView(_phoneText,10)
        .bottomSpaceToView(tijiaoBtn,20);
        
//        _nameText.backgroundColor=[UIColor yellowColor];
//        _phoneText.backgroundColor=[UIColor magentaColor];
//        _otherText.backgroundColor=[UIColor greenColor];
        
        
    }
    
    return self;
    
}








-(void)tijaoBtn{
    //[self dissmiss];
    NSLog(@"姓名是>>>%@",_nameText.text);
    NSLog(@"手机号是>>>%@",_phoneText.text);
    NSLog(@"其它信息是>>>%@",_otherText.text);
    self.NameBlock(_nameText.text,_phoneText.text,_otherText.text);
}





- (void)show{
    //获取window对象
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    //设置中心点
    self.center = window.center;
    UIButton * view = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.backgroundColor = [UIColor blackColor];
//    [view addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
    view.alpha = 0.5;
    view.tag=1000;
    [window addSubview:view];
    [window addSubview:self];
    
}
-(void)dissmiss{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIButton * view =[window viewWithTag:1000];
    [view removeFromSuperview];
    [self removeFromSuperview];
    
}

-(UIButton*)imageViewNameStr:(NSString*)imageName{
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:0];
    
    btn.frame=CGRectMake(0, 0, 30, 30);
    return btn;
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
    //表的坐标
   // float f =(ScreenHeight-ScreenWidth-50)/2;
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//     self.center = window.center;
    if (rect.origin.y==ScreenHeight) {
        //键盘落下
        self.center = WINDOW.center;
        self.bounds = CGRectMake(0,  0, _selfWith,_selfWith );
    }else{
        //键盘升起
        if (ScreenWidth==320) {
             self.frame = CGRectMake(30,  64, ScreenWidth-60,ScreenWidth-60 );
        }else{
             self.frame = CGRectMake(50,  64, ScreenWidth-100,ScreenWidth-100 );
        }
        
    }
   
//    NSLog(@"数出%f>>>%f",ScreenWidth,ScreenHeight);
//    NSLog(@"0>>>%f",f);
//    NSLog(@"1输出%f",rect.origin.y);
//     NSLog(@"2输出%f",rect.size.height);
    [UIView commitAnimations];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
-(void)textViewDidBeginEditing:(UITextView*)textView{
    if ([textView.text isEqualToString:@"请输入其它补充信息..."])
    {
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
-(void)textViewDidEndEditing:(UITextView*)textView{
    if(textView.text.length<1){
        textView.text=@"请输入其它补充信息...";
        textView.textColor=JXColor(76, 76, 76, 1);
    }

}
@end
