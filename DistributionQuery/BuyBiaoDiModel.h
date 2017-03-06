//
//  BuyBiaoDiModel.h
//  DistributionQuery
//
//  Created by Macx on 17/3/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyBiaoDiModel : NSObject
//已买到的标的
@property(nonatomic,copy)NSString *leftImage;
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *diqu;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString * messageID;
-(id)initWithBiaoDiDic:(NSDictionary*)dic;

@end
