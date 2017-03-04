//
//  Engine.m
//  DistributionQuery
//
//  Created by Macx on 16/10/8.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "Engine.h"
@implementation Engine

#pragma mark --0上传单张图片获取base64编码
+(void)upDataBaseWithImageBaseImage:(UIImage*)image success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@upload/app_uploadImgBase64.action",SER_VICE];
    if (image==nil) {
        [LCProgressHUD showMessage:@"0图片为空"];
        return;
    }
    //获得的data
    NSData *imageData=UIImageJPEGRepresentation(image, 0);
    //base编码后
    NSString * endStr =[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary * dicc =[NSMutableDictionary new];
    [dicc setObject:endStr forKey:@"imgCode"];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dicc success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"0上传单张图片获取base64编码%@",str);
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"0上传单张图片获取base64编码%@",error);
    }];

}
#pragma mark --1获取短信验证码
+(void)getMessageCodePhone:(NSString*)phone success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
   
    NSString * urlStr =[NSString stringWithFormat:@"%@sms/pushVerificationCode.action",SER_VICE];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:phone forKey:@"telNum"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"1获取短信验证码%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"1获取短信验证码%@",error);
        aError(error);
        
    }];
    

    
}



#pragma mark --2注册
+(void)registPhone:(NSString*)phone Password:(NSString*)psw password2:(NSString*)psw2 Code:(NSString*)code success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@regist/app_regist.action",SER_VICE];

    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
     [dic setObject:phone forKey:@"regist_tel"];
     [dic setObject:psw forKey:@"password"];
     [dic setObject:psw2 forKey:@"password2"];
     [dic setObject:code forKey:@"randomStr"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"2注册%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"2注册%@",error);
        aError(error);
       
    }];
    
    
}

#pragma mark --3登录
+(void)loginAccount:(NSString*)phone Password:(NSString*)psw success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@login/app_login.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:phone forKey:@"account"];
    [dic setObject:psw forKey:@"password"];
   
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"3登录%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"3登录%@",error);
        aError(error);
        
    }];
    
}
#pragma mark --4我的个人信息
+(void)myMessagesuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@user/app_qryUserInfo.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
    if (str==nil) {
        [LCProgressHUD showMessage:@"4我的个人信息无token"];
        return;
    }else{
        [dic setObject:str forKey:@"user_id"];
    }
    
    
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"4我的个人信息%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"4我的个人信息%@",error);
        aError(error);
        
    }];
}

#pragma mark --5首页成交案例
+(void)firstChengJiaoAnLiPageindex:(NSString*)page success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qrySuccessfulTransactionTargetList.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:page forKey:@"pageIndex"];
    [dic setObject:@"10" forKey:@"pageSize"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"5首页成交案例%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"5首页成交案例%@",error);
        aError(error);
        
    }];

}
#pragma mark--7个人中心消息列表
+(void)CenterMessageListViewStype:(NSString*)stype Pageindex:(NSString*)page success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@user/app_qrySystemMessageListInUC.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
    if (str==nil) {
        [LCProgressHUD showMessage:@"7个人中心消息列表无token"];
        return;
    }else{
        [dic setObject:str forKey:@"user_id"];
        [dic setObject:stype forKey:@"read_status"];
        [dic setObject:page forKey:@"pageIndex"];
        [dic setObject:@"10" forKey:@"pageSize"];
    }
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"7个人中心消息列表%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"7个人中心消息列表%@",error);
        aError(error);
        
    }];
}
#pragma mark --8个人中心发布预告
+(void)pubulicYuGaoTitle:(NSString*)title People:(NSString*)people Content:(NSString*)content Pic:(UIImage*)picImage success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
    if (str==nil) {
        [LCProgressHUD showMessage:@"8个人中心发布预告无token"];
        return;
    }
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_publishTrailerInUc.action",SER_VICE];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:str forKey:@"user_id"];
     [dic setObject:title forKey:@"trailer_title"];
     [dic setObject:people forKey:@"asset_disposal_person"];
     [dic setObject:content forKey:@"trailer_content"];
    
    [manager  POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {//
        NSString *imagetype=@"png";
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        if (picImage!=nil) {
            NSData *imageData=UIImageJPEGRepresentation(picImage, 0);
            [formData appendPartWithFileData:imageData name:@"trailer_img" fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
        }else
        {
            [LCProgressHUD showMessage:@"图片是空的"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"8个人中心发布预告%@",str);
        aSuccess(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"8个人中心发布预告%@",error);
    }];
    
}
#pragma mark --9获取所有省份
+(void)huoQuAllShengFensuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@admDivison/qryAllProvince.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"9获取所有省份%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"9获取所有省份%@",error);
        aError(error);
        
    }];

}
#pragma mark --12根据省份获取城市
+(void)huoQuWithShengGetCityShengCode:(NSString*)provicecode success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@admDivison/qryCitiesByProvinceCode.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:provicecode forKey:@"provinceCode"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"12根据省份获取城市%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"12根据省份获取城市%@",error);
        aError(error);
        
    }];
    
}

#pragma mark --13根据城市获取县
+(void)huoQuXianWithCityCode:(NSString*)citycode success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@admDivison/qryDistrictsByCityCode.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:citycode forKey:@"cityCode"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"13根据城市获取县%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"13根据城市获取县%@",error);
        aError(error);
        
    }];
}



#pragma mark --14个人中心_我发布的预告
+(void)myCenterYuGaoPageIndex:(NSString*)page  success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryMyPublishedTrailerInUc.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
   
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
    if (str==nil) {
        [LCProgressHUD showMessage:@"14个人中心_我发布的预告无token"];
        return;
    }else{
        [dic setObject:str forKey:@"user_id"];
        [dic setObject:@"10" forKey:@"pageSize"];
        [dic setObject:page forKey:@"pageIndex"];
    }
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"14个人中心_我发布的预告%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"14个人中心_我发布的预告%@",error);
        aError(error);
        
    }];
    
}
#pragma mark --15查询所有标的类型
+(void)biaoDiStypesuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@category/qryTargetTypeCategory.action",SER_VICE];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"15查询所有标的类型%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"15查询所有标的类型%@",error);
        aError(error);
        
    }];
}
#pragma mark --16修改个人信息
+(void)modificationMyMessageKeyDicStr:(NSString*)dicStr success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@user/app_updateUserInfo.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
    if (str==nil) {
        [LCProgressHUD showMessage:@"16修改个人信息无token"];
        return;
    }else{
        [dic setObject:str forKey:@"user_id"];
        [dic setObject:dicStr forKey:@"updateInfoArr"];
    }
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"16修改个人信息%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"16修改个人信息%@",error);
        aError(error);
        
    }];
    

}

@end
