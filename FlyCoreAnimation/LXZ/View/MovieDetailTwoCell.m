//
//  MovieDetailTwoCell.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 he. All rights reserved.
//

#import "MovieDetailTwoCell.h"


@implementation MovieDetailTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCWI * 0.04, SCHI * 0.015, 200, SCHI * 0.03)];
        self.nameLabel.text = @"剧照";
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.nameLabel];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SCWI * 0.04, SCHI * 0.06, SCWI - 30, SCHI * 0.15)];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:self.scrollView];
     
        
    }
    return self;
}

- (NSArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSArray array];
    }
    return _photoArray;
}


- (void)layoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(SCWI * 0.32 * self.photoArray.count, SCHI * 0.15);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
