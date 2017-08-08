//
//  Engine.m
//  DistributionQuery
//
//  Created by Macx on 16/10/8.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "Engine.h"
#import "Singleton.h"
//#import "AFNetworking.h"
//#define SER_VICE @"http://119.29.83.154:8080/HePai/"
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
    [dicc setObject:@"ios" forKey:@"osType"];
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
    NSLog(@"手机号%@",phone);
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",phone]] forKey:@"telNum"];
    [dic setObject:@"ios" forKey:@"osType"];
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
     [dic setObject:@"ios" forKey:@"osType"];
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
    [dic setObject:@"ios" forKey:@"osType"];
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
        [dic setObject:@"ios" forKey:@"osType"];
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
     [dic setObject:@"ios" forKey:@"osType"];
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
#pragma mark --6忘记密码
+(void)forgetPassWordPhone:(NSString*)phone Code:(NSString*)code NewPsw:(NSString*)newpsw AgeinPsw:(NSString*)ageinpsw success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@regist/app_resetPassword.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    
        [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",phone]] forKey:@"regist_tel"];
        [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",code]] forKey:@"randomStr"];
        [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",newpsw]] forKey:@"password"];
        [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",ageinpsw]] forKey:@"password2"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"6忘记密码%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"6忘记密码%@",error);
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
         [dic setObject:@"ios" forKey:@"osType"];
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
+(void)pubulicYuGaoTitle:(NSString*)title People:(NSString*)people Content:(NSString*)content Pic:(NSMutableArray*)imageArr Phone:(NSString*)phone  success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
   
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_publishTrailerInUc.action",SER_VICE];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
     [dic setObject:@"ios" forKey:@"osType"];
   
     [dic setObject:title forKey:@"trailer_title"];
     [dic setObject:people forKey:@"asset_disposal_person"];
     [dic setObject:content forKey:@"trailer_content"];
     [dic setObject:phone forKey:@"trailer_connect_tel"];
    if (str) {
          [dic setObject:str forKey:@"user_id"];
    }
    
    [manager  POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {//
        
        
        //            上传文件参数
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < imageArr.count; i++) {
            UIImage * image= imageArr[i];
            NSString *imagetype=@"jpg";
            NSData *data = UIImageJPEGRepresentation(image, 0);
            NSString *IMAGE=[NSString stringWithFormat:@"trailer_img%d",i];
            [formData appendPartWithFileData:data name:IMAGE fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
            
        }
//        NSString *imagetype=@"png";
//        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
//        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
//        if (picImage!=nil) {
//            NSData *imageData=UIImageJPEGRepresentation(picImage, 0);
//            [formData appendPartWithFileData:imageData name:@"trailer_img" fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
//        }else
//        {
//            [LCProgressHUD showMessage:@"图片是空的"];
//        }
        
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
     [dic setObject:@"ios" forKey:@"osType"];
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
     [dic setObject:@"ios" forKey:@"osType"];
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
     [dic setObject:@"ios" forKey:@"osType"];
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
         [dic setObject:@"ios" forKey:@"osType"];
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
    NSMutableDictionary * dic =[NSMutableDictionary new];
     [dic setObject:@"ios" forKey:@"osType"];
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
     [dic setObject:@"ios" forKey:@"osType"];
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
#pragma mark --17个人中心我已买到的标的
+(void)myCenterMyBuyBiaoDiStype:(NSString*)stype Page:(NSString*)page success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryMyPurchasedTargetInUC.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
     [dic setObject:@"ios" forKey:@"osType"];
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
    if (str==nil) {
        [LCProgressHUD showMessage:@"17个人中心我已买到的标的无token"];
        return;
    }else{
        [dic setObject:str forKey:@"user_id"];
        [dic setObject:stype forKey:@"delivery_status"];
        [dic setObject:page forKey:@"pageIndex"];
    }
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"17个人中心我已买到的标的%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"17个人中心我已买到的标的%@",error);
        aError(error);
        
    }];
}
#pragma mark --18获取实名认证资料
+(void)getShiMingMessagesuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@user/app_qryUserAuthenticationInfo.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:@"ios" forKey:@"osType"];
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
    if (str==nil) {
        [LCProgressHUD showMessage:@"18获取实名认证资料无token"];
        return;
    }else{
        [dic setObject:str forKey:@"user_id"];
       
    }
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"18获取实名认证资料%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"18获取实名认证资料%@",error);
        aError(error);
        
    }];

}
#pragma mark --20修改实名认证
+(void)xiuGaiShiMingRenZhengMessageJsonStr:(NSString*)dicStr success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@user/app_updateUserAuthenticationInfo.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
   
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
    if (str==nil) {
        [LCProgressHUD showMessage:@"20修改实名认证无token"];
        return;
    }else{
        [dic setObject:@"ios" forKey:@"osType"];
        [dic setObject:str forKey:@"user_id"];
        [dic setObject:dicStr forKey:@"updateInfoArr"];
        
    }
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"20修改实名认证%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"20修改实名认证%@",error);
        aError(error);
        
    }];

}
#pragma mark --21我发布的预告删除
+(void)myPublicDeleteTrailerID:(NSString*)idd success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_deleteMyTrailer.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
    if (str==nil) {
        [LCProgressHUD showMessage:@"21我发布的预告删除token"];
        return;
    }else{
        [dic setObject:@"ios" forKey:@"osType"];
        [dic setObject:str forKey:@"user_id"];
        [dic setObject:idd forKey:@"trailer_id"];
        
    }
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"21我发布的预告删除%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"21我发布的预告删除%@",error);
        [LCProgressHUD showMessage:@"21我发布的预告删除"];
        aError(error);
        
    }];
}
#pragma mark --22个人中心账户消息列表
+(void)myCenterZhaoHuListViewStyle:(NSString*)style Page:(NSString*)page success:(SuccessBlock)aSuccess error:(ErrorBlock)aError
{
    NSString * urlStr =[NSString stringWithFormat:@"%@user/app_qryAccountMessageListInUC.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
    if (str==nil) {
        [LCProgressHUD showMessage:@"22个人中心账户消息列表无token"];
        return;
    }else{
        [dic setObject:str forKey:@"user_id"];
        [dic setObject:style forKey:@"read_status"];
        [dic setObject:page forKey:@"pageIndex"];
        [dic setObject:@"10" forKey:@"pageSize"];
        [dic setObject:@"ios" forKey:@"osType"];
    }
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"22个人中心账户消息列表%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"22个人中心账户消息列表%@",error);
        aError(error);
        
    }];

}
#pragma mark --23消息列表详/账户列表情页
+(void)messageViewMessageID:(NSString*)messageID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@user/app_qryMessageDetail.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * str =[NSUSE_DEFO objectForKey:@"token"];
    if (str==nil) {
        [LCProgressHUD showMessage:@"23消息列表详/账户列表情页无token"];
        return;
    }else{
        [dic setObject:str forKey:@"user_id"];
        [dic setObject:messageID forKey:@"message_id"];
        [dic setObject:@"ios" forKey:@"osType"];
    }
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"23消息列表详/账户列表情页%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"23消息列表详/账户列表情页%@",error);
        aError(error);
        
    }];
}
#pragma mark --24拍卖标的列表
+(void)firstPaiMaiBiaoDiViewSearchStr:(NSString*)searStr BiaoDiStyle:(NSString*)leiXing ProvCode:(NSString*)procode CityCode:(NSString*)citycode Staus:(NSString*)styleStr PageSize:(NSString*)pagesize PageIndex:(NSString*)pageindex success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryCompeteTargetList.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
  
        [dic setObject:@"ios" forKey:@"osType"];
        [dic setObject:searStr forKey:@"search_content"];
        [dic setObject:leiXing forKey:@"target_type"];
        [dic setObject:procode forKey:@"prov_code"];
        [dic setObject:citycode forKey:@"city_code"];
        [dic setObject:styleStr forKey:@"status"];
        [dic setObject:pageindex forKey:@"pageIndex"];
        [dic setObject:pagesize forKey:@"pageSize"];
        
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"24拍卖标的列表%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"24拍卖标的列表%@",error);
        aError(error);
        
    }];
}
#pragma mark --25查询拍卖公告列表
+(void)upDataPaiMaiPublicViewSearchStr:(NSString*)searStr  BiaoDiLeiXing:(NSString*)baiDiStyle ProvCode:(NSString*)shengcode CityCode:(NSString*)citycode BeginTime:(NSString*)time Page:(NSString*)page PageSize:(NSString*)pagesize success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    [ToolClass getUUIDStr];
    NSString * urlStr =[NSString stringWithFormat:@"%@auction/app_qryAuctionList.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * uuid =[NSUSE_DEFO objectForKey:@"UUID"];
    if (uuid==nil) {
        [LCProgressHUD showMessage:@"无法获取当前设备UUID"];
        return;
    }
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:uuid forKey:@"unique_id"];
    [dic setObject:searStr forKey:@"search_content"];
    [dic setObject:baiDiStyle forKey:@"target_type"];
    [dic setObject:shengcode forKey:@"prov_code"];
    [dic setObject:citycode forKey:@"city_code"];
    [dic setObject:time forKey:@"begin_time"];
    [dic setObject:page forKey:@"pageIndex"];
    [dic setObject:pagesize forKey:@"pageSize"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"25查询拍卖公告列表%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"25查询拍卖公告列表%@",error);
        aError(error);
        
    }];
    
}
#pragma mark --26公告详请页
+(void)PaiMaiPublicMessageID:(NSString*)messageID DataSoure:(NSString*)datasoure success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@auction/app_qryAuctionDetailInfo.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [ToolClass getUUIDStr];
    NSString * uuid =[NSUSE_DEFO objectForKey:@"UUID"];
    if (uuid==nil) {
        [LCProgressHUD showMessage:@"无法获取当前设备UUID"];
        return;
    }
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:uuid forKey:@"unique_id"];
    [dic setObject:messageID forKey:@"auction_id"];
    [dic setObject:datasoure forKey:@"dataSource"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"26公告详请页%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"26公告详请页%@",error);
        aError(error);
        
    }];
}


