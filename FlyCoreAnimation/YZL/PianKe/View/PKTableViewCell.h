//
//  PKTableViewCell.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/16.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKListModel.h"

@interface PKTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewAAA;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewBBB;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (nonatomic, strong) PKListModel *model;

@end
