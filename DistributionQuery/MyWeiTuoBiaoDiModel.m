//
//  MyWeiTuoBiaoDiModel.m
//  DistributionQuery
//
//  Created by Macx on 17/3/12.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MyWeiTuoBiaoDiModel.h"

@implementation MyWeiTuoBiaoDiModel
-(id)initWithMyWeiTuoDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        _messageID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
        _headImage=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_img"]]];
        _titleName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_name"]]];
        _timeName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time"]]];
        NSString * pric =[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_start_price"]]];
        if ([pric floatValue]>10000) {
            _priceName=[NSString stringWithFormat:@"%.2f万",[pric floatValue]/10000];
        }else{
            _priceName=[NSString stringWithFormat:@"%@元",pric];
        }
        
        
        _diQu=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_cityname"]]];
    }
    
    return self;
}
@end
