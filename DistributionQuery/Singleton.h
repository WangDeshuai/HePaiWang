//
//  Singleton.h
//  socket_tutorial
//
//  Created by xiaoliangwang on 14-7-4.
//  Copyright (c) 2014年 芳仔小脚印. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsyncSocket.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t onceToken = 0; \
__strong static id sharedInstance = nil; \
dispatch_once(&onceToken, ^{ \
sharedInstance = block(); \
}); \
return sharedInstance; \


enum{
    SocketOfflineByServer,
    SocketOfflineByUser,
    SocketOfflineByWifiCut,
};

@interface Singleton : NSObject<AsyncSocketDelegate>

@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot

@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器
@property(nonatomic,strong)NSMutableArray * arrayData;
@property(nonatomic,strong)NSMutableData * mData;

@property(nonatomic,copy)void(^cityNameBlock)(NSDictionary*name);
+ (Singleton *)sharedInstance;

-(void)socketConnectHost;// socket连接

-(void)cutOffSocket;// 断开socket连接
//发送请求消息的内容
@property(nonatomic,copy)NSString * messageContent;
// 发送消息
- (void)sendMessage:(id)message;

@end
