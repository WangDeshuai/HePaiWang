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
        NSString * price =[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_transaction_price"]]];
        if ([price intValue]>10000) {
            _priceBiaoDi=[NSString stringWithFormat:@"%d万",[price intValue]/10000];
        }else{
            _priceBiaoDi=[NSString stringWithFormat:@"%d元",[price intValue]];
        }
        _dataSoure=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"dataSource"]]];
        
        
        
        _diquBiaoDi=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_cityname"]]];
        _strTime=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_begin_time"]]];
        _headImage=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_img"]]];
        _chengJiaoStye=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"status_name"]]];
    }
    
    return self;
}
@end
