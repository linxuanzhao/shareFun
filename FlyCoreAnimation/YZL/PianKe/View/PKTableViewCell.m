//
//  PKTableViewCell.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/16.
//  Copyright © 2016年 he. All rights reserved.
//

#import "PKTableViewCell.h"

@implementation PKTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(PKListModel *)model
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
