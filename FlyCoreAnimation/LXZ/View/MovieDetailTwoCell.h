//
//  MovieDetailTwoCell.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface MovieDetailTwoCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *photoArray;

@end
