//
//  SpecialSaleCell.h
//  HappyPurchase
//
//  Created by LD on 15/12/11.
//  Copyright © 2015年 LD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialSaleCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)setTitle:(NSString *)title;

@end
