//
//  CompositePlayViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 he. All rights reserved.
//

#import "CompositePlayViewController.h"
#import "CompositeListModel.h"

@interface CompositePlayViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UISlider *VolumeSlider;
@property (weak, nonatomic) IBOutlet UILabel *curTimeLable;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *resTimeLable;
@property (weak, nonatomic) IBOutlet UIButton *startAndStop;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UILabel *marLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) YZLAVManager *avManager;
@property (nonatomic, assign) BOOL isPlay;

@end

@implementation CompositePlayViewController

-(void)chanageSliderImage
{
    self.VolumeSlider.value = 0.4;
    [self.VolumeSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
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
-(void)changeTimeLable
{
    float sec = self.avManager.playDuration - self.avManager.curuentTime;
    NSInteger a = sec / 60;
    NSInteger b = (int)sec % 60;
    self.resTimeLable.text  = [NSString stringWithFormat:@"%02ld:%02ld",a,b];
    float sec2 = self.avManager.curuentTime;
    NSInteger c = sec2/60;
    NSInteger d = (int)sec2%60;
    self.curTimeLable.text = [NSString stringWithFormat:@"%02ld:%02ld",c,d];
    self.progressSlider.maximumValue = self.avManager.playDuration;
    self.progressSlider.value = self.avManager.curuentTime;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self chanageSliderImage];
    [self changeTitleView];
    [self addBackground];
    self.avManager = [YZLAVManager shareInstance];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (CompositeListModel *model in self.compositeUrls) {
        [array addObject:model.playUrl32];
    }
    [self.avManager setPlayList:array flag:self.indexPath];
    [self.avManager.avPlay play];

    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeTimeLable) userInfo:nil repeats:YES];
    
}
- (IBAction)backBtnAction:(id)sender
{
    self.indexPath --;
    if (self.indexPath < 0) {
        self.indexPath = self.compositeUrls.count - 1;
    }
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:[self.compositeUrls[self.indexPath] coverLarge]]];
    [self.avManager above];
}
- (IBAction)startAndStopBtnAction:(id)sender
{
    if (!self.isPlay) {
        //[_timer setFireDate:[NSDate distantFuture]];
        [self.startAndStop setImage:[UIImage imageNamed:@"Unknown-5"] forState:UIControlStateNormal];
        [self.avManager.avPlay play];
        self.isPlay = YES;
    }else
    {
        //[_timer setFireDate:[NSDate distantPast]];
        [self.startAndStop setImage:[UIImage imageNamed:@"Unknown-4"] forState:UIControlStateNormal];
        [self.avManager.avPlay pause];
        self.isPlay = NO;
    }
    //[self.avManager playWithBtn:nil];

}
- (IBAction)nextBtnAction:(id)sender
{
    self.indexPath ++;
    if (self.indexPath == self.compositeUrls.count) {
        self.indexPath = 0;
    }
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:[self.compositeUrls[self.indexPath] coverLarge]]];
    [self.avManager next];

}
- (IBAction)DownLoadBtnAction:(id)sender {
}
- (IBAction)shareBtnAction:(id)sender {
}
- (IBAction)collectBtnAction:(id)sender {
}
- (IBAction)volumeSliderAction:(id)sender
{
    self.avManager.avPlay.volume = self.VolumeSlider.value;
}
- (IBAction)progerssSliderAction:(id)sender
{
    [self.avManager.avPlay pause];
    [self.avManager playProgress:self.progressSlider.value];
    [self.avManager.avPlay play];
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
