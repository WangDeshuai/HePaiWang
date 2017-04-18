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
@property(nonatomic,copy)NSString * messageID;
@property(nonatomic,copy)NSString * headImage;
@property(nonatomic,copy)NSString * titleName;
@property(nonatomic,copy)NSString * priceName;
@property(nonatomic,copy)NSString * diQu;
@property(nonatomic,copy)NSString * timeName;
-(id)initWithMyWeiTuoDic:(NSDictionary*)dic;
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
@end