#pragma mark --27未登录状态下委托发布
+(void)loginIsNoPublicPeople:(NSString*)people Phone:(NSString*)phone PhoneCode:(NSString*)yanZhengMa BiaoDiName:(NSString*)bdname BiaoDiMiaoShu:(NSString*)biaodims XiaCiName:(NSString*)xcname ShengCode:(NSString*)shengcode CityCode:(NSString*)citycode XianCode:(NSString*)xiancode ImageArray:(NSMutableArray*)imageArr success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlstr =[NSString stringWithFormat:@"%@entrust/app_publishEntrustTargetNotLogin.action",SER_VICE];
    NSMutableDictionary * dicc =[NSMutableDictionary new];
      [dicc setObject:@"ios" forKey:@"osType"];
    
    
    [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",people]] forKey:@"liaisons_name"];
    [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",phone]] forKey:@"regist_tel"];//phone
    [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",yanZhengMa]] forKey:@"randomStr"];//yanZhengMa
    [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",bdname]] forKey:@"target_name"];//标的名称bdname
    [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaodims]] forKey:@"target_description"];//描述biaodims
    [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",xcname]] forKey:@"target_defect_declaration"];//瑕疵xcname
    [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",shengcode]] forKey:@"target_provcode"];//省codeshengcode
    [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",citycode]] forKey:@"target_citycode"];//市code  citycode
    [dicc setObject:[NSString stringWithFormat:@"%@",xiancode] forKey:@"target_districtcode"];//县coed 
    [manager POST:urlstr parameters:dicc constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        if (imageArr.count==0) {
        }else{
            for (int i = 0; i < imageArr.count; i++) {
                UIImage * image= imageArr[i];
                NSString *imagetype=@"jpg";
                NSData *data = UIImageJPEGRepresentation(image, 0);
                NSString *IMAGE=[NSString stringWithFormat:@"target_img%d",i];
                [formData appendPartWithFileData:data name:IMAGE fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * diccc = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"27未登录状态下委托发布%@",diccc);
       
        
       
        
        aSuccess(diccc);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"27未登录状态下委托发布%@",error);
        aError(error);
    }];
}





#pragma mark --28已登录状态委托发布(文件形式上传图片)
+(void)loginIsYesPublicPeopleName:(NSString*)people PhoneNum:(NSString*)phone BiaoDiName:(NSString*)biaodiname MiaoShu:(NSString*)miaoshu XiaCi:(NSString*)xiaci ShengCode:(NSString*)scode CityCode:(NSString*)ccode XianCode:(NSString*)xcode BaoLiuPrice:(NSString*)blprice PingGuPrice:(NSString*)pgprice imageArr:(NSMutableArray*)imageArr success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSDictionary * dicInfo =[ToolClass duquPlistWenJianPlistName:@"baseInfo"];
     NSString * token =[NSUSE_DEFO objectForKey:@"token"];
     NSString * phoneregi =[dicInfo objectForKey:@"regist_tel"];
    if (token==nil || dicInfo==nil) {
        [LCProgressHUD showMessage:@"28未找到基本信息"];
        return;
    }
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * urlstr =[NSString stringWithFormat:@"%@entrust/app_publishEntrustTargetInLogin.action",SER_VICE];
    NSMutableDictionary * dicc =[NSMutableDictionary new];
//
    ;
    [dicc setObject:@"ios" forKey:@"osType"];
     [dicc setObject:token forKey:@"user_id"];
    NSString * str =[ToolClass isString:[NSString stringWithFormat:@"%@",phoneregi]];
    NSString * str2 =[ToolClass isString:[NSString stringWithFormat:@"%@",people]];
    if ([str isEqualToString:@""]) {
        [dicc setObject:[ToolClass isString:[NSUSE_DEFO objectForKey:@"phone"]] forKey:@"regist_tel"];
    }else{
         [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",phoneregi]] forKey:@"regist_tel"];
    }
   
    if ([str2 isEqualToString:@""]) {
        [dicc setObject:[ToolClass isString:[NSUSE_DEFO objectForKey:@"people"]] forKey:@"liaisons_name"];
    }else{
        [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",people]] forKey:@"liaisons_name"];
    }
    
    
     [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaodiname]] forKey:@"target_name"];//标的名称
     [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",miaoshu]] forKey:@"target_description"];//描述
     [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",xiaci]] forKey:@"target_defect_declaration"];//瑕疵
     [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",scode]] forKey:@"target_provcode"];//省code
     [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",ccode]] forKey:@"target_citycode"];//市code
     [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",xcode]] forKey:@"target_districtcode"];//县coed
     [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",blprice]] forKey:@"target_reserve_price"];//保留价
     [dicc setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",pgprice]] forKey:@"target_estimated_price"];//评估价
    [manager POST:urlstr parameters:dicc constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        if (imageArr.count==0) {
        }else{
            for (int i = 0; i < imageArr.count; i++) {
                UIImage * image= imageArr[i];
                NSString *imagetype=@"jpg";
                NSData *data = UIImageJPEGRepresentation(image, 0);
                NSString *IMAGE=[NSString stringWithFormat:@"target_img%d",i];
                [formData appendPartWithFileData:data name:IMAGE fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * diccc = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"28已登录状态委托发布%@",diccc);
         aSuccess(diccc);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"28已登录状态委托发布%@",error);
        aError(error);
    }];
}

#pragma mark --29个人中心_我参加的拍卖会
+(void)myCenterMyCanJiaPaiMaiHuiBiaoDiType:(NSString*)leiXing Page:(NSString*)page ShengCode:(NSString*)scode CityCode:(NSString*)ccode BeginTime:(NSString*)timeStr success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@user/app_qryMyJoinedAuctionInUC.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [ToolClass getUUIDStr];
    NSString * uuid =[NSUSE_DEFO objectForKey:@"UUID"];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (uuid==nil || token==nil) {
        [LCProgressHUD showMessage:@"29个人中心_我参加的拍卖会无token"];
        return;
    }
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:uuid forKey:@"unique_id"];
    [dic setObject:token forKey:@"user_id"];
    [dic setObject:leiXing forKey:@"target_type"];
    [dic setObject:scode forKey:@"prov_code"];
    [dic setObject:ccode forKey:@"city_code"];
    [dic setObject:timeStr forKey:@"begin_time"];
    [dic setObject:page forKey:@"pageIndex"];
    [dic setObject:@"10" forKey:@"pageSize"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"29个人中心_我参加的拍卖会%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"29个人中心_我参加的拍卖会%@",error);
        aError(error);
        
    }];
}
#pragma mark --30报名参加拍卖会
+(void)BaoMingCanJianPaiMaiID:(NSString*)paiMaiID BiaoDiID:(NSString*)biaoid Phone:(NSString*)phone PeopleName:(NSString*)people MessageName:(NSString*)message success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@auction/app_signUpForAuction.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    [dic setObject:@"ios" forKey:@"osType"];
   
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",paiMaiID]] forKey:@"auction_id"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaoid]] forKey:@"target_id"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",phone]] forKey:@"regist_tel"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",people]] forKey:@"liaisons_name"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",message]] forKey:@"message"];
    if (token) {
     [dic setObject:token forKey:@"user_id"];
    }
    
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"30报名参加拍卖会%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"30报名参加拍卖会%@",error);
        aError(error);
        
    }];
    
}
#pragma mark --31首页轮播图
+(void)huoQuFirstLunBoImageArrsuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@banner/app_getBanners.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:@"ios" forKey:@"osType"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"31首页轮播图%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"31首页轮播图%@",error);
        aError(error);
        
    }];
    
}
#pragma mark --32个人中心_我委托的标的列表
+(void)myCenterWeiTuoPage:(NSString*)page Status:(NSString*)style success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryMyEntrustTargetListInUC.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"32个人中心_我委托的标的列表无token"];
        return;
    }
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:token forKey:@"user_id"];
    [dic setObject:style forKey:@"status"];
    [dic setObject:page forKey:@"pageIndex"];
    [dic setObject:@"10" forKey:@"pageSize"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"32个人中心_我委托的标的列表%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"32个人中心_我委托的标的列表%@",error);
        aError(error);
        
    }];
}
#pragma mark --33拍卖标的详情页所需数据
+(void)paiMaiLieBiaoXiangQingPaiMaiID:(NSString*)paimaiID BiaoDiID:(NSString*)biaodiID DataSoure:(NSString*)datasoure  success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_getInfoInTargetCompeteDetailPage.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token) {
         [dic setObject:token forKey:@"user_id"];
    }
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",paimaiID]] forKey:@"auction_id"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",datasoure]] forKey:@"dataSource"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaodiID]] forKey:@"target_id"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"33拍卖标的详情页所需数据%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"33拍卖标的详情页所需数据%@",error);
        aError(error);
        
    }];
    
}

