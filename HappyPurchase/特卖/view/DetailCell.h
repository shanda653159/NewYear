//
//  DetailCell.h
//  HappyPurchase
//
//  Created by 雷东 on 15/12/11.
//  Copyright © 2015年 LD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"

@interface DetailCell : UICollectionViewCell

-(void)refreshUI:(DetailModel *)model;

@end
