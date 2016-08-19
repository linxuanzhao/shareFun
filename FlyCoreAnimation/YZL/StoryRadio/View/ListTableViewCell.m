//
//  ListTableViewCell.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 he. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

- (void)awakeFromNib {
    
}
-(void)setModel:(CompositeListModel *)model
{
    if (_model !=model ) {
        _model = model;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