#pragma mark --34个人中心我已买到的标的(17接口详情页)
+(void)mycenterMyBuyBiaoDiXiangQingBiaoDiID:(NSString*)biaoDiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryMyPurchasedTargetDetail.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"34个人中心已买到的标的详情页我token"];
        return;
    }
    [dic setObject:token forKey:@"user_id"];
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaoDiID]] forKey:@"target_id"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"34个人中心我已买到的标的(17接口详情页)%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"34个人中心我已买到的标的(17接口详情页)%@",error);
        aError(error);
        
    }];
}
#pragma mark --35个人中心我已买到的标的(交易明细)
+(void)jiaoYiMingXiBiaoDiID:(NSString*)biaoID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryMyPurchasedTargetTransactionDetail.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"35个人中心我已买到的标的(交易明细)token"];
        return;
    }
    [dic setObject:token forKey:@"user_id"];
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaoID]] forKey:@"target_id"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"35个人中心我已买到的标的(交易明细)%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"35个人中心我已买到的标的(交易明细)%@",error);
        aError(error);
        
    }];
    
    
}
#pragma mark --36个人中心我已买到的标的(交割管理)
+(void)jiaoGeGuanLiBiaoDiID:(NSString*)biaoID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryMyPurchasedTargetDeliveryDetail.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"36个人中心我已买到的标的(交割管理)token"];
        return;
    }
    [dic setObject:token forKey:@"user_id"];
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaoID]] forKey:@"target_id"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"36个人中心我已买到的标的(交割管理)%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"36个人中心我已买到的标的(交割管理)%@",error);
        aError(error);
        
    }];
    
}

