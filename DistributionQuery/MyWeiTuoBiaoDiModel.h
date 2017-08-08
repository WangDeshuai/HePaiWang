//
//  MyWeiTuoBiaoDiModel.h
//  DistributionQuery
//
//  Created by Macx on 17/3/12.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>
//我委托的标的
@interface MyWeiTuoBiaoDiModel : NSObject
@property(nonatomic,copy)NSString * biaoDiID;
@property(nonatomic,copy)NSString * headImage;
@property(nonatomic,copy)NSString * titleName;
@property(nonatomic,copy)NSString * priceName;
@property(nonatomic,copy)NSString * diQu;
@property(nonatomic,copy)NSString * timeName;
-(id)initWithMyWeiTuoDic:(NSDictionary*)dic;
//已买到的标的详情
@property(nonatomic,copy)NSString *xqlianxiren;//联系人
@property(nonatomic,copy)NSString *xqphone;//手机号
@property(nonatomic,copy)NSString *xqbiaoDiName;//标的名称
@property(nonatomic,copy)NSString *xqbiaoDiMiaoShu;//标的描述
@property(nonatomic,copy)NSString *xqxiaCi;//瑕疵说明
@property(nonatomic,copy)NSString *xqShengName;//
@property(nonatomic,copy)NSString *xqCityName;//
@property(nonatomic,copy)NSString *xqXianName;//
@property(nonatomic,copy)NSString *xqShengCode;//
@property(nonatomic,copy)NSString *xqCityCode;//
@property(nonatomic,copy)NSString *xqXianCode;//
@property(nonatomic,copy)NSString *xqBaoLiuJia;//保留价
@property(nonatomic,copy)NSString *xqPingGuJia;//评估价
@property(nonatomic,copy)NSString * xqBiaoDiID;
@property(nonatomic,strong)NSMutableArray * xqImage;//图片
-(id)initWithBiaoDiXiangQingDic:(NSDictionary*)dic;
@end
