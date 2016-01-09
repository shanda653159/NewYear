//
//  SpecialSubCell.m
//  HappyPurchase
//
//  Created by LD on 15/12/11.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "SpecialSubCell.h"

@interface SpecialSubCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SpecialSubCell

-(void)refreshUI:(SpecialSaleModel *)model{

    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",KSpecImg_URL,model.cid]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.showImageView.layer.cornerRadius = 5.0;
    self.showImageView.layer.borderWidth = 1.0;
    self.showImageView.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.titleLabel.text = model.name;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

@end
