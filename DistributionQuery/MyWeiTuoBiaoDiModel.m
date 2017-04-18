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
//委托标的详情
-(id)initWithBiaoDiXiangQingDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        //标题
        _xqtitlename=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_name"]]];
        //起拍价
        _xqprice=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_start_price"]]];
        //报名人数
        _xqbaoming=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"signup_number"]]];
        //设置提醒人数
        _xqtixing=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"remaind_number"]]];
        //浏览人数
        _xqliulan=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"browse_number"]]];
        //评估价
        _xqpinggu=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_estimated_price"]]];
        //最小加价幅度
        _xqjiajia=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_least_compete_step"]]];
        //保证金
        _xqbaozhengjin=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_deposit_value"]]];
        //标的类型名称
        _xqleixing=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_type_name"]]];
        //自由竞价
        _xqziyou=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_freely_compete_time"]]];
        //限时竞价
        _xqxianshi=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_limited_compete_time"]]];
        //保留价
        _xqbaoliujia=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_use_reserve_price"]]];
        //优先购买权
        _xqyouxian=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_use_preferential_buy"]]];
        //竞买须知
        _xqjingmai=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_compete_attention"]]];
        //竞买公告
        _xqgonggao=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_compete_declaration"]]];
        //标的物介绍
        _xqjieshao=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_description"]]];
        //轮播图
        _xqImage=[dic objectForKey:@"targetImgList"];
        
    }
    
    return self;
}
@end
