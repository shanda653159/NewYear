//
//  MenuCell.m
//  HappyPurchase
//
//  Created by LD on 15/12/12.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell ()

@end

@implementation MenuCell

-(void)setTitle:(NSString *)title{

    self.titleLabel.text = title;
    
    self.titleLabel.layer.cornerRadius = 12.0f;
    self.titleLabel.layer.borderWidth = 1.5;
    self.titleLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.titleLabel.textColor = [UIColor darkGrayColor];
}

@end
