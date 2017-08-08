//
//  JiaoGeGuanLiVC.h
//  DistributionQuery
//
//  Created by Macx on 16/12/1.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BaseViewController.h"

@interface JiaoGeGuanLiVC : BaseViewController
//tagg==2代表从 我委托的标的，其它是已买到的标的
@property(nonatomic,assign)NSInteger tagg;
@property(nonatomic,copy)NSString * biaoDiID;
@end
