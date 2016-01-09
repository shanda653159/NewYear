//
//  JiukuaijiuModel.h
//  HappyPurchase
//
//  Created by LD on 15/12/9.
//  Copyright © 2015年 LD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiukuaijiuModel : NSObject

@property (nonatomic,assign)CGFloat discount;
@property (nonatomic,copy)NSString *start_discount;
@property (nonatomic,copy)NSString *num_iid;
@property (nonatomic,copy)NSString *qiangpai;
@property (nonatomic,copy)NSString *show_time;
@property (nonatomic,assign)int is_vip_price;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *pic_url;
@property (nonatomic,assign)int is_onsale;
@property (nonatomic,assign)int total_love_number;
@property (nonatomic,copy)NSString *rp_type;
@property (nonatomic,assign)CGFloat now_price;
@property (nonatomic,assign)CGFloat origin_price;
@property (nonatomic,assign)int total_hate_number;
@property (nonatomic,assign)int is_buy_sale;
@property (nonatomic,copy)NSString *deal_num;
@property (nonatomic,assign)int ling_value;

@end
