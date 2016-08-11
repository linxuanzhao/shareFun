//
//  MovieAnimation.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum: NSInteger{
    animationPush = 0,
    animationPop = 1,
    
}AnimationType;

@interface MovieAnimation : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithAnimateType:(AnimationType)type andDuration:(NSTimeInterval)duration;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) AnimationType animationType;
  

@end
