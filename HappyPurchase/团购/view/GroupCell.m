//
//  GroupCell.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/12.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "GroupCell.h"

@interface GroupCell ()

@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@property (weak, nonatomic) IBOutlet UIButton *discountBut;

@end

@implementation GroupCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)refreshUI:(GroupModel *)model{

    if ([model.juSlogo containsString:@"仅剩"]) {
        
        self.smallImageView.image = [UIImage imageNamed:@"buy_flag"];
    }else{
    
        self.smallImageView.image = [UIImage imageNamed:@"over_flag"];
    }
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.juLogo] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:model.juBanner] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    
    self.nameLabel.text = model.name;
    
    self.timeLabel.text = model.juSlogo;
    
    self.idLabel.text = model.juBrand_id;
    
    [self.discountBut setTitle:[NSString stringWithFormat:@"%@折",model.juDiscount] forState:UIControlStateNormal];
}

@end
