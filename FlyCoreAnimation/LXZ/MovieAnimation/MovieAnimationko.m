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
 
    [UIView transitionFromView:fromView toView:toView duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    

}


   




@end
