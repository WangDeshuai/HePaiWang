//
//  WeiTuoXiuGaiVC.h
//  DistributionQuery
//
//  Created by Macx on 17/3/9.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "BaseViewController.h"

@interface WeiTuoXiuGaiVC : BaseViewController
@property(nonatomic,assign)int indexrow;
@property(nonatomic,copy)NSString * contentText;
@property(nonatomic,copy)NSAttributedString * neiRong;
@property(nonatomic,copy)void(^nameBlock)(NSString*diQuName,NSString*shengCode,NSString*cityCode,NSString*xianCode);
@end
