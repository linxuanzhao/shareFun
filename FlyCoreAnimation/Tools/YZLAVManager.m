//
//  YZLAVManager.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 he. All rights reserved.
//

#import "YZLAVManager.h"
#import <AVFoundation/AVFoundation.h>


@interface YZLAVManager ()
//判断现在是否正咋播放
@property (nonatomic, assign) BOOL isplaying;
//播放下标的属性
@property (nonatomic, assign) NSInteger playIndex;

@property (nonatomic, strong) NSTimer *timer;

@end


@implementation YZLAVManager

-(NSMutableArray *)musicUrls
{
    if (!_musicUrls) {
        _musicUrls = [NSMutableArray array];
    }
    return _musicUrls;
}

//创建一个播放音乐的单列
+(YZLAVManager *)shareInstance{
    static YZLAVManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YZLAVManager alloc]init];
    });
    return manager;
}
//添加音乐的播放队列(文件)
-(void)setPlayList:(NSMutableArray *)playList flag:(NSInteger)number
{
    //将数组中的音频网址取出来保存
    //    for (DetailModel *detail in playList) {
    //        [self.musicUrls addObject:detail.musicUrl];
    //    }
    self.musicUrls = [playList copy];
    //保存一下播放的下标
    self.playIndex = number;
    //创建播放器
    NSString *urls = playList[number];
    NSURL *url = [NSURL URLWithString:urls];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    self.avPlay = [[AVPlayer alloc]initWithPlayerItem:item];
    
    NSTimer *t2 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autonext) userInfo:nil repeats:YES];
    [t2 fire];
    
}
-(void)autonext{
    if ([self curuentTime] == [self playDuration]) {
        [self next];
    }
}
//上一首
-(void)above{
    self.playIndex--;
    if (self.playIndex == -1) {
        self.playIndex = self.musicUrls.count - 1;
    }
    NSURL *url = [NSURL URLWithString:self.musicUrls[self.playIndex]];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    [self.avPlay replaceCurrentItemWithPlayerItem:item];
    
}
//下一首
-(void)next
{
    self.playIndex++;
    if (self.playIndex == self.musicUrls.count - 1) {
        self.playIndex = 0;
    }
    NSURL *url = [NSURL URLWithString:self.musicUrls[self.playIndex]];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    [self.avPlay replaceCurrentItemWithPlayerItem:item];
}
//播放或者涨停
-(void)playWithBtn:(UIButton *)btn{
    
    if (self.isplaying) {
        [self.avPlay pause];
        self.isplaying = 0;
        // [btn setImage:[UIImage imageNamed:@"Unknown-5"] forState:UIControlStateNormal];
        
    }else{
        [self.avPlay play];
        self.isplaying = 1;
        
        //[btn setImage:[UIImage imageNamed:@"Unknown-4"] forState:UIControlStateNormal];
        
    }
    
}
//改变音乐播放进度
-(void)playProgress:(float)progress
{
    CMTime time = self.avPlay.currentItem.currentTime;
    time.value = self.avPlay.currentTime.timescale * progress;
    //跳到某个时间点执行
    [self.avPlay pause];
    [self.avPlay seekToTime:time];
    self.isplaying = NO;
    [self.avPlay play];
    
    
}
//音频文件的总时长
-(float)playDuration{
    
    if (self.avPlay.currentItem.duration.timescale == 0) {
        return 0;
    }
    float second = self.avPlay.currentItem.duration.value/self.avPlay.currentItem.duration.timescale;
    return second;
}


//当前播放时长
-(float)curuentTime
{
    if (self.avPlay.currentItem.duration.timescale == 0) {
        return 0;
    }
    return self.avPlay.currentItem.currentTime.value/self.avPlay.currentItem.currentTime.timescale;
    
}



@end
