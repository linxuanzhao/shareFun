//
//  PhotoViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/15.
//  Copyright © 2016年 he. All rights reserved.
//

#import "PhotoViewController.h"
#import "SDCycleScrollView.h"

@interface PhotoViewController ()

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSTimer *hiddenTimer;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self AutoHidden];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disapper)];
    [self.view addGestureRecognizer:tap];

    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *image = [UIImage imageNamed:@"back.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(backPhoto)];
    
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, SCHI / 3 - 64, SCWI, SCHI / 3)imageURLStringsGroup:self.photoArray];
    self.cycleScrollView.backgroundColor = [UIColor clearColor];
    self.cycleScrollView.autoScroll = NO;
    self.cycleScrollView.infiniteLoop = NO;
    self.cycleScrollView.firstIndex = self.index;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    self.cycleScrollView.titleLabelBackgroundColor = [UIColor redColor];
    [self.view addSubview:self.cycleScrollView];
    
    
}


- (void)disapper
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (self.navigationController.navigationBar.alpha == 0){
            self.navigationController.navigationBar.alpha = 1;

        }
        
        else{
            self.navigationController.navigationBar.alpha = 0;
            
        }
        
    } completion:^(BOOL finished){
        
        [self removeHiddenTimer];
        if (self.navigationController.navigationBar.alpha == 1) {
            [self AutoHidden];
        }
    }];
    
}

- (void)removeHiddenTimer
{
    if (self.hiddenTimer) {
        [self.hiddenTimer invalidate];
        self.hiddenTimer = nil;
    }
}


- (void)AutoHidden
{
    self.hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(disapper) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.hiddenTimer forMode:NSRunLoopCommonModes];
}





- (void)backPhoto
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
