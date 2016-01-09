//
//  HomePageModel+CoreDataProperties.h
//  HappyPurchase
//
//  Created by LD on 15/12/10.
//  Copyright © 2015年 LD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HomePageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *discount;
@property (nullable, nonatomic, retain) NSString *start_discount;
@property (nullable, nonatomic, retain) NSString *num_iid;
@property (nullable, nonatomic, retain) NSString *qiangpai;
@property (nullable, nonatomic, retain) NSString *show_time;
@property (nullable, nonatomic, retain) NSString *is_vip_price;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *pic_url;
@property (nullable, nonatomic, retain) NSString *is_onsale;
@property (nullable, nonatomic, retain) NSString *total_love_number;
@property (nullable, nonatomic, retain) NSString *rp_type;
@property (nullable, nonatomic, retain) NSString *now_price;
@property (nullable, nonatomic, retain) NSString *origin_price;
@property (nullable, nonatomic, retain) NSString *total_hate_number;
@property (nullable, nonatomic, retain) NSString *is_buy_sale;
@property (nullable, nonatomic, retain) NSString *deal_num;
@property (nullable, nonatomic, retain) NSString *ling_value;

@end

NS_ASSUME_NONNULL_END
