//
//  NewsPlayViewController.m
//  YzlRadio
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import "NewsPlayViewController.h"
#import "YZLAVManager.h"
#import "XRCarouselView.h"
#import "NewsDetailModel.h"

@interface NewsPlayViewController ()<XRCarouselViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *curTime;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIImageView *handleImageView;
@property (nonatomic, strong) YZLAVManager *avManager;
@property (nonatomic, strong) XRCarouselView *carouselView;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UILabel *marLabel;
@property (weak, nonatomic) IBOutlet UIButton *satrt;


@end

@implementation NewsPlayViewController

-(void)imageScrollView
{
    self.carouselView = [[XRCarouselView alloc]initWithFrame:self.handleImageView.bounds];
    
    UIImage *image1 = [UIImage imageNamed:@"a1.JPG"];
    UIImage *image2 = [UIImage imageNamed:@"a2.JPG"];
    UIImage *image3 = [UIImage imageNamed:@"a3.JPG"];
    UIImage *image4 = [UIImage imageNamed:@"a4.JPG"];
    
    NSArray *arr1  = @[image1,image2,image3,image4];
    self.carouselView.imageArray = arr1;
    self.carouselView.delegate = self;
    self.carouselView.time = 5;
    self.carouselView.pagePosition = PositionHide;
    [self.handleImageView addSubview:self.carouselView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeTitleView];
    self.slider.value = 0;
    [self addBackground];
    [self imageScrollView];
    
    [self.slider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    
    self.avManager = [YZLAVManager shareInstance];
    
    NSMutableArray *arr =[NSMutableArray array];
    
    for (NewsDetailModel *model in self.urls) {
        [arr addObject:model.playUrl32];
    }
    [self.avManager setPlayList:arr flag:self.number];
    NSLog(@"%ld",self.urls.count);
    


    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    [self.avManager.avPlay play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.hidden = YES;
    });
  
}

-(void)changeItem
{
    self.navigationController.navigationBar.hidden = YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.navigationController.navigationBar.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.hidden = YES;
    });
    
}

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
    self.leftLabel.text  = [NSString stringWithFormat:@"%02ld:%02ld",a,b];
    float sec2 = self.avManager.curuentTime;
    NSInteger c = sec2/60;
    NSInteger d = (int)sec2%60;
    self.curTime.text = [NSString stringWithFormat:@"%02ld:%02ld",c,d];
    
    self.slider.maximumValue = self.avManager.playDuration;
    self.slider.value = self.avManager.curuentTime;

}



- (IBAction)backBtnAction:(id)sender {
    self.number--;
    if (self.number < 0) {
        self.number = self.urls.count-1;
    }
    [self.avManager above];
    
}
- (IBAction)startAndStopBtnAction:(id)sender
{
    [self.avManager playWithBtn:self.satrt];
}
- (IBAction)nextBtnAction:(id)sender {
    self.number++;
    if (self.number == self.urls.count) {
        self.number = 0;
    }
    [self.avManager next];
}
//下载
- (IBAction)downLoadBtnAction:(id)sender {
}
//分享
- (IBAction)shareBtnAction:(id)sender {
}
//收藏
- (IBAction)collectBtnAction:(id)sender {
}
- (IBAction)chanageProgress:(id)sender {
    [self.avManager playProgress:self.slider.value];
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
    snowCell.scaleRange = 0.5;
    snowCell.birthRate = 7;
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
