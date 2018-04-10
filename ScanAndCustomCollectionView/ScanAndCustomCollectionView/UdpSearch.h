//
//  UdpSearch.h
//  RemoteControl
//
//  Created by 章丘研发 on 2018/2/1.
//  Copyright © 2018年 base. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol UdpSearchDelegate <NSObject>

@optional -(void)receiveData:(NSString *)receiveStr;

@optional -(void)receiveATData:(NSString *)receiveStr;

@end

@interface UdpSearch : NSObject

//开始搜索
-(void)startSearch;
//停止搜索
-(void)stopSearch;

-(void)sendMessage:(NSString *)message;

@property (nonatomic,weak) id <UdpSearchDelegate> delegate;

@end
