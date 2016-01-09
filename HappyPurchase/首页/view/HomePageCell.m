//
//  HomePageCell.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/8.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "HomePageCell.h"

@interface HomePageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *salesLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *discountBut;

@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;

@end

@implementation HomePageCell

-(void)refreshUI:(HomePageModel *)model{

    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@"beijing"]];
    
    self.titleLabel.text = model.title;
    
    self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%.1f",model.now_price.floatValue];
    
    self.lastPriceLabel.text = [NSString stringWithFormat:@"￥%.1f",model.origin_price.floatValue];
    
    self.salesLabel.text = [NSString stringWithFormat:@"已售:%@件",model.deal_num];
    
    [self.discountBut setTitle:[NSString stringWithFormat:@"%.1f折",model.discount.floatValue] forState:UIControlStateNormal];
    //根据label大小自动调节字体大小
    self.nowPriceLabel.adjustsFontSizeToFitWidth = YES;
    self.lastPriceLabel.adjustsFontSizeToFitWidth = YES;
}

@end
