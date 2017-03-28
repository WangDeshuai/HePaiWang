//
//  Engine.h
//  DistributionQuery
//
//  Created by Macx on 16/10/8.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessBlock)(NSDictionary*dic);
typedef void (^ErrorBlock)(NSError*error);
@interface Engine : NSObject
//**********************************首页**********************//

#pragma mark --0上传单张图片获取base64编码
+(void)upDataBaseWithImageBaseImage:(UIImage*)image success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;


#pragma mark --1获取短信验证码
+(void)getMessageCodePhone:(NSString*)phone success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --2注册
+(void)registPhone:(NSString*)phone Password:(NSString*)psw password2:(NSString*)psw2 Code:(NSString*)code success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --3登录
+(void)loginAccount:(NSString*)phone Password:(NSString*)psw success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --4我的个人信息
+(void)myMessagesuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --5首页成交案例
+(void)firstChengJiaoAnLiPageindex:(NSString*)page success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --6忘记密码
+(void)forgetPassWordPhone:(NSString*)phone Code:(NSString*)code NewPsw:(NSString*)newpsw AgeinPsw:(NSString*)ageinpsw success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;


#pragma mark--7个人中心消息列表//stype阅读状态 1.已读 0.未读
+(void)CenterMessageListViewStype:(NSString*)stype Pageindex:(NSString*)page success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --8个人中心发布预告
+(void)pubulicYuGaoTitle:(NSString*)title People:(NSString*)people Content:(NSString*)content Pic:(UIImage*)picImage success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --9获取所有省份
+(void)huoQuAllShengFensuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --12根据省份获取城市
+(void)huoQuWithShengGetCityShengCode:(NSString*)provicecode success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --13根据城市获取县
+(void)huoQuXianWithCityCode:(NSString*)citycode success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --14个人中心_我发布的预告
+(void)myCenterYuGaoPageIndex:(NSString*)page  success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --15查询所有标的类型
+(void)biaoDiStypesuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --16修改个人信息
+(void)modificationMyMessageKeyDicStr:(NSString*)dicStr success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --17个人中心我已买到的标的标的-1.全部 0.未交割 1.已交割
+(void)myCenterMyBuyBiaoDiStype:(NSString*)stype Page:(NSString*)page success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --18获取实名认证资料
+(void)getShiMingMessagesuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --20修改实名认证 sy==1个人 2企业
+(void)xiuGaiShiMingRenZhengMessageJsonStr:(NSString*)dicStr  success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --21我发布的预告删除
+(void)myPublicDeleteTrailerID:(NSString*)idd success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --22个人中心账户消息列表
+(void)myCenterZhaoHuListViewStyle:(NSString*)style Page:(NSString*)page success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --23消息列表详/账户列表情页
+(void)messageViewMessageID:(NSString*)messageID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --24拍卖标的列表
+(void)firstPaiMaiBiaoDiViewSearchStr:(NSString*)searStr BiaoDiStyle:(NSString*)leiXing ProvCode:(NSString*)procode CityCode:(NSString*)citycode Staus:(NSString*)styleStr PageSize:(NSString*)pagesize PageIndex:(NSString*)pageindex success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --25查询拍卖公告列表
+(void)upDataPaiMaiPublicViewSearchStr:(NSString*)searStr  BiaoDiLeiXing:(NSString*)baiDiStyle ProvCode:(NSString*)shengcode CityCode:(NSString*)citycode BeginTime:(NSString*)time Page:(NSString*)page PageSize:(NSString*)pagesize success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --26公告详请页
+(void)PaiMaiPublicMessageID:(NSString*)messageID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --27未登录状态下委托发布
+(void)loginIsNoPublicPeople:(NSString*)people Phone:(NSString*)phone PhoneCode:(NSString*)yanZhengMa BiaoDiName:(NSString*)bdname BiaoDiMiaoShu:(NSString*)biaodims XiaCiName:(NSString*)xcname ShengCode:(NSString*)shengcode CityCode:(NSString*)citycode XianCode:(NSString*)xiancode ImageArray:(NSMutableArray*)imageArr success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --28已登录状态委托发布
+(void)loginIsYesPublicPeopleName:(NSString*)people PhoneNum:(NSString*)phone BiaoDiName:(NSString*)biaodiname MiaoShu:(NSString*)miaoshu XiaCi:(NSString*)xiaci ShengCode:(NSString*)scode CityCode:(NSString*)ccode XianCode:(NSString*)xcode BaoLiuPrice:(NSString*)blprice PingGuPrice:(NSString*)pgprice imageArr:(NSMutableArray*)imageArr success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --29个人中心_我参加的拍卖会
+(void)myCenterMyCanJiaPaiMaiHuiBiaoDiType:(NSString*)leiXing Page:(NSString*)page ShengCode:(NSString*)scode CityCode:(NSString*)ccode BeginTime:(NSString*)timeStr success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --30报名参加拍卖会
+(void)BaoMingCanJianPaiMaiID:(NSString*)paiMaiID BiaoDiID:(NSString*)biaoid Phone:(NSString*)phone PeopleName:(NSString*)people MessageName:(NSString*)message success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;
#pragma mark --31首页轮播图
+(void)huoQuFirstLunBoImageArrsuccess:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma mark --32个人中心_我委托的标的列表
+(void)myCenterWeiTuoPage:(NSString*)page Status:(NSString*)style success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;


#pragma mark --33拍卖标的详情页所需数据
+(void)paiMaiLieBiaoXiangQingPaiMaiID:(NSString*)paimaiID BiaoDiID:(NSString*)biaodiID success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

#pragma  mark --34socket长连接
+(void)socketLianJieJsonStr:(NSString*)str success:(SuccessBlock)aSuccess error:(ErrorBlock)aError;

@end
