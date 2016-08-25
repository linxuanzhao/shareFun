//
//  MovieAnimation.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 he. All rights reserved.
//

#import "MovieAnimation.h"
#import "UIViewController+Trainsition.h"

@implementation MovieAnimation

- (instancetype)initWithAnimateType:(AnimationType)type andDuration:(NSTimeInterval)duration{
    if (self = [super init]) {
        _animationType = type;
        _duration = duration;
    }
    return self;
}

// 协议方法

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return _duration;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.animationType == animationPush) {
        [self pushAnimateWithAnimateTransition:transitionContext];
    }else{
        [self popAnimateWithAnimateTransition:transitionContext];
    }
}

- (void)pushAnimateWithAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //起始位置
    CGRect originFrame = [fromVC.targetView convertRect:fromVC.targetView.bounds toView:fromVC.view];
    //动画移动的视图镜像
    UIView *customView = [self customSnapshoFromView:fromVC.targetView];
    customView.frame = originFrame;
    
    //移动的目标位置
    CGRect finishFrame = [toVC.targetView convertRect:toVC.targetView.bounds toView:toVC.view];
    
    UIView *containView = [transitionContext containerView];
    
    //背景视图 灰色高度
    CGFloat height = CGRectGetMidY(finishFrame);
    toVC.targetHeight = height;
    
    //背景视图 灰色
    UIView *backgray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCWI, SCHI)];
    backgray.backgroundColor = [UIColor lightGrayColor];
    //背景视图 白色
    UIView *backwhite = [[UIView alloc] initWithFrame:CGRectMake(0, height, SCWI, SCHI - height)];
    backwhite.backgroundColor = [UIColor whiteColor];
    
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [containView addSubview:toVC.view];
    [containView addSubview:backgray];
    [backgray addSubview:backwhite];
    [containView addSubview:customView];
    
    //动画
    [UIView animateWithDuration:_duration/3 animations:^{
        customView.frame = finishFrame;
        customView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        if (finished) {
            
            [UIView animateWithDuration:_duration/3 animations:^{
                
                customView.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:_duration/3 animations:^{
                        customView.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [backgray removeFromSuperview];
                            [customView removeFromSuperview];
                            [transitionContext completeTransition:YES];
                        }
                    }];
                    
                    [self addPathAnimateWithView:backgray fromPoint:customView.center];
                    
                }
            }];
            
            
            
        }
    }];
}
- (void)popAnimateWithAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //起始位置
    CGRect originFrame = [fromVC.targetView convertRect:fromVC.targetView.bounds toView:fromVC.view];
    
    //动画移动的视图镜像
    UIView *customView = [self customSnapshoFromView:fromVC.targetView];
    customView.frame = originFrame;
    
    //移动的目标位置
    CGRect finishFrame = [toVC.targetView convertRect:toVC.targetView.bounds toView:toVC.view];
    
    UIView *containView = [transitionContext containerView];
    
    //背景视图 灰色
    UIView *backGray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCWI, SCHI)];
    backGray.backgroundColor = [UIColor lightGrayColor];
    //背景视图 白色
    UIView *backWhite = [[UIView alloc] initWithFrame:CGRectMake(0, fromVC.targetHeight, SCWI, SCHI - fromVC.targetHeight)];
    backWhite.backgroundColor = [UIColor whiteColor];
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [containView addSubview:toVC.view];
    [containView addSubview:fromVC.view];
    [containView addSubview:backGray];
    [backGray addSubview:backWhite];
    [containView addSubview:customView];
    
    [self addPathAnimateWithView:backGray fromPoint:customView.center];
    
    [UIView animateWithDuration:_duration/3 delay:_duration/3 options:UIViewAnimationOptionTransitionNone animations:^{
        customView.frame = finishFrame;
        customView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [fromVC.view removeFromSuperview];
            
            [UIView animateWithDuration:_duration/3 animations:^{
                backGray.alpha = 0.0;
                customView.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [backGray removeFromSuperview];
                    [customView removeFromSuperview];
                    [transitionContext completeTransition:YES];
                }
            }];
        }
    }];
}

//加入收合动画
- (void)addPathAnimateWithView:(UIView *)toView fromPoint:(CGPoint)point{
    //create path
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCWI, SCHI)];
    //create path
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:0.1 startAngle:0 endAngle:2*M_PI clockwise:NO]];
    
    CGFloat radius = point.y > 0?SCHI*3/4: SCHI*3/4-point.y;
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCWI, SCHI)];
    [path2 appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:0 endAngle:2*M_PI clockwise:NO]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //shapeLayer.path = path.CGPath;
    toView.layer.mask = shapeLayer;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = _animationType == animationPush? (__bridge id)path.CGPath:(__bridge id)path2.CGPath;
    pathAnimation.toValue   = _animationType == animationPush? (__bridge id)path2.CGPath:(__bridge id)path.CGPath;
    pathAnimation.duration  = _duration/3;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [shapeLayer addAnimation:pathAnimation forKey:@"pathAnimate"];
}

//产生targetView镜像
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}



@end
