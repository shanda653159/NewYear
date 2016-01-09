//
//  HeaderModel+CoreDataProperties.h
//  HappyPurchase
//
//  Created by 雷东 on 15/12/8.
//  Copyright © 2015年 LD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HeaderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeaderModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *ipadimg;
@property (nullable, nonatomic, retain) NSString *ipadzimg;
@property (nullable, nonatomic, retain) NSString *iphoneimg;
@property (nullable, nonatomic, retain) NSString *iphoneimgnew;
@property (nullable, nonatomic, retain) NSString *iphonemimg;
@property (nullable, nonatomic, retain) NSString *iphonezimg;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *target;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
