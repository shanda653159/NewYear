//
//  SpecialFirstCell.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/11.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "SpecialFirstCell.h"

@interface SpecialFirstCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end

@implementation SpecialFirstCell

-(void)refreshUI:(SpecialSaleModel *)model{

    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",KSpecImg_URL,model.cid]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    
}

@end
