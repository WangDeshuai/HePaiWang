//
//  ChengJiaoAnLiModel.h
//  DistributionQuery
//
//  Created by Macx on 17/2/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>
//成交案例Model
@interface ChengJiaoAnLiModel : NSObject
@property(nonatomic,copy)NSString * messageID;//信息ID
@property(nonatomic,copy)NSString * biaoDiID;//标的ID
@property(nonatomic,copy)NSString * paiMaiHuiID;//拍卖会ID
@property(nonatomic,copy)NSString * nameBiaoDi;//标的名字
@property(nonatomic,copy)NSString * priceBiaoDi;//标的价格
@property(nonatomic,copy)NSString * diquBiaoDi;//地区
@property(nonatomic,copy)NSString * strTime;//开始拍卖时间
@property(nonatomic,copy)NSString * headImage;//标的图片
@property(nonatomic,copy)NSString * chengJiaoStye;//成交状态
-(id)initWithChengJiaoAnliDic:(NSDictionary*)dic;
@end
