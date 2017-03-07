//
//  PaiMaiBiaoDiModel.m
//  DistributionQuery
//
//  Created by Macx on 17/3/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "PaiMaiBiaoDiModel.h"

@implementation PaiMaiBiaoDiModel
//拍卖标的
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
        _price=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_start_price"]]];
        _diqu=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"cityname"]]];
        _time=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_begin_time"]]];
        _messageID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_id"]]];
    }
    
    return self;
}
@end
