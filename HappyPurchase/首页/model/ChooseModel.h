//
//  ChooseModel.h
//  HappyPurchase
//
//  Created by 雷东 on 15/12/9.
//  Copyright © 2015年 LD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseModel : NSObject

@property (nonatomic,copy)NSString *coverForPadUrl;
//放tableView中的图
@property (nonatomic,copy)NSString *bannerUrl;
@property (nonatomic,copy)NSString *textBg;
//跳转下页的id
@property (nonatomic,copy)NSString *topicContentId;
@property (nonatomic,copy)NSString *updateTime;
//下一页的title
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *backCover;
@property (nonatomic,copy)NSString *bannerUrlForPad;
@property (nonatomic,copy)NSString *introForPad;

@end
