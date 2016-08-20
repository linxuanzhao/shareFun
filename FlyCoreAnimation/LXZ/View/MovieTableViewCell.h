//
//  MovieTableViewCell.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/16.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *playCountL;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *highlightLabel;

@property (nonatomic, strong) Movie *movie;

@end
