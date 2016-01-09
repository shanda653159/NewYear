//
//  MyImageView.m
//  HappyPurchase
//
//  Created by LD on 15/12/15.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "LoadImageView.h"

@implementation LoadImageView

//返回view中的所有子类中是本类的view
+(NSArray *)allSubForView:(UIView *)view {
    NSMutableArray *subs = [NSMutableArray array];
    for (UIView *aView in view.subviews) {
        if ([aView isKindOfClass:self]) {
            [subs addObject:aView];
        }
    }
    return [NSArray arrayWithArray:subs];
}

@end
