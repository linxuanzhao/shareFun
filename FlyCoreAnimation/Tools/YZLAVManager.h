//
//  YZLAVManager.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface YZLAVManager : NSObject

@property (nonatomic, strong) AVPlayer *avPlay;

@property (nonatomic, strong) NSMutableArray *musicUrls;

@property (nonatomic, strong) AVPlayerItem *playItem;

//创建一个播放音乐的单列
+(YZLAVManager *)shareInstance;
//添加音乐的播放队列(文件)
-(void)setPlayList:(NSMutableArray *)playList flag:(NSInteger)number;
//上一首
-(void)above;
//下一首
-(void)next;
//播放或者涨停
-(void)playWithBtn:(UIButton *)btn;
//改变音乐播放进度
-(void)playProgress:(float)progress;
//音频文件的总时长
-(float)playDuration;
//音频文件的当前时长
-(float)curuentTime;



@end
