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
        // imageView
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(SCWI * 0.04);
            make.top.equalTo(self.contentView.mas_top).offset(SCHI / 667 * 120 * 0.125);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-SCHI / 667 * 120 * 0.125);
            make.right.equalTo(self.contentView.mas_right).offset(-SCWI * 0.76);
        }];
        
        // nameLabel
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;// 根据label宽度, 调整字体大小
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageV.mas_right).offset(SCWI * 0.027);
            make.top.equalTo(self.contentView.mas_top).offset(SCHI / 667 * 120 * 0.125);
            make.right.equalTo(self.contentView.mas_right).offset(-SCWI * 0.187);
            make.height.mas_equalTo(SCHI / 667 * 120 * 0.167);
        }];
        
        // highlightLabel
        self.highlightLabel = [[UILabel alloc] init];
        self.highlightLabel.font = [UIFont systemFontOfSize:12];
        self.highlightLabel.textAlignment = NSTextAlignmentLeft;
        self.highlightLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.contentView addSubview:self.highlightLabel];
        [self.highlightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageV.mas_right).offset(SCWI * 0.027);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(SCHI / 667 * 120 * 0.125);
            make.right.equalTo(self.contentView.mas_right).offset(-SCWI * 0.187);
            make.height.mas_equalTo(SCHI / 667 * 120 * 0.167);
        }];
        
        // playCountL
        self.playCountL = [[UILabel alloc] init];
        self.playCountL.font = [UIFont systemFontOfSize:12];
        self.playCountL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.playCountL];
        [self.playCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageV.mas_right).offset(SCWI * 0.027);
            make.top.equalTo(self.highlightLabel.mas_bottom).offset(SCHI / 667 * 120 * 0.083);
            make.right.equalTo(self.contentView.mas_right).offset(-SCWI * 0.187);
            make.height.mas_equalTo(SCHI / 667 * 120 * 0.167);
        }];
        
        // scoreLabel
        self.scoreLabel = [[UILabel alloc] init];
        self.scoreLabel.font = [UIFont systemFontOfSize:14];
        self.scoreLabel.textColor = [UIColor orangeColor];
        self.scoreLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.scoreLabel];
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(SCHI / 667 * 120 * 0.167);
            make.right.equalTo(self.contentView.mas_right).offset(-SCWI * 0.027);
            make.height.mas_equalTo(SCHI / 667 * 120 * 0.167);
            make.width.mas_equalTo(SCWI * 0.12);
        }];
        
    }
    return self;
}

- (void)setMovie:(Movie *)movie
{
    if (_movie != movie) {
        _movie = movie;
        self.nameLabel.text = movie.name;
        self.highlightLabel.text = movie.highlight;
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
