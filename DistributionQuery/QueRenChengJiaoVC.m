//
//  QueRenChengJiaoVC.m
//  DistributionQuery
//
//  Created by Macx on 17/4/17.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "QueRenChengJiaoVC.h"
#import "SignView.h"
@interface QueRenChengJiaoVC ()<UIWebViewDelegate,ImageDalegate>
@property(nonatomic,strong)UIScrollView * myScrollView;
@property(nonatomic,strong) SignView * vcvc;
@end

@implementation QueRenChengJiaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_tagg==2) {
        self.title=@"签订委托拍卖合同";
    }else{
        self.title=@"拍卖成交确认书";
    }
    SignView * vc =[[SignView alloc]initWithFrame:CGRectMake(0, 700, ScreenWidth, ScreenHeight/2)];
    _vcvc=vc;
    self.view.backgroundColor=[UIColor whiteColor];
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-50)];
    _myScrollView.userInteractionEnabled=YES;
    _myScrollView.backgroundColor=[UIColor redColor];
    [self.view addSubview:_myScrollView];
    
    
    UIButton * sureBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.sd_cornerRadius=@(5);
    sureBtn.backgroundColor=[UIColor redColor];
    [sureBtn setTitle:@"确认签字" forState:0];
    [sureBtn addTarget:self action:@selector(queRenBtn) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.view sd_addSubviews:@[sureBtn]];
    sureBtn.sd_layout
    .leftSpaceToView(self.view,ScreenWidth/3.5)
    .rightSpaceToView(self.view,ScreenWidth/3.5)
    .bottomSpaceToView(self.view,5)
    .heightIs(40);
    
    UIWebView * webview =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-50)];
    webview.backgroundColor=[UIColor yellowColor];
    webview.delegate=self;

    [_myScrollView addSubview:webview];
    [LCProgressHUD showMessage:@"请稍后..."];
    
    if (_tagg==2) {
        [Engine myWeiTuoHtmlBtnBiaoDiID:@"10" success:^(NSDictionary *dic) {
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSString * content =[dic objectForKey:@"content"];
                [webview loadHTMLString:content baseURL:nil];
                [LCProgressHUD hide];
            }else{
                [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
            }
        } error:^(NSError *error) {
            
        }];
    }else{
        [Engine chaKanQueRenShuBiaoDiID:@"10" success:^(NSDictionary *dic) {
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSString * content =[dic objectForKey:@"content"];
                [webview loadHTMLString:content baseURL:nil];
                [LCProgressHUD hide];
            }else{
                [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
            }
            
        } error:^(NSError *error) {
            [LCProgressHUD showMessage:@"网络超时"];
        }];
  
    }
    
    
    
//    UIView * bgview =[UIView new];
//    bgview.backgroundColor=[UIColor redColor];
//    [webview sd_addSubviews:@[bgview]];
//    bgview.sd_layout
//    .leftSpaceToView(webview,0)
//    .rightSpaceToView(webview,0)
//    .bottomSpaceToView(webview,20)
//    .heightIs(120);
    
    
    
}
-(void)queRenBtn{
   
    _vcvc.delegate=self;
    [self.view addSubview:_vcvc];
    [self.view bringSubviewToFront:_vcvc];
    [UIView animateWithDuration:1 animations:^{
        _vcvc.frame=CGRectMake(0, ScreenHeight-ScreenHeight/2-64, ScreenWidth, ScreenHeight/2);
        
    }];

}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    for (int i =0; i<20; i++) {
        NSString *meta = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].style.width = '100%%'", i];
        [webView stringByEvaluatingJavaScriptFromString:meta];
    }
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    NSLog(@"输出高度%f",height);
    
    webView.frame = CGRectMake(0, 0, ScreenWidth, height);
    UIScrollView *tempView = (UIScrollView *)[webView.subviews objectAtIndex:0];
     tempView.scrollEnabled = NO;
   //改变滚动试图的滑动
    self.myScrollView.contentSize = CGSizeMake(ScreenWidth, height+200);
}



- (void)showImage:(UIImage *)image
{
}
-(void)buttonClinkTwo:(UIButton*)btn{
    if (btn.tag==0) {
        //取消
        _vcvc.frame=CGRectMake(0, ScreenHeight-ScreenHeight/2-64, ScreenWidth, ScreenHeight/2);
        [UIView animateWithDuration:1 animations:^{
            _vcvc.frame=CGRectMake(0, 700, ScreenWidth, ScreenHeight/2);
        }];
    }else{
        //确认
        [LCProgressHUD showMessage:@"签名成功"];
        _vcvc.frame=CGRectMake(0, ScreenHeight-ScreenHeight/2-64, ScreenWidth, ScreenHeight/2);
        [UIView animateWithDuration:1 animations:^{
            _vcvc.frame=CGRectMake(0, 700, ScreenWidth, ScreenHeight/2);
        }];
        
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
