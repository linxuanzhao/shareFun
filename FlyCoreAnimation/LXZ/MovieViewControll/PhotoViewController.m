//
//  PhotoViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/15.
//  Copyright © 2016年 he. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (nonatomic, strong) NSTimer *hiddenTimer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIButton *downLoadBtn;

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
    
    UIImage *image1 = [UIImage imageNamed:@"back.png"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image1 style:UIBarButtonItemStyleDone target:self action:@selector(backPhoto)];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -64, SCWI, SCHI + 64)];
    self.scrollView.contentOffset = CGPointMake(SCWI * self.index, 0);
    self.scrollView.contentSize = CGSizeMake(SCWI * self.photoArray.count, 0);
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    for (int i = 0; i < self.photoArray.count; i++) {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCWI, 0, SCWI, SCHI)];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.photoArray[i]]];
        [self.scrollView addSubview:self.imageV];
    }
    
    
    
//    self.downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.downLoadBtn.frame = CGRectMake(SCWI - 60, SCHI - 120, 32, 32);
//    UIImage *image2 = [UIImage imageNamed:@"downLoad.png"];
//    image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self.downLoadBtn addTarget:self action:@selector(downLoad) forControlEvents:UIControlEventTouchUpInside];
//    [self.downLoadBtn setImage:image2 forState:UIControlStateNormal];
//    [self.view addSubview:self.downLoadBtn];


}



//- (void)downLoad
//{
//
//     UIImageWriteToSavedPhotosAlbum(self.imageV.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
//}
//
//- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//{
//    NSString *message = @"呵呵";
//    if (!error) {
//        message = @"成功保存到相册";
//    }else
//    {
//        message = [error description];
//    }
//    NSLog(@"message is %@",message);
//}




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
