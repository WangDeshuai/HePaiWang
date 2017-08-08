//
//  AlertViewXY.m
//  DistributionQuery
//
//  Created by Macx on 17/6/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "AlertViewXY.h"

@implementation AlertViewXY

- (id)initWithTitle:(NSString*)title  contentName:(NSString*)content achiveBtn:(NSString*)btnName {
    self=[super init];
    if (self) {
        
      
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=10;
        self.clipsToBounds=YES;
        //温馨提示
        UILabel * titleLable =[UILabel new];
        titleLable.textAlignment=1;
        titleLable.text=title;
        titleLable.font=[UIFont systemFontOfSize:16];
        [self sd_addSubviews:@[titleLable]];
        titleLable.sd_layout
        .leftSpaceToView(self,15)
        .rightSpaceToView(self,15)
        .topSpaceToView(self,10)
        .heightIs(20);
        //内容
        UILabel * contentlabel =[UILabel new];
        contentlabel.text=content;
        contentlabel.textColor=[UIColor redColor];
        contentlabel.font=[UIFont systemFontOfSize:15];
        [self sd_addSubviews:@[contentlabel]];
        contentlabel.sd_layout
        .leftSpaceToView(self,15)
        .rightSpaceToView(self,15)
        .topSpaceToView(titleLable,15)
        .autoHeightRatio(0);
        
        
        //线条
        UIView * linView =[UIView new];
        linView.backgroundColor=[UIColor blackColor];
        linView.alpha=.2;
        [self sd_addSubviews:@[linView]];
        linView.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .bottomSpaceToView(self,45)
        .heightIs(1);
        
        UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:btnName forState:0];
        [button setTitleColor:[UIColor blackColor] forState:0];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(btnClink) forControlEvents:UIControlEventTouchUpInside];
        button.sd_cornerRadius=@(5);
        [self sd_addSubviews:@[button]];
        button.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(linView,0)
        .widthIs(120)
        .heightIs(45);
        

    }
    return self;
}


-(void)btnClink{
   
    [self dissmiss];
}

- (void)show{
    //获取window对象
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.center=window.center;
    self.bounds=CGRectMake(0, 0, ScreenWidth-80, ScreenHeight/4);
    
    UIButton * view = [UIButton buttonWithType:UIButtonTypeCustom];//
    view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [view addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.2;
    view.tag=1000;
    [window addSubview:view];
    [window addSubview:self];
    
//    [UIView animateWithDuration:1 animations:^{
//        self.frame=CGRectMake(0, ScreenHeight-ScreenHeight/2, ScreenWidth, ScreenHeight/2);
//        
//    }];
    
    
}
-(void)dissmiss{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView * view =[window viewWithTag:1000];
    
    [view removeFromSuperview];
    [self removeFromSuperview];
    
    
    
}
@end
