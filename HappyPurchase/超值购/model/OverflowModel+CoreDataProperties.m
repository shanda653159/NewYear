//
//  OverflowModel+CoreDataProperties.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/10.
//  Copyright © 2015年 LD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OverflowModel+CoreDataProperties.h"

@implementation OverflowModel (CoreDataProperties)

@dynamic deal_num;
@dynamic discount;
@dynamic is_onsale;
@dynamic is_vip_price;
@dynamic now_price;
@dynamic num_iid;
@dynamic origin_price;
@dynamic pic_url;
@dynamic rp_type;
@dynamic show_time;
@dynamic start_discount;
@dynamic title;
@dynamic total_love_number;

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
