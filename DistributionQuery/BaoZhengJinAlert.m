//
//  BaoZhengJinAlert.m
//  DistributionQuery
//
//  Created by Macx on 17/7/3.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "BaoZhengJinAlert.h"

@implementation BaoZhengJinAlert

- (id)initWithTitle:(NSString*)title  contentName:(NSDictionary*)contentDic achiveBtn:(NSString*)btnName {
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
        
        NSArray * arrayleft =@[@"拍卖会名称",@"保证金收取方式",@"保证金金额",@"银行名称",@"户名",@"账户",@"开户行所在地"];
        
        
        UILabel * leftLable;
        int g =20;
        int gj =20;
        for (int i=0; i<arrayleft.count; i++) {
            UILabel * namelabel =[UILabel new];
            namelabel.font=[UIFont systemFontOfSize:15];
            namelabel.text=arrayleft[i];
            [self sd_addSubviews:@[namelabel]];
            namelabel.sd_layout
            .leftSpaceToView(self,15)
            .topSpaceToView(titleLable,15+(gj+g)*i)
            .heightIs(g);
            leftLable=namelabel;
            [namelabel setSingleLineAutoResizeWithMaxWidth:200];
        }
        //拍卖会名称
        NSString * str1 =[ToolClass isString:[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"auction_name"]]];
        //保证金收取方式
        NSString * str2 =[ToolClass isString:[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"deposit_type_name"]]];
        //保证金金额
        NSString * jine =[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"auction_deposit_value"]];
        int jin =[jine intValue];
        NSString * str3;
        if (jin>10000) {
            str3=[NSString stringWithFormat:@"%d万",jin/10000];
        }else{
            str3=[NSString stringWithFormat:@"%d元",jin];
                
        }
        
        //银行名称
        NSString * str4 =[ToolClass isString:[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"bank_name"]]];
        //户名
        NSString * str5 =[ToolClass isString:[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"bank_user_name"]]];
        //账号
        NSString * str6 =[ToolClass isString:[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"bank_card_number"]]];
        //开户行所在地
        NSString * str7 =[ToolClass isString:[NSString stringWithFormat:@"%@",[contentDic objectForKey:@"bank_addr"]]];
        
        NSArray * rightArr =@[str1,str2,str3,str4,str5,str6,str7];
        UILabel * rightLabel;
        for (int i=0; i<rightArr.count; i++) {
            UILabel * contentlabel =[UILabel new];
            contentlabel.textColor=[UIColor redColor];
            contentlabel.textAlignment=2;
            contentlabel.font=[UIFont systemFontOfSize:15];
            contentlabel.text=rightArr[i];
            [self sd_addSubviews:@[contentlabel]];
            contentlabel.sd_layout
            .rightSpaceToView(self,15)
            .leftSpaceToView(leftLable,10)
            .topSpaceToView(titleLable,15+(20+20)*i)
            .autoHeightRatio(0);
            rightLabel=contentlabel;
          
        }
        
        
        
        
        
        //线条
        UIView * linView2 =[UIView new];
        linView2.backgroundColor=[UIColor blackColor];
        linView2.alpha=.2;
        [self sd_addSubviews:@[linView2]];
        linView2.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(rightLabel,25)
        .heightIs(1);
        
        
        //温馨提示
        UILabel * contentlabel5 =[UILabel new];
        contentlabel5.text=@"温馨提示";
        contentlabel5.textAlignment=1;
        contentlabel5.alpha=.4;
        contentlabel5.font=[UIFont systemFontOfSize:15];
        [self sd_addSubviews:@[contentlabel5]];
        contentlabel5.sd_layout
        .leftSpaceToView(self,15)
        .rightSpaceToView(self,15)
        .topSpaceToView(linView2,15)
        .autoHeightRatio(0);
        
        UILabel * contentlabel6 =[UILabel new];
        contentlabel6.text=@"您必须在缴纳保证金之后才可以参与标的的竞拍，未中标全额退还保证金，打款时请备注姓名加注册手机号！";
        contentlabel6.textAlignment=1;
        contentlabel6.alpha=.6;
        contentlabel6.textColor=[UIColor redColor];
        contentlabel6.font=[UIFont systemFontOfSize:15];
        [self sd_addSubviews:@[contentlabel6]];
        contentlabel6.sd_layout
        .leftSpaceToView(self,15)
        .rightSpaceToView(self,15)
        .topSpaceToView(contentlabel5,15)
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
        [button addTarget:self action:@selector(btnClink2:) forControlEvents:UIControlEventTouchUpInside];
        button.sd_cornerRadius=@(5);
        [self sd_addSubviews:@[button]];
        button.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(linView,0)
        .widthIs(120)
        .heightIs(45);
        
//        [self setupAutoHeightWithBottomView:button bottomMargin:10];
    }
    return self;
}

-(void)btnClink2:(UIButton*)btn{
    self.buttonBlock(btn);
}


-(void)btnClink{
    
    [self dissmiss];
}

- (void)show{
    //获取window对象
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.center=window.center;
    
    if (ScreenWidth==320) {
        self.bounds=CGRectMake(0, 0, ScreenWidth-40, ScreenHeight-40);
 
    }else{
        self.bounds=CGRectMake(0, 0, ScreenWidth-40, ScreenHeight/2+120);
  
    }
    
    
    UIButton * view = [UIButton buttonWithType:UIButtonTypeCustom];//
    view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    [view addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
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
