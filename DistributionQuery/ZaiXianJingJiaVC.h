//
//  ZaiXianJingJiaVC.h
//  DistributionQuery
//
//  Created by Macx on 16/11/24.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BaseViewController.h"

@interface ZaiXianJingJiaVC : BaseViewController
@property(nonatomic,copy)NSString * paiMaiID;
@property(nonatomic,copy)NSString * biaoDiID;
//没有创建model,必须单个独立往在线竞价界面传值
@property(nonatomic,strong)NSArray * lunbiArr;
@property(nonatomic,copy)NSString *titlename;
@property(nonatomic,copy)NSString * price1;
@property(nonatomic,copy)NSString * price2;
@property(nonatomic,copy)NSString * price3;
@property(nonatomic,copy)NSString * diJia;
@property(nonatomic,copy)NSString * jingMaiPai;
@property(nonatomic,copy)NSString * dataSoure;
@end
