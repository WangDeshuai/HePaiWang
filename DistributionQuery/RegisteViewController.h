//
//  RegisteViewController.h
//  DistributionQuery
//
//  Created by Macx on 16/11/18.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisteViewController : BaseViewController
@property(nonatomic,copy)void(^loginPaswordBlock)(NSString*loginStr,NSString*pswStr);
@end
