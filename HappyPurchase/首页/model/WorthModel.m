//
//  WorthModel.m
//  HappyPurchase
//
//  Created by LD on 15/12/9.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "WorthModel.h"

@implementation WorthModel

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([value isKindOfClass:[NSNumber class]]) {
        
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
        
    }else if ([key isKindOfClass:[NSNull class]]){
        
        [self setValue:nil forKey:key];
    }else{
        
        [super setValue:value forKey:key];
    }
}

//重写以下方法防止崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    //    NSLog(@"未定义的key值为%@",key);
}

-(id)valueForUndefinedKey:(NSString *)key{
    
    NSLog(@"未获取到对应的key：%@",key);
    return nil;
}

@end
