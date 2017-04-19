//
//  PaiMaiZiXunModel.h
//  DistributionQuery
//
//  Created by Macx on 17/4/19.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaiMaiZiXunModel : NSObject
@property(nonatomic,copy)NSString * titlelabel;
@property(nonatomic,copy)NSString * zixunID;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * fabuTime;
-(id)initWithPaiMaiZiXunDic:(NSDictionary*)dic;
@end
