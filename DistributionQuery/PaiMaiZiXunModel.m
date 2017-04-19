//
//  PaiMaiZiXunModel.m
//  DistributionQuery
//
//  Created by Macx on 17/4/19.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "PaiMaiZiXunModel.h"

@implementation PaiMaiZiXunModel
-(id)initWithPaiMaiZiXunDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        _titlelabel=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"news_title"]]];
        _zixunID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
        _content=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"news_content"]]];
        _fabuTime=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time"]]];
    }
    
    return self;
}
@end
