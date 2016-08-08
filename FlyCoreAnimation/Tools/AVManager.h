//
//  AVManager.h
//  Movie
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AVManager : NSObject

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;


+ (AVManager *)shareInstance;

- (void)playWithUrlStr:(NSString *)urlStr playView:(UIView *)playView;

- (float)playDuration;

- (float)currentTime;

- (void)playProgress:(float)progress;

- (void)loadProgressView:(UIProgressView *)progressView;



@end
