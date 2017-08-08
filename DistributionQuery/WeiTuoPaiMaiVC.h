//
//  WeiTuoPaiMaiVC.h
//  DistributionQuery
//
//  Created by Macx on 16/11/17.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BaseViewController.h"
#import "MyWeiTuoBiaoDiModel.h"
@interface WeiTuoPaiMaiVC : BaseViewController
//tagg==1从拍卖标的过来的，显示返回箭头
@property(nonatomic,assign)NSInteger tagg;
@property(nonatomic,strong)MyWeiTuoBiaoDiModel * model;
@end
