//
//  MovieAnimation.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/20.
//  Copyright © 2016年 he. All rights reserved.
//

#import "MovieAnimationko.h"

@implementation MovieAnimationko

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    
//    // Add the toView to the container
//    UIView* containerView = [transitionContext containerView];
//    UIView *toView = toVC.view;
//    UIView *fromView = fromVC.view;
//    
//    [containerView addSubview:toView];
//    [containerView sendSubviewToBack:toView];
    
//    CGSize size = toView.frame.size;
//    
//    NSMutableArray *snapshots = [NSMutableArray new];
//    
    
    // snapshot the from view, this makes subsequent snaphots more performant
  //  UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    
    // create a snapshot for each of the exploding pieces
    
  //  [containerView sendSubviewToBack:fromView];
    
    // animate
  //  NSTimeInterval duration = [self transitionDuration:transitionContext];
//    [UIView transitionFromView:fromView toView:toView duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
//           [transitionContext completeTransition:YES];
//
    /*
    toView.frame = CGRectMake(0, 0, 0, 0);
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toVC.view.frame = CGRectMake(0, 0, SCWI, SCHI);
                     } completion:^(BOOL finished) {
                         // 5. Tell context that we completed.
                         [transitionContext completeTransition:YES];
                     }];
     */
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    CGSize size = toView.frame.size;
    
    NSMutableArray *snapshots = [NSMutableArray new];
    
    CGFloat xFactor = 10.0f;
    CGFloat yFactor = xFactor * size.height / size.width;
    
    // snapshot the from view, this makes subsequent snaphots more performant
    UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    
    // create a snapshot for each of the exploding pieces
    for (CGFloat x=0; x < size.width; x+= size.width / xFactor) {
        for (CGFloat y=0; y < size.height; y+= size.height / yFactor) {
            CGRect snapshotRegion = CGRectMake(x, y, size.width / xFactor, size.height / yFactor);
            UIView *snapshot = [fromViewSnapshot resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame = snapshotRegion;
            [containerView addSubview:snapshot];
            [snapshots addObject:snapshot];
        }
    }
    
    [containerView sendSubviewToBack:fromView];
    
    // animate
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    /*
    [UIView animateWithDuration:duration animations:^{
        for (UIView *view in snapshots) {
            CGFloat xOffset = [self randomFloatBetween:-100.0 and:100.0];
            CGFloat yOffset = [self randomFloatBetween:-100.0 and:100.0];
            view.frame = CGRectOffset(view.frame, xOffset, yOffset);
            view.alpha = 0.0;
            view.transform = CGAffineTransformScale(CGAffineTransformMakeRotation([self randomFloatBetween:-10.0 and:10.0]), 0.01, 0.01);
        }
    } completion:^(BOOL finished) {
        for (UIView *view in snapshots) {
            [view removeFromSuperview];
        }
     }];
     */
    [UIView transitionFromView:fromView toView:toView duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    

}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}
   




@end
