//
//  CompositeListCell.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompositeListModel.h"

@interface CompositeListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageviewA;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *countLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBBB;
@property (weak, nonatomic) IBOutlet UILabel *dayLable;

@property (nonatomic, strong) CompositeListModel *PPmodel;

@end
