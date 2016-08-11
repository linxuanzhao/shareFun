//
//  ImageCell.m
//  YzlRadio
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageV = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_imageV];
        self.imageV.userInteractionEnabled = YES;
        
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        self.titleLable.userInteractionEnabled = YES;
        self.titleLable.font = [UIFont systemFontOfSize:14];
        self.titleLable.center = self.imageV.center;
        self.titleLable.textAlignment = UITextLayoutDirectionDown;
        self.titleLable.textColor = [UIColor whiteColor];
        [self.imageV addSubview:self.titleLable];
    }
    return self;
}


@end
