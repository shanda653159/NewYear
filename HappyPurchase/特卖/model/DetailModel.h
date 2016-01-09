//
//  DetailModel.h
//  HappyPurchase
//
//  Created by 雷东 on 15/12/11.
//  Copyright © 2015年 LD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *pic_path;
@property (nonatomic,copy)NSString *price_with_rate;
@property (nonatomic,copy)NSString *discount;
@property (nonatomic,copy)NSString *sold;
@property (nonatomic,copy)NSString *item_id;

@end
