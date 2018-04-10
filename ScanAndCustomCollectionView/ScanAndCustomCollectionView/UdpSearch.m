//
//  UdpSearch.m
//  RemoteControl
//
//  Created by 章丘研发 on 2018/2/1.
//  Copyright © 2018年 base. All rights reserved.
//

#import "UdpSearch.h"
#import "GCDAsyncUdpSocket.h"

@interface UdpSearch()<GCDAsyncUdpSocketDelegate>

@property (nonatomic,strong) GCDAsyncUdpSocket *udpSocket;

@property (nonatomic,assign) BOOL isSearch;

@end

@implementation UdpSearch

-(instancetype)init{
    self = [super init];
    if (self){
        [self createUdpSocket];
    }
    return self;
}


-(void)createUdpSocket{
    
    if (!_udpSocket){
        
        _udpSocket =  [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        NSError *error = nil;
        
        if (![_udpSocket bindToPort:0 error:&error])
        {
            return;
        }
        
        [_udpSocket enableBroadcast:YES error:&error];
        if (nil != error) {
            NSLog(@"failed.:%@",[error description]);
        }
        
        
        if (![_udpSocket beginReceiving:&error])
        {
            return;
        }
    }
}

-(void)startSearch{
    _isSearch = YES;
    [self udpSocketSendData];
}

-(void)stopSearch{
    _isSearch = NO;
}

-(void)udpSocketSendData{
    NSString *host = @"255.255.255.255";
    int port = 48899;
    NSString *message = @"hello";
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:0];
}



//发送消息后回调，不关心是否成功发送。
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
    if (_isSearch){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(udpSocketSendData) withObject:nil afterDelay:1];
        });
    }

}

//在接收到消息后回调这个方法
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext{
    //wifi 模块返回IP地址和mac
    NSString *receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self.delegate receiveData:receiveStr];


    
}


- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error{
    
    if (![_udpSocket bindToPort:0 error:&error])
    {
        return;
    }
    
    [_udpSocket enableBroadcast:YES error:&error];
    if (nil != error) {
        NSLog(@"failed.:%@",[error description]);
    }
    
    
    if (![_udpSocket beginReceiving:&error])
    {
        return;
    }
    
    [self startSearch];
    
}



-(void)dealloc{
    
}

@end
