//
//  MingXiViewController.h
//  DistributionQuery
//
//  Created by Macx on 16/12/1.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BaseViewController.h"

@interface MingXiViewController : BaseViewController
//tagg==2，委托--->交易明细..否则的话就是已买到的标的
@property(nonatomic,assign)NSInteger tagg;
@property(nonatomic,copy)NSString * biaoDiID;
@end
