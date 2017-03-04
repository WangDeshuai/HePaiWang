//
//  XiuGaiMessageVC.h
//  DistributionQuery
//
//  Created by Macx on 17/3/2.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "BaseViewController.h"

@interface XiuGaiMessageVC : BaseViewController
@property(nonatomic,assign)int indexrow;
@property(nonatomic,copy)void(^nameBlock)(NSString*name);
@end
