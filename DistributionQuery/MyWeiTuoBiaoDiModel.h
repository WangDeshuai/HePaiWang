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
@end
