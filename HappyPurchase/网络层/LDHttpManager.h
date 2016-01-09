//
//  LDHttpManager.h
//  LoveLimitFree
//
//  Created by LD on 15/12/2.
//  Copyright © 2015年 LD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDHttpManager : NSObject

/*
 参数1:响应头
 参数2:错误信息
 参数3:返回的数据
 */
typedef void (^returnBlock) (NSURLResponse *response,NSError *error,id obj);

/*
 参数1:请求的URL
 参数2:上传的参数
 参数3:回调的block
 */
+(void)getRequestWithURL:(NSString *)url andParams:(NSDictionary *)params compeletionBlock:(returnBlock)block;

/*
 参数1:请求的URL
 参数2:上传的参数
 参数3:回调的block
 */
+(void)postRequestWithURL:(NSString *)url andParams:(NSDictionary *)params compeletionBlock:(returnBlock)block;

//请求不支持类型的json数据
+(void)getWithURLForData:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block;

//请求不支持类型的json数据
+(void)postWithURLForData:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block;

//带有中文的请求
+(void)getWithURLForUTF8:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block;

//带有中文的请求
+(void)postWithURLForUTF8:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block;

//上传JSON数据
+(void)getWithURLForJsonData:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block;

//上传JSON数据
+(void)postWithURLForJsonData:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block;

//添加额外的请求头
+(void)getWithURLAddExtraHeader:(NSString *)url  extraHeader:(NSDictionary *)headerParmas andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block;

@end
