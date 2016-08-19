//
//  RadioPlayViewController.m
//  YzlRadio
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 yzl. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RadioPlayViewController.h"
#import "YZLAVManager.h"
#import "ListModel.h"
#import "UIImageView+WebCache.h"
#import "XRCarouselView.h"
#import "DBManager.h"




@interface RadioPlayViewController ()<XRCarouselViewDelegate>
@property (nonatomic, strong) YZLAVManager *avManager;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) IBOutlet UILabel *curTime;

@property (weak, nonatomic) IBOutlet UILabel *allTime;



@property (weak, nonatomic) IBOutlet UIImageView *scImageView;

@property (nonatomic, strong) XRCarouselView *carouselView;

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UILabel *marLabel;


@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isPlay;

@property (weak, nonatomic) IBOutlet UISlider *VolumeSlider;
@property (nonatomic, strong) DBManager *manager;







@end

@implementation RadioPlayViewController

/*
-(void)changeImage
{
    [self.slider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    ListModel *model = self.urls[self.number];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverLarge]];
    self.imageV.layer.cornerRadius = 45;
    self.imageV.layer.masksToBounds = YES;
    
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    baseAnimation.toValue = @(M_PI * 200);
    baseAnimation.duration = 5000;
    baseAnimation.fillMode = kCAFillModeForwards;
    baseAnimation.removedOnCompletion = NO;
    [_imageV.layer addAnimation:baseAnimation forKey:@"rotate"];
    
}
 */

-(void)imageScrollView
{
    self.carouselView = [[XRCarouselView alloc]initWithFrame:self.scImageView.bounds];
    
    UIImage *image1 = [UIImage imageNamed:@"a1.JPG"];
    UIImage *image2 = [UIImage imageNamed:@"a2.JPG"];
    UIImage *image3 = [UIImage imageNamed:@"a3.JPG"];
    UIImage *image4 = [UIImage imageNamed:@"a4.JPG"];
    
    NSArray *arr1  = @[image1,image2,image3,image4];
    self.carouselView.imageArray = arr1;
    self.carouselView.delegate = self;
    self.carouselView.time = 5;
    self.carouselView.pagePosition = PositionHide;
    [self.scImageView addSubview:self.carouselView];
    
}

-(void)chanageSliderImage
{
    self.slider.value = 0;
    self.VolumeSlider.value = 1.0;
    
    [self.slider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    [self.VolumeSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeTitleView];
    [self chanageSliderImage];
    [self addBackground];
    //[self imageScrollView];
    self.manager = [DBManager shareInstance];
    


    self.avManager = [YZLAVManager shareInstance];
    
    NSMutableArray *arr =[NSMutableArray array];
    
    for (ListModel *model in self.urls) {
        [arr addObject:model.playUrl64];
    }
    [self.avManager setPlayList:arr flag:self.number];
      NSLog(@"%ld",self.urls.count);
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    
//    self.progressView.tintColor = [UIColor blackColor];
    [self.avManager.avPlay play];

    
    [self.avManager.playItem addObserver:self forKeyPath:@"loadedTimeRanges"  options:NSKeyValueObservingOptionNew context:nil];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
 

}

-(void)rightBtnAction:(id)sender
{
    if (sender) {
        MBProgressHUD *textHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        textHud.mode = MBProgressHUDModeText;
        textHud.labelText = @"收藏成功";
        [textHud hide:YES afterDelay:1];
        [self.manager addRadio:self.collectModel];
        
    }
    else{
        MBProgressHUD *textHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        textHud.mode = MBProgressHUDModeText;
        textHud.labelText = @"取消收藏";
        [textHud hide:YES afterDelay:1];
        [self.manager deleteRadio:self.collectModel];
    }

    
}
/*
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        if (self.avManager.playItem.loadedTimeRanges) {
            NSArray *loadedTimeRanges = [self.avManager.avPlay.currentItem loadedTimeRanges];
            CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
            float startSenconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            float result = startSenconds + durationSeconds;
            CMTime duration = self.avManager.playItem.duration;
            float totalDuration = CMTimeGetSeconds(duration);
//            [self.progressView setProgress:result / totalDuration animated:NO];
        }
    }
}
*/
-(void)changeItem
{
    self.navigationController.navigationBar.hidden = YES;
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.navigationController.navigationBar.hidden = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.navigationController.navigationBar.hidden = YES;
//    });
//    
//}

-(void)changeTitleView
{
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 180, 50)];
    self.navigationItem.titleView = self.view1;
    self.marLabel = [[UILabel alloc]initWithFrame:CGRectMake(375, 10, 0, 0)];
    self.marLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view1 addSubview:self.marLabel];
    self.marLabel.text = self.name;
    [self.marLabel sizeToFit];
    self.view1.clipsToBounds = YES;
    [UIView beginAnimations:@"Marquee" context:NULL];
    [UIView setAnimationDuration:10];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:10000];
    CGRect frame = self.marLabel.frame;
    frame.origin.x = -frame.size.width;
    self.marLabel.frame = frame;
    [UIView commitAnimations];

}

