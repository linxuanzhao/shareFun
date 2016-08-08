//
//  LXZAVManager.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface LXZAVManager : NSObject

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;


+ (LXZAVManager *)shareInstance;

- (void)playWithUrlStr:(NSString *)urlStr playView:(UIView *)playView;

- (float)playDuration;

- (float)currentTime;

- (void)playProgress:(float)progress;

- (void)loadProgressView:(UIProgressView *)progressView;



@end
