//
//  XiaoXiModel.m
//  DistributionQuery
//
//  Created by Macx on 17/2/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "XiaoXiModel.h"

@implementation XiaoXiModel
-(id)initWithXiaoXiMessageDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        _messageID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
        _contentStr=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"message_content"]]];
        _sendTime=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"send_time"]]];
    }
    
    return self;
}
@end
