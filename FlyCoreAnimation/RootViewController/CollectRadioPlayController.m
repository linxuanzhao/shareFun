//
//  CollectRadioPlayController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/19.
//  Copyright © 2016年 he. All rights reserved.
//

#import "CollectRadioPlayController.h"
#import "YZLAVManager.h"
#import "PKListModel.h"
#import "DBManager.h"

@interface CollectRadioPlayController ()
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UILabel *curtimeLable;
@property (weak, nonatomic) IBOutlet UILabel *resTimeLable;
@property (weak, nonatomic) IBOutlet UIButton *startAndStop;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (nonatomic, strong) YZLAVManager *avManager;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *marLabel;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) UIButton *BarBtn;
@property (nonatomic, strong) DBManager *manager;
@property (nonatomic, strong) CompositeListModel *collectModel;


@end

@implementation CollectRadioPlayController

-(void)changeSliderImage
{
    self.progressSlider.value = 0;
    self.volumeSlider.value = 1.0;
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeTitleView];
    [self changeSliderImage];
    [self addBackground];
    
    
    self.avManager = [YZLAVManager shareInstance];
    
    NSMutableArray *arr =[NSMutableArray array];
    
    for (PKListModel *model in self.collectArray) {
        [arr addObject:model.musicUrl];
    }
    [self.avManager setPlayList:arr flag:self.indexPath];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    [self.avManager.avPlay play];
    
}



-(void)changeTime
{
    float sec = self.avManager.playDuration - self.avManager.curuentTime;
    NSInteger a = sec / 60;
    NSInteger b = (int)sec % 60;
    self.resTimeLable.text  = [NSString stringWithFormat:@"%02ld:%02ld",a,b];
    float sec2 = self.avManager.curuentTime;
    NSInteger c = sec2/60;
    NSInteger d = (int)sec2%60;
    self.curtimeLable.text = [NSString stringWithFormat:@"%02ld:%02ld",c,d];
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



- (IBAction)backBtnAction:(id)sender
{
    self.indexPath--;
    if (self.indexPath < 0) {
        self.indexPath = self.collectArray.count-1;
    }
    [self.avManager above];
}
- (IBAction)startAndStopBtnAction:(id)sender
{
    if (!self.isPlay) {
        [self.avManager.avPlay play];
        [self.startAndStop setImage:[UIImage imageNamed:@"Unknown-4"] forState:UIControlStateNormal];
        self.isPlay = YES;
    }else{
        [self.startAndStop setImage:[UIImage imageNamed:@"Unknown-5"] forState:UIControlStateNormal];
        [self.avManager.avPlay pause];
        self.isPlay = NO;
    }

}
- (IBAction)nextBtnAction:(id)sender
{
    self.indexPath++;
    if (self.indexPath == self.collectArray.count) {
        self.indexPath = 0;
    }
    [self.avManager next];
}
- (IBAction)chanageVolumenAction:(id)sender
{
    self.avManager.avPlay.volume = self.volumeSlider.value;

}
- (IBAction)chanageProgressAction:(id)sender
{
    [self.avManager.avPlay pause];
    [self.avManager playProgress:self.progressSlider.value];
    [self.avManager.avPlay play];
}





-(void)addBackground
{
    
    CAEmitterLayer * snowEmitterLayer = [CAEmitterLayer layer];
    snowEmitterLayer.emitterPosition = CGPointMake(100, -30);
    snowEmitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    snowEmitterLayer.emitterMode = kCAEmitterLayerPoints;
    snowEmitterLayer.emitterShape = kCAEmitterLayerLine;
    CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (__bridge id)[UIImage imageNamed:@"樱花瓣2"].CGImage;
    snowCell.scale = 0.02;
    snowCell.scaleRange = 0.2;
    snowCell.birthRate = 2;
    snowCell.lifetime = 80;
    snowCell.alphaSpeed = -0.01;
    snowCell.velocity = 40;
    snowCell.velocityRange = 60;
    snowCell.emissionRange = M_PI;
    snowCell.spin = M_PI_4;
    snowEmitterLayer.shadowOpacity = 1;
    snowEmitterLayer.shadowRadius = 8;
    snowEmitterLayer.shadowOffset = CGSizeMake(3, 3);
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
