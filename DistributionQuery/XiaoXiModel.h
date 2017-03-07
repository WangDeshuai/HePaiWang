//
//  XiaoXiModel.h
//  DistributionQuery
//
//  Created by Macx on 17/2/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiaoXiModel : NSObject
//消息列表 账户信息都可以用这个
@property(nonatomic,copy)NSString *messageID;
@property(nonatomic,copy)NSString * contentStr;
@property(nonatomic,copy)NSString *sendTime;
-(id)initWithXiaoXiMessageDic:(NSDictionary*)dic;
@end