#pragma mark --37个人中心->我已买到的标的->标的详情页_交割管理页面_查看拍卖成交确认书
+(void)chaKanQueRenShuBiaoDiID:(NSString*)biaoDi success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryMyPurchasedTargetTransactionBookInfo.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"37token"];
        return;
    }
    [dic setObject:token forKey:@"user_id"];
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaoDi]] forKey:@"target_id"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"37个人中心->我已买到的标的->标的详情页_交割管理页面_查看拍卖成交确认书%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"37错误%@",error);
        aError(error);
        
    }];
    
}
#pragma mark --38个人中心->我已买到的标的->标的详情页_交割管理页面_确认收货
+(void)myCenterYiMaiDaoSureShouHuoBiaoDiID:(NSString*)biaoDi  success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_myPurchasedTargetConfirmReceipt.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"38token"];
        return;
    }
    [dic setObject:token forKey:@"user_id"];
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaoDi]] forKey:@"target_id"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"38个人中心->我已买到的标的->标的详情页_交割管理页面_确认收货%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"38错误%@",error);
        aError(error);
        
    }];
    
}

#pragma mark --39我委托的标的->标的详情页数据
+(void)myWeiTuoXiangQingBiaoDiID:(NSString*)biaoDiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryMyEntrustTargetDetail.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"39我委托的标的->标的详情页数据token"];
        return;
    }
    [dic setObject:token forKey:@"user_id"];
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaoDiID]] forKey:@"target_id"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"39我委托的标的->标的详情页数据%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"39我委托的标的->标的详情页数据%@",error);
        aError(error);
        
    }];
    
    
}


