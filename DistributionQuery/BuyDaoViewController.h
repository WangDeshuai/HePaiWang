//
//  BuyDaoViewController.h
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BaseViewController.h"

@interface BuyDaoViewController : BaseViewController
/*
 tagg==0 全部
 tagg==1 已交割
 tagg==2 未交割
 */
@property(nonatomic,assign)int tagg;
@end
