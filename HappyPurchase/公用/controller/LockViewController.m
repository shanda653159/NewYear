//
//  LockViewController.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/27.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "LockViewController.h"
#import "LockView.h"
#import "MyTabBarController.h"

@interface LockViewController ()<PasswordDelegate>

@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LockView *lockView = [[LockView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenWidth)];
    lockView.center = self.view.center;
    lockView.backgroundColor = [UIColor clearColor];
    
    lockView.delegate = self;
    
    [self.view addSubview:lockView];
    
    self.alertLabel.text = @"请绘制手势密码";
    
}
//手势解锁回调方法
-(void)unlockWithPassword:(NSString *)password{
    
    //    NSLog(@"password = %@",password);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    if (![user objectForKey:@"pwd"]) {
        
        //存值
        [user setObject:[NSString stringWithFormat:@"%@",password] forKey:@"pwd"];
        
        self.alertLabel.text = @"请确认手势密码";
        
    }else{
        
        if (![user objectForKey:@"save"]) {
            
            if ([[user objectForKey:@"pwd"] isEqualToString:password]) {
                
                [user setObject:@"yes" forKey:@"save"];
                
                self.alertLabel.text = @"设置手势成功!";
                
                //延迟1秒跳转界面
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1.0), dispatch_get_main_queue(), ^{
                    
                    [self applicationBegin];
                });
            }else{
                
                self.alertLabel.text = @"密码错误!请重新绘制";
            }
            
        }else{
            
            //如果手势密码正确
            if ([password isEqualToString:[user objectForKey:@"pwd"]]) {
                
                self.alertLabel.text = @"密码正确";
                
                //延迟1秒跳转界面
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.2), dispatch_get_main_queue(), ^{
                    
                    [self applicationBegin];
                });
                
            }else{
                
                self.alertLabel.text = @"密码错误!";
            }
            
        }
    }
}
//进入主界面
-(void)applicationBegin{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MyTabBarController *tabBarCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"MyTabBarController"];
    
    tabBarCtl.view.alpha = 0;
    
    [self presentViewController:tabBarCtl animated:NO completion:^{
        
        [UIView animateWithDuration:2.0 animations:^{
            
            tabBarCtl.view.alpha = 1;
            
        }];
        
    }];
}

@end
