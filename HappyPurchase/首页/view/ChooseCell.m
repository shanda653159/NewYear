//
//  ChooseCell.m
//  HappyPurchase
//
//  Created by 雷东 on 15/12/9.
//  Copyright © 2015年 LD. All rights reserved.
//

#import "ChooseCell.h"

@interface ChooseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end


@implementation ChooseCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)refreshUI:(ChooseModel *)model{

    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.bannerUrl]placeholderImage:[UIImage imageNamed:@"beijing"]];
}

@end