#pragma mark --40我委托的标的->标的详情页_交易明细页所需数据
+(void)myWeiTuoJiaoYiXiangXiID:(NSString*)biaodiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryMyEntrustTargetTransactionDetail.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"40我委托的标的token"];
        return;
    }
    [dic setObject:token forKey:@"user_id"];
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaodiID]] forKey:@"target_id"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"40我委托的标的%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"40我委托的标的%@",error);
        aError(error);
        
    }];
    
}
#pragma mark --41. 个人中心->我委托的标的->标的详情页_交割管理页面所需数据
+(void)myWeiTuoJiaoGeGuanLiID:(NSString*)biaodiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryMyEntrustTargetDeliveryDetail.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"41接口token"];
        return;
    }
    [dic setObject:token forKey:@"user_id"];
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaodiID]] forKey:@"target_id"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"41接口%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"41接口%@",error);
        aError(error);
        
    }];
    
}
#pragma mark --42 个人中心->我委托的标的 _获取委托拍卖合同信息
+(void)myWeiTuoHtmlBtnBiaoDiID:(NSString*)biaodiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_qryMyEntrustTargetContractInfo.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
//    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
//    if (token==nil) {
//        [LCProgressHUD showMessage:@"42接口token"];
//        return;
//    }
//    [dic setObject:token forKey:@"user_id"];
    [dic setObject:@"ios" forKey:@"osType"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaodiID]] forKey:@"target_id"];
    
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"42接口%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"42接口%@",error);
        aError(error);
        
    }];
    
}
#pragma mark --43. 拍卖资讯列表
+(void)paiMaiZiXunListViewPage:(NSString*)page success:(SuccessBlock)aSuccess error:(ErrorBlock)aError
{
    NSString * urlStr =[NSString stringWithFormat:@"%@news/app_qryAuctionNewsList.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:page forKey:@"pageIndex"];
     [dic setObject:@"10" forKey:@"pageSize"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"43. 拍卖资讯列表%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"42接口%@",error);
        aError(error);
        
    }];

}
#pragma mark --44拍卖资讯详情
+(void)paiMaiZiXunXiangQingMessageID:(NSString*)idd success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@news/app_qryAuctionNewsDetail.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:idd forKey:@"id"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"44拍卖资讯详情%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"44拍卖资讯详情%@",error);
        aError(error);
        
    }];
    
}


