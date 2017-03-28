//
//  Singleton.m
//  socket_tutorial
//
//  Created by xiaoliangwang on 14-7-4.
//  Copyright (c) 2017年 王德帅. All rights reserved.
/*
 1.建立连接
 2.连接成功之后会回调函数
 3.发送数据(发送成功之后会有回调方法)
 4.接收服务器数据
 5.断开连接(服务器断开和用户自己断开)
 
 */

#import "Singleton.h"

#import <sys/socket.h>

#import <netinet/in.h>

#import <arpa/inet.h>

#import <unistd.h>

@implementation Singleton
//每次最多读取多少
#define MAX_BUFFER 1024
//设置写入超时 -1 表示不会使用超时
#define WRITE_TIME_OUT -1
//设置读取超时 -1 表示不会使用超时
#define READ_TIME_OUT -1
+(Singleton *) sharedInstance
{
    
    static Singleton *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}

-(NSString*)getTimeNow{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

//1.建立socket连接
-(void)socketConnectHost{
    self.socket    = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];

}
//2.连接成功后，会回调的函数
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket连接成功");
    //多长时间发送一次心跳
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    [self.connectTimer fire];
    //连接成功之后，隔1秒在发送消息
    [self  performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    
}



#pragma mark  - 心跳连接
-(void)longConnectToSocket{
    
    // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
    
    NSString *longConnect =[NSString stringWithFormat:@"%@心跳#####",[self getTimeNow]];// @"connect is here#####";
    
    NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.socket writeData:dataStream withTimeout:1 tag:1];
    
}
// 切断socket
-(void)cutOffSocket{
    
    self.socket.userData = SocketOfflineByUser;
    
    [self.connectTimer invalidate];
    
    [self.socket disconnect];
}
//5.断开连接
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"socket连接失败 %ld",sock.userData);

    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self socketConnectHost];
    }
    else if (sock.userData == SocketOfflineByUser) {
        
        // 如果由用户断开，不进行重连
        return;
    }else if (sock.userData == SocketOfflineByWifiCut) {
         [self socketConnectHost];
        // wifi断开，不进行重连
        return;
    }

    
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSData * unreadData = [sock unreadData]; // ** This gets the current buffer
    if(unreadData.length > 0) {
        [self onSocket:sock didReadData:unreadData withTag:0]; // ** Return as much data that could be collected
    } else {
        
        NSLog(@" willDisconnectWithError %ld   err = %@",sock.userData,[err description]);
        if (err.code == 57) {
            self.socket.userData = SocketOfflineByWifiCut;
        }
    }
    
}




//3.发送数据
-(void)delayMethod{
    
    NSData   *dataStream  = [_messageContent dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:dataStream withTimeout:1 tag:1];
}


//4.接受消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //服务端返回消息数据量比较大时，可能分多次返回。所以在读取消息的时候，设置MAX_BUFFER表示每次最多读取多少，当data.length < MAX_BUFFER我们认为有可能是接受完一个完整的消息，然后才解析
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@">>>%@",aString);
    NSString *cccc = [aString substringToIndex:[aString length] - 5];
//     NSLog(@">>>%@",cccc);

    
    NSArray *array = [cccc componentsSeparatedByString:@"#####"];
   
    for (NSString * strr in array) {
//       NSLog(@"输出%@",strr);;
         NSData * dataa = [strr dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:dataa options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"字典%@",jsonDict);
        self.cityNameBlock(jsonDict);
    }
    
    
    
    
    
   
//    NSString *b = [s stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#!"]];
   
    
   //NSDictionary * dicc =  (NSDictionary*)aString;
   // NSLog(@"公司%@",dicc);
     //self.cityNameBlock(jsonDict);
//        NSLog(@"数据解析%@",dic);
//        //解析出来的消息，可以通过通知、代理、block等传出去
//        
//    }
    
    
    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
    
}
//发送消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //读取消息
    [self.socket readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
}
@end
