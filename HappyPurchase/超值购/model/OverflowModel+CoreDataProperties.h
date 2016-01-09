//
//  OverflowModel+CoreDataProperties.h
//  HappyPurchase
//
//  Created by 雷东 on 15/12/10.
//  Copyright © 2015年 LD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OverflowModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OverflowModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *deal_num;
@property (nullable, nonatomic, retain) NSString *discount;
@property (nullable, nonatomic, retain) NSString *is_onsale;
@property (nullable, nonatomic, retain) NSString *is_vip_price;
@property (nullable, nonatomic, retain) NSString *now_price;
@property (nullable, nonatomic, retain) NSString *num_iid;
@property (nullable, nonatomic, retain) NSString *origin_price;
@property (nullable, nonatomic, retain) NSString *pic_url;
@property (nullable, nonatomic, retain) NSString *rp_type;
@property (nullable, nonatomic, retain) NSString *show_time;
@property (nullable, nonatomic, retain) NSString *start_discount;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *total_love_number;

@end

NS_ASSUME_NONNULL_END
