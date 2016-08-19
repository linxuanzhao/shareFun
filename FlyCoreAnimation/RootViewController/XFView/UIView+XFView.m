//
//  UIView+XFView.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/15.
//  Copyright © 2016年 he. All rights reserved.
//

#import "UIView+XFView.h"

@implementation UIView (XFView)



-(void)drawRect:(CGRect)rect image:(NSString *)imageStr{
    [self drawRect:rect];
    UIImage *oldImage = [UIImage imageNamed:imageStr];
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [oldImage drawAtPoint:CGPointZero];
//    [oldImage drawInRect:self.frame];
    
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.backgroundColor = [UIColor colorWithPatternImage:newImage];

}
@end
