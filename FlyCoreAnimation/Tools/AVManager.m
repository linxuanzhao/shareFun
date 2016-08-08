//
//  AVManager.m
//  Movie
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import "AVManager.h"


@interface AVManager ()

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) UIView *playView;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation AVManager


+ (AVManager *)shareInstance
{
    static AVManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AVManager alloc] init];
    });
    return manager;
}

- (void)playWithUrlStr:(NSString *)urlStr playView:(UIView *)playView
{
    NSURL *url = [NSURL URLWithString:urlStr];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);

    playLayer.videoGravity = AVLayerVideoGravityResize;
    [playView.layer addSublayer:playLayer];
    [self.player play];

}


- (float)playDuration
{
    if (self.player.currentItem.duration.timescale == 0) {
        return 0;
    }
    
    return self.player.currentItem.duration.value / self.player.currentItem.duration.timescale;
;
}

- (float)currentTime
{
    if (self.player.currentItem.currentTime.timescale == 0) {
        return 0;
    }
    
    return self.player.currentItem.currentTime.value / self.player.currentItem.currentTime.timescale;
}

- (void)playProgress:(float)progress
{
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        CMTime time = self.player.currentItem.currentTime;
        
        time.value = self.player.currentTime.timescale *progress;
        
        [self.player pause];
        
        [self.player seekToTime:time completionHandler:^(BOOL finished) {
            [self.player play];
            
        }];
    }
   
    
    
}

- (void)loadProgressView:(UIProgressView *)progressView
{
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    self.progressView = progressView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSArray *loadedTimeRanges = [self.player.currentItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float startSenconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        float result = startSenconds + durationSeconds;
        CMTime duration = self.playerItem.duration;
        float totalDuration = CMTimeGetSeconds(duration);
        [self.progressView setProgress:result / totalDuration animated:NO];
    }
    

    
}

- (void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];

}






@end
