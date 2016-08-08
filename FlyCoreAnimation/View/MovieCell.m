//
//  MovieCell.m
//  Movie
//
//  Created by linxuanzhao on 16/8/2.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+WebCache.h"

@implementation MovieCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 20)];
        [self addSubview:self.imageV];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width, 20)];
        self.nameL.font = [UIFont boldSystemFontOfSize:15];
        self.nameL.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.nameL];
    }
    return self;
}

- (void)setMovie:(Movie *)movie
{
    if (_movie != movie) {
        _movie = movie;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:movie.logo520692]];
        self.nameL.text = movie.name;
        
    }
}



@end
