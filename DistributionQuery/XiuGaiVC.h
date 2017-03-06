//
//  XiuGaiVC.h
//  DistributionQuery
//
//  Created by Macx on 17/3/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "BaseViewController.h"

@interface XiuGaiVC : BaseViewController
@property(nonatomic,copy)void(^messageBlock)(NSString*name);
@property(nonatomic,assign)NSInteger indexrow;
@property(nonatomic,copy)NSString * tagg;//tagg==1个人 2企业
@end
