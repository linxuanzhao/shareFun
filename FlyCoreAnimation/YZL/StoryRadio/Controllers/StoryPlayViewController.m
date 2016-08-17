//
//  StoryPlayViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 he. All rights reserved.
//

#import "StoryPlayViewController.h"
#import "YZLAVManager.h"
#import "LisstModel.h"
#import "UIImageView+WebCache.h"


@interface StoryPlayViewController ()
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIImageView *RotateImageView;
@property (weak, nonatomic) IBOutlet UILabel *curTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *residualBtnAction;
@property (nonatomic, strong) YZLAVManager *avManager;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UILabel *marLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isPlay;
@property (weak, nonatomic) IBOutlet UIButton *startAndStopBtn;


@end

@implementation StoryPlayViewController

-(void)changeSliderImage
{
    self.volumeSlider.minimumValue = 0.0;
    self.volumeSlider.maximumValue = 1.0;
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeSliderImage];
    [self changeTitleView];
    //[self changeNavigationBar];
    [self addBackground];
    
    
    LisstModel *model = self.storyUrls[self.indexPath];
    [self.RotateImageView sd_setImageWithURL:[NSURL URLWithString:model.coverLarge]];
    
    self.avManager = [YZLAVManager shareInstance];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (LisstModel *model in self.storyUrls) {
        [arr addObject:model.playUrl64];
    }
    [self.avManager setPlayList:arr flag:self.indexPath];
    [self.avManager.avPlay play];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeTimeLable) userInfo:nil repeats:YES];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.navigationController.navigationBar.hidden = YES;
//    });
}
//-(void)changeNavigationBar
//{
//    self.navigationController.navigationBar.hidden = YES;
//}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.navigationController.navigationBar.hidden = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.navigationController.navigationBar.hidden = YES;
//    });
//    
//}

-(void)changeTimeLable
{
    float sec = self.avManager.playDuration - self.avManager.curuentTime;
    NSInteger a = sec / 60;
    NSInteger b = (int)sec % 60;
    self.residualBtnAction.text  = [NSString stringWithFormat:@"%02ld:%02ld",a,b];
    float sec2 = self.avManager.curuentTime;
    NSInteger c = sec2/60;
    NSInteger d = (int)sec2%60;
    self.curTimeLable.text = [NSString stringWithFormat:@"%02ld:%02ld",c,d];
    self.progressSlider.maximumValue = self.avManager.playDuration;
    self.progressSlider.value = self.avManager.curuentTime;
}

-(void)changeTitleView
{
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 180, 50)];
    self.navigationItem.titleView = self.view1;
    self.marLabel = [[UILabel alloc]initWithFrame:CGRectMake(375, 10, 0, 0)];
    self.marLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view1 addSubview:self.marLabel];
    self.marLabel.text = self.title;
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
//下载
- (IBAction)DownLoadBtnAction:(id)sender {
}
//分享
- (IBAction)shareBtnAction:(id)sender {
}
//收藏
- (IBAction)collecBtnAction:(id)sender {
}
//上一首
- (IBAction)BackBtnAction:(id)sender
{
    self.indexPath --;
    if (self.indexPath < 0) {
        self.indexPath = self.storyUrls.count - 1;
    }
    [self.avManager above];
}
//开始
- (IBAction)startAndStopBtnAction:(id)sender
{
    if (!self.isPlay) {
        //[_timer setFireDate:[NSDate distantPast]];
        [self.avManager.avPlay play];
        [self.startAndStopBtn setImage:[UIImage imageNamed:@"Unknown-4"] forState:UIControlStateNormal];
        self.isPlay = YES;
    }else
    {
        //[_timer setFireDate:[NSDate distantFuture]];
        [self.avManager.avPlay pause];
        [self.startAndStopBtn setImage:[UIImage imageNamed:@"Unknown-5"] forState:UIControlStateNormal];
        self.isPlay = NO;
    }
    //[self.avManager playWithBtn:nil];
}
//下一首
- (IBAction)nextBtnAction:(id)sender
{
    self.indexPath ++;
    if (self.indexPath == self.storyUrls.count ) {
        self.indexPath = 0;
    }
    [self.avManager next];
    
}
- (IBAction)chanageVolumeAction:(id)sender
{
    [self.avManager.avPlay pause];
    self.avManager.avPlay.volume = self.volumeSlider.value;
    [self.avManager.avPlay play];
}
- (IBAction)chanagTimeLableAction:(id)sender
{
    [self.avManager playProgress:self.progressSlider.value];
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
