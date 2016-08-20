//
//  CompositeListCell.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 he. All rights reserved.
//

#import "CompositeListCell.h"

@implementation CompositeListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setPPmodel:(CompositeListModel *)PPmodel
{
    if (_PPmodel != PPmodel ) {
        _PPmodel = PPmodel;
        [self.imageviewA sd_setImageWithURL:[NSURL URLWithString:self.PPmodel.coverLarge]];
        self.timeLable.text = self.PPmodel.title;
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
