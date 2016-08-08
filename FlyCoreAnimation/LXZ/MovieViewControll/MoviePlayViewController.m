//
//  MoviePlayViewController.m
//  Movie
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import "MoviePlayViewController.h"
#import "LXZAVManager.h"
#import "AppDelegate.h"

@interface MoviePlayViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) LXZAVManager *avManager;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *startLabel;

@property (nonatomic, strong) UILabel *endLabel;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSTimer *hiddenTimer;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;


@end

@implementation MoviePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.avManager = [LXZAVManager shareInstance];
    [self.avManager playWithUrlStr:self.movieUrlStr playView:self.view];

    [self createPlayControlView];
    [self createGestureRecognizer];
    
    [self AutoHiddenPlayControl];
   
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(chanageTime) userInfo:nil repeats:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePause) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

- (void)movieDidFinish
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.timer invalidate];
    self.timer = nil;
}


- (void)moviePause
{
    self.playBtn.selected = YES;
    [self disapper];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)chanageTime
{
    float timeLeft = self.avManager.playDuration - self.avManager.currentTime;
    NSInteger a = timeLeft / 60;
    NSInteger b = (NSInteger)timeLeft % 60;
    self.endLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", a, b];
    
    float startToNowTime = self.avManager.currentTime;
    NSInteger c = startToNowTime / 60;
    NSInteger d = (NSInteger)startToNowTime % 60;
    self.startLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", c, d];
    
    self.slider.maximumValue = self.avManager.playDuration;
    self.slider.value = self.avManager.currentTime;
    
    if (self.avManager.player.status == AVPlayerStatusReadyToPlay) {
        [self.activityView stopAnimating];
    }
    else
    {
        [self.activityView startAnimating];
    }
    
}





- (void)createPlayControlView
{
    // 创建控制播放页面
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backView];
    
    // 创建顶部视图
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 60)];
    self.topView.backgroundColor = [UIColor colorWithRed:50 / 255.5 green:50 / 255.5 blue:50 / 255.5 alpha:0.8];
    [self.backView addSubview:self.topView];
    
    // 创建返回按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(10, 15, 50, 50);
    [self.backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.backBtn];
    
    // 创建播放/暂停按钮
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(0, 0, 50, 50);
    self.playBtn.center = CGPointMake(self.view.center.y, self.view.center.x);
    [self.playBtn addTarget:self action:@selector(playAndPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateSelected];
    self.playBtn.alpha = 0;
    [self.backView addSubview:self.playBtn];
    
    // 创建底部视图
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.width - 60, [UIScreen mainScreen].bounds.size.height, 60)];
    self.bottomView.backgroundColor = [UIColor colorWithRed:50 / 255.5 green:50 / 255.5 blue:50 / 255.5 alpha:1];
    [self.backView addSubview:self.bottomView];
    
    // 当前播放时间
    self.startLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 45, 20)];
    self.startLabel.text = @"00:00";
    self.startLabel.textColor = [UIColor whiteColor];
    self.startLabel.font = [UIFont systemFontOfSize:14];
    [self.bottomView addSubview:self.startLabel];
    
    // 总时长
    self.endLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width - 10 - 45, 20, 45, 20)];
    self.endLabel.text = @"04:30";
    self.endLabel.textColor = [UIColor whiteColor];
    self.endLabel.font = [UIFont systemFontOfSize:14];
    [self.bottomView addSubview:self.endLabel];
    
    // 缓冲条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(10 + 45 + 10, self.bottomView.frame.size.height / 2 - 1, [UIScreen mainScreen].bounds.size.height - 65 * 2, 2);
    self.progressView.tintColor = [UIColor blackColor];
    [self.bottomView addSubview:self.progressView];
    [self.avManager loadProgressView:self.progressView];

    
    // 进度滑条
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height - 65 * 2, 30)];
    self.slider.center = self.progressView.center;
    self.slider.minimumTrackTintColor = [UIColor whiteColor];
    self.slider.maximumTrackTintColor = [UIColor clearColor];
    [self.slider setThumbImage:[UIImage imageNamed:@"dot.png"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(changeProgress) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(finishChangeProgress) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.slider];
    
    // 系统菊花
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activityView.center = self.backView.center;
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];

    
    
    
    
}

- (void)finishChangeProgress
{
    self.playBtn.selected = NO;
}

- (void)changeProgress
{
    self.playBtn.selected = YES;
    [self.avManager playProgress:self.slider.value];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.avManager.player pause];
    
}


- (void)createGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disapper)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;

}

- (void)disapper
{

    [UIView animateWithDuration:0.5 animations:^{
            
        if (self.backView.alpha == 0){
            self.backView.alpha = 1;
            self.playBtn.alpha = 1;
        }
        
        else{
            self.backView.alpha = 0;
            
        }
            
    } completion:^(BOOL finished){
        
            [self removeHiddenTimer];
            if (self.backView.alpha == 1 && !self.playBtn.selected) {
                [self AutoHiddenPlayControl];
            }
        }];
 
}

- (void)AutoHiddenPlayControl
{
    self.hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(disapper) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.hiddenTimer forMode:NSRunLoopCommonModes];
}



- (void)removeHiddenTimer
{
    if (self.hiddenTimer) {
        [self.hiddenTimer invalidate];
        self.hiddenTimer = nil;
    }
}



- (void)playAndPause:(UIButton *)button
{
    self.playBtn = button;
    if (button.selected) {
        [self.avManager.player play];
        [self AutoHiddenPlayControl];
    }
    else
    {
        [self.avManager.player pause];
        [self removeHiddenTimer];
    }
   
    button.selected = !button.selected;
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.bottomView] || [touch.view isDescendantOfView:self.topView]) {
        
        return NO;
    }
    return YES;
}

#pragma mark 屏幕旋转代码
- (BOOL)shouldAutorotate{
    return NO;
} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
} //当前viewcontroller支持哪些转屏方向

// 一开始屏幕转转方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden
{
    return YES; // 返回NO表示要显示，返回YES将hiden
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
