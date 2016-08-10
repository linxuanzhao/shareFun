//
//  XFAnnotation.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "XFAnnotation.h"

@implementation XFAnnotation

-(instancetype)init{
    if (self = [super init]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        btn.frame = CGRectMake(0, 0, 50, 50);
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDragInside];
        [self addSubview:btn];
    }
    return self;
}

-(void)click{
    NSLog(@"BtnClick");
}
@end
