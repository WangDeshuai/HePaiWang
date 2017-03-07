//
//  XiaoXiView.h
//  DistributionQuery
//
//  Created by Macx on 17/3/2.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "BaseViewController.h"
#import "XiaoXiModel.h"
@interface XiaoXiView : BaseViewController
/*
 tagg==1 消息列表
 tagg==2账户信息
 */
@property(nonatomic,assign)NSInteger tagg;
@property(nonatomic,strong)XiaoXiModel * model;
@end
