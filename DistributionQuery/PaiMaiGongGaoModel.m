//
//  PaiMaiGongGaoModel.m
//  DistributionQuery
//
//  Created by Macx on 17/3/8.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "PaiMaiGongGaoModel.h"

@implementation PaiMaiGongGaoModel
//拍卖公告
//拍卖标的
-(id)initWithPaiMaiPublicDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
     
       
        _titleName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_name"]]];
        _strTime=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_add_time"]]];
        _endTime=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_begin_time"]]];
        NSString * sheng=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_provname"]]];
         NSString * city=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_cityname"]]];
        
        _diqu=[NSString stringWithFormat:@"%@%@",sheng,city];
        _messageID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    }
    
    return self;
}
@end
