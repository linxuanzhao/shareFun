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
        self.descLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        NSLog(@"%f", self.descLabel.font.leading);
        self.descLabel.numberOfLines = 0;
        [self.contentView addSubview:self.descLabel];
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
