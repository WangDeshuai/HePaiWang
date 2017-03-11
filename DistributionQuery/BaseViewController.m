//
//  BaseViewController.m
//  DistributionQuery
//
//  Created by Macx on 16/10/8.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=BG_COLOR;
    _backHomeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backHomeBtn setImage:[UIImage imageNamed:@"back"] forState:0];
    _backHomeBtn.frame=CGRectMake(0, 0, 50, 30);
    _backHomeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_backHomeBtn addTarget:self action:@selector(backPopBtnPop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBtn2 =[[UIBarButtonItem alloc]initWithCustomView:_backHomeBtn];
    self.navigationItem.leftBarButtonItems=@[leftBtn2];
    
    _textHomeField=[UITextField new];
    _textHomeField.hidden=YES;
    _textHomeField.placeholder=@"搜索标的物";
    _textHomeField.layer.cornerRadius=3;
    _textHomeField.clipsToBounds=YES;
    _textHomeField.backgroundColor=[UIColor whiteColor];
    _textHomeField.font=[UIFont systemFontOfSize:14];
    _textHomeField.returnKeyType=UIReturnKeySearch;
    _textHomeField.tintColor = [UIColor redColor];
    _textHomeField.frame=CGRectMake(0, 0, ScreenWidth-150, 30);
    _textHomeField.leftView =[self imageViewNameStr:@"search"];
    _textHomeField.leftViewMode = UITextFieldViewModeAlways;
     self.navigationItem.titleView=_textHomeField;

}
-(void)backPopBtnPop
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setTitle:(NSString *)title
{
    UILabel * label =[[UILabel alloc]init];
    label.frame=CGRectMake(0, 0, 100, 30);
    label.text=title;
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:17];
    self.navigationItem.titleView=label;
    
}
//-(void)setTitle:(NSString *)title
//{
//   _t=[[UITextField alloc]init];
//    label.frame=CGRectMake(0, 0, 100, 30);
//    label.text=title;
//    label.textAlignment=1;
//    label.textColor=[UIColor redColor];
//    label.font=[UIFont systemFontOfSize:TITLE_FOUNT];
//    self.navigationItem.titleView=label;
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIButton*)imageViewNameStr:(NSString*)imageName{
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:0];
    btn.adjustsImageWhenHighlighted=NO;
    btn.frame=CGRectMake(0, 0, 30, 30);
    return btn;
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
