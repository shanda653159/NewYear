//
//  LockView.h
//  手势密码解锁
//
//  Created by 雷东 on 15/12/26.
//  Copyright © 2015年 雷东. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasswordDelegate <NSObject>

-(void)unlockWithPassword:(NSString *)password;

@end

@interface LockView : UIView

@property (nonatomic,weak) id<PasswordDelegate> delegate;

@end
