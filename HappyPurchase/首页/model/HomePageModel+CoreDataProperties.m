//
//  HomePageModel+CoreDataProperties.m
//  HappyPurchase
//
//  Created by LD on 15/12/10.
//  Copyright © 2015年 LD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HomePageModel+CoreDataProperties.h"

@implementation HomePageModel (CoreDataProperties)

@dynamic discount;
@dynamic start_discount;
@dynamic num_iid;
@dynamic qiangpai;
@dynamic show_time;
@dynamic is_vip_price;
@dynamic title;
@dynamic pic_url;
@dynamic is_onsale;
@dynamic total_love_number;
@dynamic rp_type;
@dynamic now_price;
@dynamic origin_price;
@dynamic total_hate_number;
@dynamic is_buy_sale;
@dynamic deal_num;
@dynamic ling_value;

//普通模型不需要重写此方法,只有coreData生成的模型才需要重写此方法
-(void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues{
    
    //循环调用(void)setValue:(id)value forKey:(NSString *)key
    for (NSString *key in keyedValues) {
        
        [self setValue:keyedValues[key] forKey:key];
    }
}

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
