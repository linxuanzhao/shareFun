//
//  NewsDetailCell.m
//  YzlRadio
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import "NewsDetailCell.h"

@implementation NewsDetailCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(CompositeListModel *)model
{
    if (_model != model) {
        _model = model;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
