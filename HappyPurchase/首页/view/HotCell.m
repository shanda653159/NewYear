//
//  WorthCell.m
//  HappyPurchase
//
//  Created by LD on 15/12/9.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "HotCell.h"

@interface HotCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *salesLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *discountBut;

@end

@implementation HotCell

-(void)refreshUI:(HotModel *)model{

    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_url]placeholderImage:[UIImage imageNamed:@"beijing"]];
    
    self.titleLabel.text = model.title;
    
    self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%.1f",model.now_price];
    
    self.lastPriceLabel.text = [NSString stringWithFormat:@"￥%.1f",model.origin_price];
    
    self.salesLabel.text = [NSString stringWithFormat:@"已售:%@件",model.dianji];
    
    [self.discountBut setTitle:[NSString stringWithFormat:@"%.1f折",model.discount] forState:UIControlStateNormal];
    //根据label大小自动调节字体大小
    self.nowPriceLabel.adjustsFontSizeToFitWidth = YES;
    self.lastPriceLabel.adjustsFontSizeToFitWidth = YES;
}
@end