#pragma mark --45 获取用户的实名认证
+(void)houQuShiMingRenZhengUserIDsuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@user/app_getUserAuthenticationStatus.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"45接口token"];
        return;
    }
    [dic setObject:token forKey:@"user_id"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"45 获取用户的实名认证%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"45 获取用户的实名认证%@",error);
        aError(error);
        
    }];
}
#pragma mark --46获取竞买协议界面
+(void)JingMaiXieYiContentPaiMaiHuiID:(NSString*)paiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError
{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@auction/app_getAuctionCompeteAgreement.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
   
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",paiID]] forKey:@"auction_id"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"46获取竞买协议界面%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"46获取竞买协议界面%@",error);
        aError(error);
        
    }];
}
#pragma mark --47.判断是否可以报名
+(void)PanDuanBaoMingPaiMaiHuiID:(NSString*)paiMaiID BiaoDiID:(NSString*)biaoDiID DataSoure:(NSString*)datasoure success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"48.上传签名图片"];
        return;
    }
    NSString * urlStr =[NSString stringWithFormat:@"%@auction/app_checkEnableForSignUp.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",datasoure]] forKey:@"dataSource"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",paiMaiID]] forKey:@"auction_id"];
    [dic setObject:token forKey:@"user_id"];
     [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaoDiID]] forKey:@"target_id"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"47.判断是否可以报名%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"47.判断是否可以报名%@",error);
        aError(error);
        
    }];
    
}
#pragma mark --48.上传签名图片
+(void)headImage:(UIImage*)image PaiMaiHuiID:(NSString*)paiMaiID BiaoDiID:(NSString*)biaodiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@auction/app_uploadAuctionCompeteAgreementSignPicture.action",SER_VICE];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"48.上传签名图片"];
        return;
    }
    
    
    NSData *data = UIImageJPEGRepresentation(image, 0);
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",paiMaiID]] forKey:@"auction_id"];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaodiID]] forKey:@"target_id"];
    [dic setObject:token forKey:@"user_id"];
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        NSString *imagetype=@"jpg";
        [formData appendPartWithFileData:data name:@"sign_picture" fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"48.上传签名图片成功%@",str);
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败%@>>>",error);
        aError(error);
    }];
    
}
#pragma mark --49.我委托的标的修改
+(void)XiuGaiBiaoDiXiangQingBiaoDiID:(NSString*)bdID LianXiRen:(NSString*)people Phone:(NSString*)phone BiaoDiName:(NSString*)name MiaoShu:(NSString*)miaoshu XiaCi:(NSString*)xiaci ShengCode:(NSString*)sheng ShiCode:(NSString*)shicode XianCode:(NSString*)xiancode BaoLiuJia:(NSString*)blj PingGuJia:(NSString*)pgj ImageArray:(NSMutableArray*)imageArr success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_updateMyEntrustTarget.action",SER_VICE];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:bdID forKey:@"id"];
    [dic setObject:people forKey:@"target_liaisons_name"];
    [dic setObject:phone forKey:@"target_connect_tel"];
    [dic setObject:name forKey:@"target_name"];
    [dic setObject:miaoshu forKey:@"target_description"];
    [dic setObject:xiaci forKey:@"target_defect_declaration"];
     [dic setObject:sheng forKey:@"target_provcode"];
     [dic setObject:shicode forKey:@"target_citycode"];
     [dic setObject:xiancode forKey:@"target_districtcode"];
    [dic setObject:blj forKey:@"target_reserve_price"];
    [dic setObject:pgj forKey:@"target_estimated_price"];
    
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
       
        for (int i = 0; i < imageArr.count; i++) {
            UIImage * image= imageArr[i];
           
            NSString *imagetype=@"jpg";
           
            NSData *data = UIImageJPEGRepresentation(image, 0);
           
            NSString *IMAGE=[NSString stringWithFormat:@"target_img%d",i];
            [formData appendPartWithFileData:data name:IMAGE fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
            
        }
//        [formData appendPartWithFileData:data name:@"target_img" fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
        
        
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"48.上传签名图片成功%@",str);
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败%@>>>",error);
        aError(error);
    }];
    
}

