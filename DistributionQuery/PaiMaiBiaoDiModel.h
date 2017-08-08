//
//  PaiMaiBiaoDiModel.h
//  DistributionQuery
//
//  Created by Macx on 17/3/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaiMaiBiaoDiModel : NSObject
//拍卖标的
@property(nonatomic,copy)NSString *leftImage;
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *diqu;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString * paiMaiID;
@property(nonatomic,copy)NSString * biaoDiID;
@property(nonatomic,copy)NSString * dataSoure;
-(id)initWithBiaoDiDic:(NSDictionary*)dic;
@end
