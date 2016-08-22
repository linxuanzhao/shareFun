//
//  MovieDetailOneCell.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "MovieDetailOneCell.h"


@implementation MovieDetailOneCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descLabel.font = [UIFont systemFontOfSize:14];
        self.descLabel.numberOfLines = 0;
        self.descLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.descLabel];
        
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageV.image = [UIImage imageNamed:@"down.png"];
        [self.contentView addSubview:self.imageV];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
