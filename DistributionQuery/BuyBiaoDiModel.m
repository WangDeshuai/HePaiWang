//
//  BuyBiaoDiModel.m
//  DistributionQuery
//
//  Created by Macx on 17/3/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "BuyBiaoDiModel.h"

@implementation BuyBiaoDiModel
//已买到的标的
-(id)initWithBiaoDiDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
//        NSString *leftImage;
//        NSString *titleName;
//        NSString *price;
//        NSString *diqu;
//        NSString *time;
//        NSString * messageID;
        _leftImage=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_img"]]];
        _titleName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_name"]]];
       
        NSString * str =[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_start_price"]]];
        if ([str floatValue]>10000.00) {
            _price=[NSString stringWithFormat:@"%.2f万",[str floatValue]/10000];
        }else{
            _price=[NSString stringWithFormat:@"%@元",str];
        }
        
        _diqu=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_cityname"]]];
        _time=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_begin_time"]]];
        _messageID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_id"]]];
    }
    
    return self;
}
@end
