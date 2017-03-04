//
//  ShengCityModel.m
//  DistributionQuery
//
//  Created by Macx on 17/3/1.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ShengCityModel.h"

@implementation ShengCityModel
#pragma mark --省份解析
-(id)initWithShengDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {//p_sname是不带市，p_name带市或者省
        _shengName=[dic objectForKey:@"name"];
        _shengCode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
    }
    
    return self;
}
#pragma mark --城市解析
-(id)initWithCityDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        _cityName=[dic objectForKey:@"name"];
        _cityCode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        _cityShengCode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"parentProvCode"]];
    }
    
    return self;
}
#pragma mark --县级解析
-(id)initWithXianDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        _xianName=[dic objectForKey:@"name"];
        _xianCode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        _xianShengCode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"parentProvCode"]];
        _xianCityCode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"parentCityCode"]];
    }
    
    return self;
}

#pragma mark --标的类型也放着里面吧
-(id)initWithBiaoDiDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        _biaoDiCode=[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_type_number"]];
        _biaoDiName=[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_type_name"]];
    }
    
    return self;
}
@end
