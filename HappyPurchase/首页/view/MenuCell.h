//
//  MenuCell.h
//  HappyPurchase
//
//  Created by LD on 15/12/12.
//  Copyright © 2015年 LD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//判断当前cell是否处于选中状态
@property (nonatomic,assign) BOOL isSelecting;

-(void)setTitle:(NSString *)title;

@end