-(void)changeTime
{
    float sec = self.avManager.playDuration - self.avManager.curuentTime;
    NSInteger a = sec / 60;
    NSInteger b = (int)sec % 60;
    self.allTime.text  = [NSString stringWithFormat:@"%02ld:%02ld",a,b];
    float sec2 = self.avManager.curuentTime;
    NSInteger c = sec2/60;
    NSInteger d = (int)sec2%60;
    self.curTime.text = [NSString stringWithFormat:@"%02ld:%02ld",c,d];
    self.slider.maximumValue = self.avManager.playDuration;
    self.slider.value = self.avManager.curuentTime;
}


//播放暂停
- (IBAction)startAndStop:(id)sender
{
    if (!self.isPlay) {
       // [_timer setFireDate:[NSDate distantPast]];
        [self.avManager.avPlay play];
        [self.startBtn setImage:[UIImage imageNamed:@"Unknown-4"] forState:UIControlStateNormal];
        self.isPlay = YES;
    }else{
        [self.startBtn setImage:[UIImage imageNamed:@"Unknown-5"] forState:UIControlStateNormal];
        [self.avManager.avPlay pause];
       // [_timer setFireDate:[NSDate distantFuture]];
        self.isPlay = NO;
    }
    //[self.avManager playWithBtn:nil];
}
//上一首
- (IBAction)back:(id)sender
{
    self.number--;
    if (self.number < 0) {
        self.number = self.urls.count-1;
    }
    [self.avManager above];
}
//下一首
- (IBAction)next:(id)sender
{
    self.number++;
    if (self.number == self.urls.count) {
        self.number = 0;
    }
    [self.avManager next];
}



//歌曲进度条
- (IBAction)changeProgress:(id)sender {
    [self.avManager.avPlay pause];
    [self.avManager playProgress:self.slider.value];
    [self.avManager.avPlay play];
}

//控制音量的大小
- (IBAction)changeVolumeBtnAction:(id)sender
{
    self.avManager.avPlay.volume = self.VolumeSlider.value;
}

-(void)addBackground
{
    
    CAEmitterLayer * snowEmitterLayer = [CAEmitterLayer layer];
    //发射源位置
    snowEmitterLayer.emitterPosition = CGPointMake(100, -30);
    //发射源大小
    snowEmitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    //发射模式
    snowEmitterLayer.emitterMode = kCAEmitterLayerPoints;
    snowEmitterLayer.emitterShape = kCAEmitterLayerLine;
    //    snowEmitterLayer.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (__bridge id)[UIImage imageNamed:@"樱花瓣2"].CGImage;
    
    // 花瓣缩放比例
    snowCell.scale = 0.02;
    snowCell.scaleRange = 0.2;
    
    // 每秒产生的花瓣数量
    snowCell.birthRate = 1;
    //粒子生命周期
    snowCell.lifetime = 80;
    
    // 每秒花瓣变透明的速度
    snowCell.alphaSpeed = -0.01;
    
    // 秒速“五”厘米～～
    snowCell.velocity = 40;
    //粒子速度范围
    snowCell.velocityRange = 60;
    
    // 花瓣掉落的角度范围
    snowCell.emissionRange = M_PI;
    
    // 花瓣旋转的速度
    snowCell.spin = M_PI_4;
    
    // 阴影的 不透明 度
    snowEmitterLayer.shadowOpacity = 1;
    
    // 阴影化开的程度（就像墨水滴在宣纸上化开那样）
    snowEmitterLayer.shadowRadius = 8;
    
    // 阴影的偏移量
    snowEmitterLayer.shadowOffset = CGSizeMake(3, 3);
    
    // 阴影的颜色
    snowEmitterLayer.shadowColor = [[UIColor whiteColor] CGColor];
    
    
    snowEmitterLayer.emitterCells = [NSArray arrayWithObject:snowCell];
    
    [self.view.layer addSublayer:snowEmitterLayer];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_timer invalidate];
}

- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index
{
    NSLog(@"图片被点击了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
