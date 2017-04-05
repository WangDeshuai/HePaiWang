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
#define MAX_BUFFER 3072
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
    _arrayData=[NSMutableArray new];
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
    [self.socket writeData:dataStream withTimeout:WRITE_TIME_OUT tag:1];
}
//3.发送数据
- (void)sendMessage:(id)message
{
    //像服务器发送数据
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:cmdData withTimeout:WRITE_TIME_OUT tag:1];
}
//读取数据，有数据就会触发代理
- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag{
    
}
//直到读到这个长度的数据，才会触发代理
- (void)readDataToLength:(NSUInteger)length withTimeout:(NSTimeInterval)timeout tag:(long)tag{
    
}
//4.接受消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
   NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"源数据%@",aString);
//
   
//    if (_mData == nil) {
//        _mData = [[NSMutableData alloc] init];
//    }
//    [_mData appendData:data];
   // NSString *httpResponse = [[NSString alloc] initWithData:_mData encoding:NSUTF8StringEncoding];
//
   // NSLog(@"源数据%@",httpResponse);
   // 这一行 应该在底下的方法中，如果出错就是这的问题
   // [self blockBack:httpResponse];
    
//      NSRange range = [httpResponse rangeOfString:@"#####"];
//    if(range.location != NSNotFound)
//    {
//        NSString *aString1 = [[NSString alloc] initWithData:_mData encoding:NSUTF8StringEncoding];
//        [self blockBack:aString1];
////        \数据读取完毕。进行相关操作
////        \注意操作完毕释放_mdata
//        _mData = nil;
//    }

   
    
    
    //1.区分一下每次aString中返回的结果是否有#####
    if ([self panduan:aString]==NO) {
        //2.不包含####(把不包含#的放到数组中)
       // NSLog(@"我曹%@",aString);[ToolClass isString:aString]
        [_arrayData addObject:aString];
        
        
    }else{
        //包含###
        if (_arrayData.count==0) {
            //3.数组为0，说明1条数据是完整的，否则是不完整的
            [self blockBack:aString];
        }else{
            //4.把数组中所有元素都拼接起来
            NSString *string = [_arrayData componentsJoinedByString:@""];
            //5.在把最后一个拼接起来，形成完整的字符串
            NSString * str =[NSString stringWithFormat:@"%@%@",string,aString];
            //6.返回数据
            [self blockBack:str];
            [_arrayData removeAllObjects];
        }
    
        

    }
    
    
    
   [self.socket readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:LONG_MAX tag:0];
    
}


//-(void)socketReceive :(NSData *)data
//{
//    
//    //NSError *error;
//    
//    NSData *typedata = [data subdataWithRange:NSMakeRange(0,1)];
//    
//    NSData *flagdata = [data subdataWithRange:NSMakeRange(1,5)];
//    
//    NSData *contentdata = [data subdataWithRange:NSMakeRange(5, data.length-5)];
//    
//    NSString *typeStr  = [[NSString alloc]initWithData:typedata encoding:NSUTF8StringEncoding];
//    
//    NSString *flagStr  = [[NSString alloc]initWithData:flagdata encoding:NSUTF8StringEncoding];
//    
//    NSString *contentStr = [[NSString alloc]initWithData:contentdata encoding:NSUTF8StringEncoding];
//  
//   
//   
//}





//返回数据
-(void)blockBack:(NSString*)aString{
    //把最后5个#去掉，取出#号之前的字符cccc
    NSString *cccc = [aString substringToIndex:[aString length] - 5];
    //把每条完整的数据存到数组中
    NSArray *array = [cccc componentsSeparatedByString:@"#####"];
    
    for (NSString * strr in array) {
        NSData * dataa = [strr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:dataa options:NSJSONReadingMutableLeaves error:nil];
       // NSLog(@"执行几次");
       self.cityNameBlock(jsonDict);
    }
   
}


-(BOOL)panduan:(NSString*)str{
    //从字符串中取出最后5个字符，看是不是#####
    NSString *sssa = [str substringFromIndex:[str length] - 5];
    if ([sssa isEqualToString:@"#####"]) {
        //是的话返回YES
        return YES;
    }else{
        return NO;
    }
    
}

//发送消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"回调");
    //读取消息
   
    [self.socket readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength: LONG_MAX tag:0];
}
@end
