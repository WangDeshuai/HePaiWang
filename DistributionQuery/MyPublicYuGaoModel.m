//
//  MyPublicYuGaoModel.m
//  DistributionQuery
//
//  Created by Macx on 17/3/2.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MyPublicYuGaoModel.h"

@implementation MyPublicYuGaoModel
-(id)initWithMyPublicDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        //信息ID，还有一个user_id没有写就是是谁发布的
        _messageID=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
        _headImage=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"trailer_img"]]];
         _titleName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"trailer_title"]]];
         _timeName=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"add_time"]]];
        _phone=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"trailer_connect_tel"]]];
        _yuGaoPeople=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"asset_disposal_person"]]];
        _yuGaoContent=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"trailer_content"]]];
        //预告图片会换成数组
        _yuGaoImage=[ToolClass isString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"trailer_img"]]];
        _imageArr=[NSMutableArray arrayWithArray:[dic objectForKey:@"imgList"]];
    }
    
    return self;
}
@end
