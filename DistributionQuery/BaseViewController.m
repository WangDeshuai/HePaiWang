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
    _backHomeBtn.frame=CGRectMake(0, 0, 70, 30);
    _backHomeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_backHomeBtn addTarget:self action:@selector(backPopBtnPop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBtn2 =[[UIBarButtonItem alloc]initWithCustomView:_backHomeBtn];
    self.navigationItem.leftBarButtonItems=@[leftBtn2];

}
-(void)backPopBtnPop
{
    [self.navigationController popViewControllerAnimated:YES];
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
