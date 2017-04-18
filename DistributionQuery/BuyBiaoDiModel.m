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
        _biaoDiId=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_id"]]];
    }
    
    return self;
}
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

//交易明细
-(id)initWithJiaoYiMingXiDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        //明细编号
        _mxBianHao=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_number"]]];
        //标的名称
        _mxName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_name"]]];
        //所在地
        NSString * sheng =[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_provname"]]];
        NSString * city =[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_cityname"]]];
        _mxAddress=[NSString stringWithFormat:@"%@-%@",sheng,city];
        //标的保证金
        NSString * a=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"auction_deposit_value"]]];
        NSString * aa=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"deposit_status_name"]]];
        _mxBaoZheng=[NSString stringWithFormat:@"%@元(%@)",a,aa];
        //标的成交价
        NSString * s=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_transaction_price"]]];
        NSString * ss=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"transaction_price_status_name"]]];
        
        _mxChengJiao=[NSString stringWithFormat:@"%@元(%@)",s,ss];
        //标的佣金
        NSString * b=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"real_target_brokerage_buyer_price"]]];
        NSString * bb=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"brokerage_side_type_name"]]];//买方
        NSString * bbb=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_brokerage_buyer_price"]]];//百分比
        _mxYongJin=[NSString stringWithFormat:@"%@元(%@成交价款%@)",b,bb,bbb];
       
        
        
         //总计金额
        _mxZonge=[ToolClass isString:[NSString stringWithFormat:@"%@元",[dic objectForKey:@"total_money"]]];
        //还需缴纳尾款
        _mxWeiKuan=[ToolClass isString:[NSString stringWithFormat:@"%@元",[dic objectForKey:@"residue_money"]]];
        
    }
    
    return self;
}
//交割管理
-(id)initWithJiaoGeGuanLiDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        //明细编号
        _jgBianHao=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_number"]]];
        //标的名称
        _jgName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_name"]]];
        //所在地
        //所在地
        NSString * sheng =[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_provname"]]];
        NSString * city =[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_cityname"]]];
        _jgAddress=[NSString stringWithFormat:@"%@-%@",sheng,city];
        
        
        //还需缴纳尾款
        _jgWeiKuan=[ToolClass isString:[NSString stringWithFormat:@"%@元",[dic objectForKey:@"residue_money"]]];
        //交割状态
        _jgZhuTai=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"target_status_name"]]];
        //委托联系人方式
        _jgWeiTuoStyle=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"entruster_connect_tel"]]];
        //交货地址
        _jgJiaoHuoDiZhi=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"delivery_address"]]];
        //合拍标的交割服务专
         _jgHePaiBiaoDi=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"server_name"]]];
        //联系电话
        _jgPhone=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"server_connect_tel"]]];
    }
    
    return self;
}
@end
