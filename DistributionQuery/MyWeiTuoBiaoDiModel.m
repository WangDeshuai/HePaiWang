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
        _biaoDiID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
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
//委托标的详情
-(id)initWithBiaoDiXiangQingDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        //标题
        _xqlianxiren=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_liaisons_name"]]];
        //手机号
        _xqphone=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_connect_tel"]]];
        //标的名称
        _xqbiaoDiName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_name"]]];
        //标的描述
        _xqbiaoDiMiaoShu=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_description"]]];
        //瑕疵说明
        _xqxiaCi=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_defect_declaration"]]];
        //省name
        _xqShengName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_provname"]]];
        //市name
        _xqCityName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_cityname"]]];
        //县name
        _xqXianName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_districtname"]]];
        //省code
        _xqShengCode=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_provcode"]]];
        //市code
        _xqCityCode=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_citycode"]]];
        //县code
        _xqXianCode=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_districtcode"]]];
        //保留价
        _xqBaoLiuJia=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_reserve_price"]]];
        //评估价
        _xqPingGuJia=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_estimated_price"]]];
        _xqBiaoDiID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
        //
        _xqImage=[dic objectForKey:@"imgList"];
        
    }
    
    return self;
}
@end
