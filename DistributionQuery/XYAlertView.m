//
//  XYAlertView.m
//  DistributionQuery
//
//  Created by Macx on 17/3/10.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "XYAlertView.h"

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
        self.bounds=CGRectMake(0, 0, ScreenWidth-60, ScreenWidth-60);
        self.backgroundColor=[UIColor magentaColor];
        
        
        
    }
    
    return self;
    
}














- (void)show{
    //获取window对象
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    //设置中心点
    self.center = window.center;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    view.tag=1000;
    [window addSubview:view];
    [window addSubview:self];
    
}
-(void)dissmiss{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView * view =[window viewWithTag:1000];
    [view removeFromSuperview];
    [self removeFromSuperview];
    
}



@end
