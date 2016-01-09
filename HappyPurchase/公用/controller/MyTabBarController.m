//
//  MyTabBarController.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/11.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "MyTabBarController.h"
#import "HomePageViewController.h"

@interface MyTabBarController ()

@property (nonatomic,strong) AppDelegate *app;

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.layer.borderWidth = 1.0;
    self.tabBar.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2].CGColor;
    
    self.tabBarController.tabBar.delegate = self;
    
    self.app = [UIApplication sharedApplication].delegate;
    
    self.app.isHomePage = YES;
    
    NSArray *imageArr = @[@"home",@"worth",@"specialsale",@"groupon",@"me"];
    NSArray *selectImageArr = @[@"homeSel",@"worthSel",@"specialsaleSel",@"grouponSel",@"meSel"];

    for (UINavigationController *nav in self.viewControllers) {
        //indexOfObject 取得元素所在的下标值
        NSInteger index = [self.viewControllers indexOfObject:nav];
        //UIImageRenderingModeAlwaysOriginal  使用图片原始效果,不加渲染
        nav.viewControllers[0].tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:imageArr[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:[[UIImage imageNamed:selectImageArr[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
    //遍历tabbar中item让item的图片向下移动6个像素（PS:top和bottom参数必须一样）
    for (UITabBarItem *item in self.tabBar.items) {
        
        item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
}
//选择tabbar某个item回调方法
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)Item{
    
    //获取当前选中item的下标
    NSUInteger tabIndex = [tabBar.items indexOfObject:Item];
    
    //如果是0的话就是选择了HomePage控制器
    if (tabIndex == 0) {
        
        self.app.isHomePage = YES;
    }else{
        
        self.app.isHomePage = NO;
    }
    
//    NSLog(@"%d",self.app.isHomePage);
    
}

@end
