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
        
        NSString * str =[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_start_price"]]];
        if ([str floatValue]>10000.00) {
            _price=[NSString stringWithFormat:@"%.2f万",[str floatValue]/10000];
        }else{
            _price=[NSString stringWithFormat:@"%@元",str];
        }

        
        _dataSoure=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"dataSource"]]];
        _diqu=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"cityname"]]];
        _time=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_begin_time"]]];
        _paiMaiID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_id"]]];
        _biaoDiID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_id"]]];
    }
    
    return self;
}
@end
