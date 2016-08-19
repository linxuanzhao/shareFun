//
//  ListTableViewCell.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompositeListModel.h"

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewA;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *countLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLable;

@property (nonatomic, strong) CompositeListModel *model;

@end
