//
//  PaiMaiGongGaoXiangQingVC.h
//  DistributionQuery
//
//  Created by Macx on 16/11/28.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BaseViewController.h"

@interface PaiMaiGongGaoXiangQingVC : BaseViewController
@property(nonatomic,copy)NSString * paiMaiHuiID;//拍卖会ID
@property(nonatomic,copy)NSString * baioDiID;//标的ID(接收到的是空字符串，没有标的ID)
@property(nonatomic,copy)NSString * datasoure;
@end
