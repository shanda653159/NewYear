//
//  ShowCell.m
//  HappyPurchase
//
//  Created by LD on 15/12/9.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "DetailCell.h"

@interface DetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *salesLabel;

@property (weak, nonatomic) IBOutlet UIButton *discountBut;

@end

@implementation DetailCell

-(void)refreshUI:(DetailModel *)model{
    
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_path] placeholderImage:[UIImage imageNamed:@"beijing"]];
    
    self.descLabel.text = model.title;
    
    self.salesLabel.text = [NSString stringWithFormat:@"已售:%@件",model.sold];
    
    if (model.price_with_rate.floatValue != model.price.floatValue) {
        
        self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%.1f",model.price_with_rate.floatValue];
        
        [self.discountBut setTitle:[NSString stringWithFormat:@"%.1f折",model.discount.floatValue] forState:UIControlStateNormal];
    }else{
    
        self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%.1f",model.price_with_rate.floatValue];
        
        [self.discountBut setTitle:[NSString stringWithFormat:@"暂无折扣"] forState:UIControlStateNormal];
    }

}

@end