#pragma mark --50.上传签名图片(我委托的标的>>>上传图片)
+(void)WU50WeiTuoUp:(UIImage*)image BiaoDiID:(NSString*)biaodiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_uploadNewTargetContractImg.action",SER_VICE];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    
    NSData *data = UIImageJPEGRepresentation(image, 0);
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaodiID]] forKey:@"target_id"];
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        NSString *imagetype=@"jpg";
        [formData appendPartWithFileData:data name:@"entrust_contract_img" fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"50.上传签名图片(我委托的标的>>>上传图片)%@",str);
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败%@>>>",error);
        aError(error);
    }];

}
#pragma mark --51.上传签名图片(我委托的标的>>>签名)
+(void)WUYIWeiTuoQianMing:(UIImage*)image BiaoDiID:(NSString*)biaodiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_uploadTargetContractSignPicture.action",SER_VICE];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaodiID]] forKey:@"target_id"];
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        NSString *imagetype=@"jpg";
        [formData appendPartWithFileData:data name:@"sign_picture" fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"51.上传签名图片(我委托的标的>>>签名)%@",str);
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败%@>>>",error);
        aError(error);
    }];

}
#pragma mark --52.上传签名图片(已买到的标的>>>上传)
+(void)WU52TuoQianMing:(UIImage*)image BiaoDiID:(NSString*)biaodiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_uploadNewTargetTransactionBookImg.action",SER_VICE];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"48.上传签名图片"];
        return;
    }
    NSData *data = UIImageJPEGRepresentation(image, 0);
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaodiID]] forKey:@"target_id"];
     [dic setObject:token forKey:@"user_id"];
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        NSString *imagetype=@"jpg";
        [formData appendPartWithFileData:data name:@"target_transaction_book_img" fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"52.上传签名图片(已买到的标的>>>上传)%@",str);
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败%@>>>",error);
        aError(error);
    }];
    
}

#pragma mark --53.上传签名图片(已买到的标的>>>签名)
+(void)WU53YiMaiDao:(UIImage*)image BiaoDiID:(NSString*)biaodiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_uploadTargetTransactionBookSignPicture.action",SER_VICE];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",biaodiID]] forKey:@"target_id"];
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        NSString *imagetype=@"jpg";
        [formData appendPartWithFileData:data name:@"sign_picture" fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"53.上传签名图片(已买到的标的>>>签名)%@",str);
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败%@>>>",error);
        aError(error);
    }];
}

