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

-(id)initWithChuJiaJiluDic:(NSDictionary*)dic;
@end
