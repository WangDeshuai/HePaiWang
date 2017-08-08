//
//  PaiMaiGongGaoModel.h
//  DistributionQuery
//
//  Created by Macx on 17/3/8.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaiMaiGongGaoModel : NSObject
//拍卖公告
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,copy)NSString *strTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *diqu;
@property(nonatomic,copy)NSString * paiMaiHuiID;
@property(nonatomic,copy)NSString * dataSource;
-(id)initWithPaiMaiPublicDic:(NSDictionary*)dic;
@end
