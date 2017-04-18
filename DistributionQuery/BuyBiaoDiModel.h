//
//  BuyBiaoDiModel.h
//  DistributionQuery
//
//  Created by Macx on 17/3/6.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyBiaoDiModel : NSObject
//已买到的标的
@property(nonatomic,copy)NSString *leftImage;
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *diqu;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString * biaoDiId;
-(id)initWithBiaoDiDic:(NSDictionary*)dic;
//已买到的标的详情
@property(nonatomic,copy)NSString *xqtitlename;//标题
@property(nonatomic,copy)NSString *xqprice;//起拍价
@property(nonatomic,copy)NSString *xqbaoming;//报名人数
@property(nonatomic,copy)NSString *xqtixing;//提醒人数
@property(nonatomic,copy)NSString *xqliulan;//浏览人数
@property(nonatomic,copy)NSString *xqpinggu;//评估价
@property(nonatomic,copy)NSString *xqjiajia;//加价幅度
@property(nonatomic,copy)NSString *xqbaozhengjin;//保证金
@property(nonatomic,copy)NSString *xqleixing;//类型
@property(nonatomic,copy)NSString *xqziyou;//自由竞价
@property(nonatomic,copy)NSString *xqbaoliujia;//保留价
@property(nonatomic,copy)NSString *xqxianshi;//限时竞价
@property(nonatomic,copy)NSString *xqyouxian;//优先购买权
@property(nonatomic,copy)NSString *xqjingmai;//竞买须知
@property(nonatomic,copy)NSString *xqgonggao;//竞买公告
@property(nonatomic,copy)NSString *xqjieshao;//标的物介绍
@property(nonatomic,strong)NSArray * xqImage;//轮播图
-(id)initWithBiaoDiXiangQingDic:(NSDictionary*)dic;
//交易明细
@property(nonatomic,copy)NSString * mxBianHao;//明细编号
@property(nonatomic,copy)NSString * mxName;//标的名称
@property(nonatomic,copy)NSString * mxAddress;//所在地
@property(nonatomic,copy)NSString * mxBaoZheng;//标的保证金
@property(nonatomic,copy)NSString * mxChengJiao;//标的成交价
@property(nonatomic,copy)NSString * mxYongJin;//标的佣金
@property(nonatomic,copy)NSString * mxZonge;//总计金额
@property(nonatomic,copy)NSString * mxWeiKuan;//还需缴纳尾款
-(id)initWithJiaoYiMingXiDic:(NSDictionary*)dic;
//交割管理
@property(nonatomic,copy)NSString * jgBianHao;//明细编号
@property(nonatomic,copy)NSString * jgName;//标的名称
@property(nonatomic,copy)NSString * jgAddress;//所在地

@property(nonatomic,copy)NSString * jgWeiKuan;//还需缴纳尾款

@property(nonatomic,copy)NSString * jgZhuTai;//交割状态
@property(nonatomic,copy)NSString * jgWeiTuoStyle;//委托联系人方式
@property(nonatomic,copy)NSString * jgJiaoHuoDiZhi;//交货地址

@property(nonatomic,copy)NSString * jgHePaiBiaoDi;//合拍标的交割服务专员
@property(nonatomic,copy)NSString * jgPhone;//联系电话
-(id)initWithJiaoGeGuanLiDic:(NSDictionary*)dic;


@end
