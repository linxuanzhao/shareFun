//
//  UIViewController+Trainsition.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 he. All rights reserved.
//

#import "UIViewController+Trainsition.h"
#import <objc/runtime.h>

@implementation UIViewController (Trainsition)

- (CGFloat)targetHeight
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}


- (void)setTargetHeight:(CGFloat)targetHeight
{
    objc_setAssociatedObject(self, @selector(targetHeight), @(targetHeight), OBJC_ASSOCIATION_RETAIN);
}



- (UIView *)targetView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTargetView:(UIView *)targetView
{
    objc_setAssociatedObject(self, @selector(targetView), targetView, OBJC_ASSOCIATION_RETAIN);
}




@end
