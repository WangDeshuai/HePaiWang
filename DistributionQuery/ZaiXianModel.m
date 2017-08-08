//
//  ZaiXianModel.m
//  DistributionQuery
//
//  Created by Macx on 17/3/29.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ZaiXianModel.h"

@implementation ZaiXianModel
-(id)initWithChuJiaJiluDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        NSString * yuan =[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"bid_money"]]];
        
//        if ([yuan floatValue]>10000) {
//            _moneyName=[NSString stringWithFormat:@"%.2f万",[yuan floatValue]/10000];
//        }else{
            _moneyName=[NSString stringWithFormat:@"%@元",yuan];
//        }
        
         _moneyPrice=[NSString stringWithFormat:@"%@",yuan];
        _jingPaiNum=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"compete_number"]]];
        _timeName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"bid_time"]]];
        _userID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]]];
    }
    
    return self;
}
//竞买留言专区
-(id)initWithLiuYanZhuanQu:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        _faYanPeopleID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
        _faYanPeopleName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"speak_name"]]];
        _faYanPeopleTime=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"speak_time"]]];
        _faYanPeopleContent=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"speak_content"]]];
    }
    
    return self;
}
@end
