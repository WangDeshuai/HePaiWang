//
//  ChengJiaoAnLiModel.m
//  DistributionQuery
//
//  Created by Macx on 17/2/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ChengJiaoAnLiModel.h"

@implementation ChengJiaoAnLiModel
#pragma mark --成交案例
-(id)initWithChengJiaoAnliDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        _messageID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
        _biaoDiID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_id"]]];
        _paiMaiHuiID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_id"]]];
        _nameBiaoDi=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_name"]]];
        _priceBiaoDi=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_start_price"]]];
        _diquBiaoDi=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_cityname"]]];
        _strTime=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_begin_time"]]];
        _headImage=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_img"]]];
        _chengJiaoStye=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"status_name"]]];
    }
    
    return self;
}
@end
