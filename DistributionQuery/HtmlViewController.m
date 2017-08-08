//
//  HtmlViewController.m
//  DistributionQuery
//
//  Created by Macx on 17/3/14.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "HtmlViewController.h"

@interface HtmlViewController ()<UIWebViewDelegate>

@end

@implementation HtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=_titlename;
    NSLog(@"输出>>>%@",_str);
    
//    UILabel * gongGaoXiangQing =[UILabel new];
////    gongGaoXiangQing.font=[UIFont systemFontOfSize:16];
//    gongGaoXiangQing.alpha=.6;
////    gongGaoXiangQing.text=_str;
//    gongGaoXiangQing.attributedText=[ToolClass HTML:_str];
//    [self.view sd_addSubviews:@[gongGaoXiangQing]];
//    gongGaoXiangQing.sd_layout
//    .leftSpaceToView(self.view,0)
//    .rightSpaceToView(self.view,0)
//    .topSpaceToView(self.view,0)
//    .autoHeightRatio(0);
    
    UIWebView * webview =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    webview.backgroundColor=[UIColor whiteColor];
    webview.delegate=self;
    [self.view addSubview:webview];
     [webview loadHTMLString:_str baseURL:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    for (int i =0; i<20; i++) {
        NSString *meta = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].style.width = '100%%'", i];
        [webView stringByEvaluatingJavaScriptFromString:meta];
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