#pragma mark --54.申请报名->”拍卖会保证金信息” 弹窗
+(void)baoZhengJin54PaiMaiHuiID:(NSString*)paiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError
{
    NSString * urlStr =[NSString stringWithFormat:@"%@auction/app_getAuctionDepositInfo.action",SER_VICE];
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:paiID forKey:@"auction_id"];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"54.申请报名%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"54.申请报名%@",error);
        aError(error);
        
    }];

}

#pragma mark --55.未读消息弹框
+(void)weiDuMessageTanKuangsuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    
    NSString * urlStr =[NSString stringWithFormat:@"%@user/app_qryUnreadMessageInfo.action",SER_VICE];

    NSString * token =[NSUSE_DEFO objectForKey:@"token"];
    if (token==nil) {
        [LCProgressHUD showMessage:@"55.未读消息弹框"];
        return;
    }
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:token forKey:@"user_id"];
    
    
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"55.未读消息弹框%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"55.未读消息弹框%@",error);
        aError(error);
        
    }];
    
}
#pragma mark --56.自动登录
+(void)ziDongLoginPhone:(NSString*)phone success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@login/app_autoLogin.action",SER_VICE];
    
       NSMutableDictionary * dic =[NSMutableDictionary new];
     [dic setObject:phone forKey:@"regist_tel"];
    
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"56.自动登录%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"56.自动登录%@",error);
        aError(error);
        
    }];
    
}

#pragma mark --57个人中心->我发布的预告->预告详情页数据
+(void)myPublicYuGaoID:(NSString*)yugaoID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_getTrailerInfoInUc.action",SER_VICE];
    
    NSMutableDictionary * dic =[NSMutableDictionary new];
    [dic setObject:[ToolClass isString:[NSString stringWithFormat:@"%@",yugaoID]] forKey:@"entrust_trailer_id"];
    
    
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"57个人中心->我发布的预告->预告详情页数据%@",str);
        
        aSuccess(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"57个人中心->我发布的预告->预告详情页数据%@",error);
        aError(error);
        
    }];

}
#pragma mark --58.个人中心下_我发布的预告_预告详情页_修改预告
+(void)xiuGaiYiFaBuID:(NSString*)idd Title:(NSString*)title Phone:(NSString*)phone Peolpe:(NSString*)people oldArr:(NSMutableArray*)oldAr NewArr:(NSMutableArray*)newAr success:(SuccessBlock)aSuccess error:(ErrorBlock)aError{
    
    NSString * urlStr =[NSString stringWithFormat:@"%@entrust/app_updateTrailerInUc.action",SER_VICE];
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    NSMutableDictionary * dic =[NSMutableDictionary new];
//    [dic setObject:@"ios" forKey:@"osType"];
    
    [dic setObject:title forKey:@"trailer_title"];
    [dic setObject:people forKey:@"asset_disposal_person"];
    [dic setObject:phone forKey:@"trailer_connect_tel"];
    [dic setObject:idd forKey:@"id"];
    for (int i=0; i<oldAr.count; i++) {
        NSString * name =[NSString stringWithFormat:@"trailer_imgOld%d",i];
        [dic setObject:oldAr[i] forKey:name];
    }
    
    [manager  POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {//
        
        
        //            上传文件参数
        NSDateFormatter *formmettrt = [[NSDateFormatter alloc]init];
        [formmettrt setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < newAr.count; i++) {
            UIImage * image= newAr[i];
            NSString *imagetype=@"jpg";
            NSData *data = UIImageJPEGRepresentation(image, 0);
            NSString *IMAGE=[NSString stringWithFormat:@"trailer_img%d",i];
            [formData appendPartWithFileData:data name:IMAGE fileName:[NSString stringWithFormat:@"%@.%@", [formmettrt stringFromDate:[NSDate date]], imagetype] mimeType:[NSString stringWithFormat:@"image/%@", imagetype]];
            
        }
    
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"修改%@",str);
        aSuccess(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"8个人中心发布预告%@",error);
    }];

}

#pragma  mark --34socket长连接
+(void)socketLianJieJsonStr:(NSString*)str success:(SuccessBlock)aSuccess {
    
    NSString * sss =[NSString stringWithFormat:@"%@#####",str];
    [[Singleton sharedInstance] sendMessage:sss];
    [Singleton sharedInstance].cityNameBlock=^(NSDictionary*name){
         aSuccess(name);
    };
    
}
@end
