//
//  LDProgressView.m
//  LDProgressView
//
//  Created by LD on 15/12/14.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "LDProgressView.h"
#import "LoadImageView.h"

@implementation LDProgressView
//显示加载视图
+(void)showViewTo:(UIView *)view{
    LoadImageView *imgView = [[LoadImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imgView.image = [UIImage imageNamed:@"loading_circle1"];
    [view addSubview:imgView];
    imgView.center = view.center;
    //创建一个可变数组，将要制作动画的图片存储
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 1; i < 13; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading_circle%d",i]];
        [arrM addObject:img];
    }
    [imgView setAnimationImages:arrM];
    //打开人机交互开关
    imgView.userInteractionEnabled = YES;
    //播放一组图片的时间为2.5秒，无限次循环
    [imgView setAnimationDuration:2.5];
    [imgView setAnimationRepeatCount:0];
    //开始播放动画
    [imgView startAnimating];
}
//隐藏加载视图
+(void)hidesViewFrom:(UIView *)view{
    NSArray *subs = [LoadImageView allSubForView:view];
    for (LoadImageView *sub in subs) {
        [sub removeFromSuperview];
    }
}

@end