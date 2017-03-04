//
//  MyPublicYuGaoModel.h
//  DistributionQuery
//
//  Created by Macx on 17/3/2.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPublicYuGaoModel : NSObject
@property(nonatomic,copy)NSString * messageID;
@property(nonatomic,copy)NSString * headImage;
@property(nonatomic,copy)NSString * titleName;
@property(nonatomic,copy)NSString * timeName;
@property(nonatomic,copy)NSString * yuGaoPeople;
@property(nonatomic,copy)NSString * yuGaoContent;
@property(nonatomic,copy)NSString * yuGaoImage;//预告详情图片
-(id)initWithMyPublicDic:(NSDictionary*)dic;
@end
