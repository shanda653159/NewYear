//
//  DetailViewController.h
//  HappyPurchase
//
//  Created by 雷东 on 15/12/11.
//  Copyright © 2015年 LD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic,copy) NSString *cid;
//判断是普通商品详情还是搜索商品详情
@property (nonatomic,assign) BOOL isSearch;
//搜索条传过来的关键字
@property (nonatomic,copy) NSString *keyword;

@end
