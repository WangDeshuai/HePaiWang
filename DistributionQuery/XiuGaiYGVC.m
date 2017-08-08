//
//  XiuGaiYGVC.m
//  DistributionQuery
//
//  Created by Macx on 17/7/29.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "XiuGaiYGVC.h"

@interface XiuGaiYGVC ()<UIWebViewDelegate>

@end

@implementation XiuGaiYGVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"预告内容";
    UIWebView * webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [webView loadHTMLString:_strContent baseURL:nil];
    [self.view addSubview:webView];
    
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
