//
//  MovieTableViewCell.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/16.
//  Copyright © 2016年 he. All rights reserved.
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 100)];
        [self.contentView addSubview:self.imageV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 200, 30)];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.nameLabel];
        
        self.playCountL = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 300, 20)];
        self.playCountL.font = [UIFont systemFontOfSize:12];
        self.playCountL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.playCountL];
        
        self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCWI - 50, 20, 70, 30)];
        self.scoreLabel.font = [UIFont systemFontOfSize:15];
        self.scoreLabel.textColor = [UIColor orangeColor];
        [self.contentView addSubview:self.scoreLabel];
    }
    return self;
}

- (void)setMovie:(Movie *)movie
{
    if (_movie != movie) {
        _movie = movie;
        self.nameLabel.text = movie.name;
        self.playCountL.text = movie.screenings;
        self.scoreLabel.text = [NSString stringWithFormat:@"%@分", movie.grade];
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:movie.logo520692]];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
