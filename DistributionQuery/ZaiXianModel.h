//
//  ZaiXianModel.h
//  DistributionQuery
//
//  Created by Macx on 17/3/29.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZaiXianModel : NSObject
//出价记录
@property(nonatomic,copy)NSString *moneyName;
@property(nonatomic,copy)NSString *jingPaiNum;
@property(nonatomic,copy)NSString *timeName;
//竞买留言专区
@property(nonatomic,copy)NSString * faYanPeopleID;//发言ID
@property(nonatomic,copy)NSString * faYanPeopleName;//发言名称
@property(nonatomic,copy)NSString * faYanPeopleTime;//发言时间
@property(nonatomic,copy)NSString * faYanPeopleContent;//发言内容

//出价记录
-(id)initWithChuJiaJiluDic:(NSDictionary*)dic;
//竞买留言专区
-(id)initWithLiuYanZhuanQu:(NSDictionary*)dic;
@end

