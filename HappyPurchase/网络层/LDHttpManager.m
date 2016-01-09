//
//  LDHttpManager.m
//  LoveLimitFree
//
//  Created by LD on 15/12/2.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "LDHttpManager.h"

@implementation LDHttpManager

//get请求
+(void)getRequestWithURL:(NSString *)url andParams:(NSDictionary *)params compeletionBlock:(returnBlock)block{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(operation.response,nil,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,error,nil);
        
    }];
}

//post请求
+(void)postRequestWithURL:(NSString *)url andParams:(NSDictionary *)params compeletionBlock:(returnBlock)block{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(operation.response,nil,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,error,nil);
        
    }];
}

+(void)getWithURLForData:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //修改响应解析器的响应类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:pamars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(operation.response,nil,[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,error,nil);
        
    }];
}

+(void)postWithURLForData:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //修改响应解析器的响应类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:pamars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(operation.response,nil,[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,error,nil);
        
    }];
}

+(void)getWithURLForUTF8:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //stringByReplacingPercentEscapesUsingEncoding 还原UTF8编码
    //带有中文需要转换成UTF编码
    NSString *utf8Str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:utf8Str parameters:pamars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(operation.response,nil,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,error,nil);
        
    }];
}

+(void)postWithURLForUTF8:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //stringByReplacingPercentEscapesUsingEncoding 还原UTF8编码
    //带有中文需要转换成UTF编码
    NSString *utf8Str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:utf8Str parameters:pamars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(operation.response,nil,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,error,nil);
        
    }];
}

+(void)getWithURLForJsonData:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //修改请求解析器上传的数据类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:url parameters:pamars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(operation.response,nil,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,error,nil);
        
    }];
}

+(void)postWithURLForJsonData:(NSString *)url andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //修改请求解析器上传的数据类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:url parameters:pamars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(operation.response,nil,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,error,nil);
        
    }];
}

+(void)getWithURLAddExtraHeader:(NSString *)url extraHeader:(NSDictionary *)headerParmas andParams:(NSDictionary *)pamars competionBlcok:(returnBlock)block{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //添加额外的请求头
    for (NSString *key in headerParmas) {
        
        [manager.requestSerializer setValue:headerParmas[key] forHTTPHeaderField:key];
    }
    
    [manager GET:url parameters:pamars success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(operation.response,nil,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,error,nil);
        
    }];
}

@end
