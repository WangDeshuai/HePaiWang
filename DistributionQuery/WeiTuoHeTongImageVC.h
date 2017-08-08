//
//  WeiTuoHeTongImageVC.h
//  DistributionQuery
//
//  Created by Macx on 17/6/27.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "BaseViewController.h"

@interface WeiTuoHeTongImageVC : BaseViewController
//tagg==1 我委托的标的----->委托合同进入(委托拍卖合同42接口)
//tagg==2 已买到的标的---->交个管理---->查看拍卖成交确认书(拍卖成交确认书37接口)
@property(nonatomic,assign)NSInteger tagg;
@property(nonatomic,copy)NSString * biaoDiID;
@end
