//
//  ShengCityModel.h
//  DistributionQuery
//
//  Created by Macx on 17/3/1.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShengCityModel : NSObject
#pragma mark --省份解析
@property(nonatomic,copy)NSString * shengName;
@property(nonatomic,copy)NSString * shengCode;
-(id)initWithShengDic:(NSDictionary*)dic;
#pragma mark --城市解析
@property(nonatomic,copy)NSString * cityName;
@property(nonatomic,copy)NSString * cityCode;
@property(nonatomic,copy)NSString * cityShengCode;
-(id)initWithCityDic:(NSDictionary*)dic;
#pragma mark --县级解析
@property(nonatomic,copy)NSString * xianName;
@property(nonatomic,copy)NSString * xianCode;
@property(nonatomic,copy)NSString * xianShengCode;
@property(nonatomic,copy)NSString * xianCityCode;
-(id)initWithXianDic:(NSDictionary*)dic;

#pragma mark --标的类型也放着里面吧
@property(nonatomic,copy)NSString * biaoDiCode;
@property(nonatomic,copy)NSString * biaoDiName;
-(id)initWithBiaoDiDic:(NSDictionary*)dic;
@end
