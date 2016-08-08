//
//  DetailMovieViewController.m
//  Movie
//
//  Created by linxuanzhao on 16/8/2.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import "DetailMovieViewController.h"
#import "OUNavigationController.h"
#import "Movie.h"
#import "UIImageView+WebCache.h"
#import "MoviePlayViewController.h"


@interface DetailMovieViewController ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIImageView *playView;

@end

@implementation DetailMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;

    [self.view addSubview:self.topView];
    [self.view addSubview:self.playView];
     [self.view addSubview:self.backButton];
    
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];

//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(50, 400, 96, 16)];
//    image.image = [UIImage imageNamed:@"star.png"];
////    image.backgroundColor = [UIColor redColor];;
//    [self.view addSubview:image];
    
}

- (UIGestureRecognizer *)AddTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentMovie)];
    return tap;

}

- (void)presentMovie
{
    MoviePlayViewController *MoviePlayVC = [[MoviePlayViewController alloc] init];
    MoviePlayVC.movieUrlStr = self.movieUrlStr;
    
    [self presentViewController:MoviePlayVC animated:YES completion:nil];
}



- (UIImageView *)playView
{
    if (!_playView) {
        _playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _playView.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:0.6];
        _playView.center = self.topView.center;
        _playView.layer.cornerRadius = 25;
        _playView.layer.masksToBounds = YES;
        [_playView setImage:[UIImage imageNamed:@"play.png"]];
        _playView.userInteractionEnabled = YES;
        [_playView addGestureRecognizer:[self AddTapGestureRecognizer]];
    }
    return _playView;
}


- (UIImageView *)topView
{
    if (!_topView) {
        _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 220)];
        [_topView sd_setImageWithURL:[NSURL URLWithString:self.cover]];

    }
    return _topView;
}


- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(10, 50, 32, 32);
        _backButton.layer.cornerRadius = 16;
        _backButton.layer.masksToBounds = YES;
        _backButton.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:0.6];
        
    }
    return _backButton;
}


- (void)back
{
    [((OUNavigationController*)self.navigationController) popViewControllerAnimated:YES];
    [UIView animateWithDuration:0 delay:1.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.navigationController.navigationBarHidden = NO;
    } completion:nil];
    
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
