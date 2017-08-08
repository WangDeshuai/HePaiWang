//
//  XieYiJingMaiVC.m
//  DistributionQuery
//
//  Created by Macx on 17/4/29.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "XieYiJingMaiVC.h"
#import "SignView.h"
#import "XYAlertView.h"
#import "BaoZhengJinAlert.h"
@interface XieYiJingMaiVC ()<UIWebViewDelegate,ImageDalegate1>
@property(nonatomic,strong)UIScrollView * myScrollView;
@property(nonatomic,strong) SignView * vcvc;
@property(nonatomic,strong)UIImage * image1;
//@property(nonatomic,strong)UIImageView * sineImage;
@property(nonatomic,strong)UIWebView * webView;
@end

@implementation XieYiJingMaiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"竞买协议";
    SignView * vc =[[SignView alloc]initWithFrame:CGRectMake(0, 700, ScreenWidth, ScreenHeight/2)];
    _vcvc=vc;
    self.view.backgroundColor=[UIColor whiteColor];
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-50)];
    _myScrollView.userInteractionEnabled=YES;
    _myScrollView.backgroundColor=[UIColor whiteColor];
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
    _webView=webview;
    webview.backgroundColor=[UIColor whiteColor];
    webview.delegate=self;
    
    [_myScrollView addSubview:webview];
    [LCProgressHUD showMessage:@"请稍后..."];
    
    [Engine JingMaiXieYiContentPaiMaiHuiID:[ToolClass isString:[NSString stringWithFormat:@"%@",_paiMaiHuiID]] success:^(NSDictionary *dic) {
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
    
//    _sineImage=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    _sineImage.backgroundColor=[UIColor redColor];
//    [webview addSubview:_sineImage];
//    
//        
//    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
//    [_sineImage setUserInteractionEnabled:YES];
//    [_sineImage addGestureRecognizer:panGR];

}
- (void)panGRAct: (UIPanGestureRecognizer *)rec{
    
    
    CGPoint point = [rec translationInView:_webView];
    //    NSLog(@"%f,%f",point.x,point.y);
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    [rec setTranslation:CGPointMake(0, 0) inView:_webView];
    
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
    self.myScrollView.contentSize = CGSizeMake(ScreenWidth, height+20);
}




-(void)buttonClinkTwo:(UIButton*)btn Image:(UIImage *)image{
    if (btn.tag==0) {
        //取消
        _vcvc.frame=CGRectMake(0, ScreenHeight-ScreenHeight/2-64, ScreenWidth, ScreenHeight/2);
        [UIView animateWithDuration:1 animations:^{
            _vcvc.frame=CGRectMake(0, 700, ScreenWidth, ScreenHeight/2);
        }];
    }else{
        //确认
        if (image==nil) {
            [LCProgressHUD showMessage:@"请签字"];
            return;
        }
        _vcvc.frame=CGRectMake(0, ScreenHeight-ScreenHeight/2-64, ScreenWidth, ScreenHeight/2);
        [UIView animateWithDuration:1 animations:^{
            _vcvc.frame=CGRectMake(0, 700, ScreenWidth, ScreenHeight/2);
        }];
//        _sineImage.image=image;
        //1.竞买协议签名这，是只要签名，还是要签名和背景图片
        //2.已经上传过签名了，是不是应该直接弹出保证金和报名弹框
        
        
        [Engine headImage:image PaiMaiHuiID:_paiMaiHuiID BiaoDiID:_biaoDiID success:^(NSDictionary *dic) {
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
             //   [self BaoMing]; 弹一个保证金信息baoZhengJin54PaiMaiHuiID
               
                [Engine baoZhengJin54PaiMaiHuiID:_paiMaiHuiID success:^(NSDictionary *dic) {
                    NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                    if ([code isEqualToString:@"1"]) {
                        if ([dic objectForKey:@"content"]==[NSNull null]) {
                            [LCProgressHUD showMessage:@"无数据"];
                            return ;
                        }
                        NSDictionary * contentDic =[dic objectForKey:@"content"];
                         [self priceTanKuangDic:contentDic];
                    }else{
                        [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
                    }
                } error:^(NSError *error) {
                    
                }];
                
                
                
            }else{
                [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
            }
        } error:^(NSError *error) {
            
        }];
        
       //
    }
}


//保证进弹框
-(void)priceTanKuangDic:(NSDictionary*)dic{
    BaoZhengJinAlert * altview =[[BaoZhengJinAlert alloc]initWithTitle:@"保证金" contentName:dic achiveBtn:@"我知道了"];
     __weak __typeof(altview)weakSelf = altview;
    altview.buttonBlock=^(UIButton*btn){
        [weakSelf dissmiss];
        [self BaoMing];
        
    };
    [altview show];
}



//报名弹框
-(void)BaoMing{
    XYAlertView * xv =[[XYAlertView alloc]initWithTitle:@"我要报名" alerMessage:@"提交信息" canCleBtn:@"提交信息" otheBtn:@""];
    __weak __typeof(xv)weakSelf = xv;
    xv.NameBlock=^(NSString*people,NSString*phone,NSString*other){
        // 调用接口
        [LCProgressHUD showLoading:@"正在报名..."];
        [Engine BaoMingCanJianPaiMaiID:_paiMaiHuiID BiaoDiID:_biaoDiID Phone:phone PeopleName:people MessageName:other success:^(NSDictionary *dic) {
            
            NSString * code =[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
            if ([code isEqualToString:@"1"]) {
                [weakSelf dissmiss];
                [LCProgressHUD hide];
                UIAlertController * actionview=[UIAlertController alertControllerWithTitle:@"温馨提示" message:[dic objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action =[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                
                [actionview addAction:action];
                [self presentViewController:actionview animated:YES completion:nil];
                
                
            }else{
                [LCProgressHUD showMessage:[dic objectForKey:@"msg"]];
            }
        } error:^(NSError *error) {
            
        }];
    };
    
    [xv show];
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
