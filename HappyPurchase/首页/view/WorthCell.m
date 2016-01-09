//
//  WorthCell.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/9.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "WorthCell.h"

@interface WorthCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UILabel *lastPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *soldLabel;

@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *purchaseBut;

@end


@implementation WorthCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)refreshUI:(WorthModel *)model{

    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_url]placeholderImage:[UIImage imageNamed:@"beijing"]];
    
    self.nameLabel.text = model.title;
    
    self.lastPriceLabel.text = [NSString stringWithFormat:@"原价:%.0f",model.old_price.floatValue];
    
    self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.now_price];
    
    self.descLabel.text = model.discribe;
    
    self.soldLabel.text = [NSString stringWithFormat:@"%@人已买",model.sold];
    
    self.purchaseBut.layer.cornerRadius = 10.0f;
    
    //根据label大小自动调节字体大小
    self.nowPriceLabel.adjustsFontSizeToFitWidth = YES;
    self.lastPriceLabel.adjustsFontSizeToFitWidth = YES;
}

- (IBAction)purchaseAction:(UIButton *)sender {
    
    
}

@end
