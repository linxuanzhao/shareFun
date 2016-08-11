//
//  DetailMovieViewController.m
//  Movie
//
//  Created by linxuanzhao on 16/8/2.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import "DetailMovieViewController.h"
#import "Movie.h"
#import "UIImageView+WebCache.h"
#import "MoviePlayViewController.h"
#import "MovieDetail.h"
#import "UIViewController+Trainsition.h"
#import "MovieAnimation.h"

@interface DetailMovieViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) MovieAnimation *animation;

@end

@implementation DetailMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.animation = [[MovieAnimation alloc] initWithAnimateType:animationPop andDuration:1.5];
    [self createDetailMovieView];
    //    [self getData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;

}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)getData
{
    [DownLoad downLoadWithUrl:@"http://piao.163.com/m/movie/detail.html?app_id=2&mobileType=iPhone&ver=3.7.1&channel=lede&deviceId=E91204AD-3F7F-446E-A42E-BCEE5FEDFDF8&apiVer=21&city=440100" postBody:[NSString stringWithFormat:@"movie_id=%@", self.movieId] resultBlock:^(NSData *data) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = dict[@"object"];
        MovieDetail *detail = [[MovieDetail alloc] init];
        [detail setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:detail];
          
    }];
}



- (void)createDetailMovieView
{
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 20) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    [self.view addSubview:self.tableView];
    
    // headView
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCWI, SCHI / 2 + 50)];
    self.headView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    
    // imageView
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 140, 110, 160)];
    self.targetView = self.imageV;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.logo520692]];
    
    // 视频
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCWI, self.imageV.center.y)];
    [self.topView sd_setImageWithURL:[NSURL URLWithString:self.cover]];
    self.topView.userInteractionEnabled=YES;
    
    [self.headView addSubview:self.topView];
    [self.headView addSubview:self.imageV];
    self.tableView.tableHeaderView = self.headView;
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(0, 0, 50, 50);
    self.playBtn.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:0.6];
    self.playBtn.center = self.topView.center;
    self.playBtn.layer.cornerRadius = 25;
    self.playBtn.layer.masksToBounds = YES;
    [self.playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(presentMovie) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.playBtn];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    self.backButton.frame = CGRectMake(10, 50, 32, 32);
    self.backButton.layer.cornerRadius = 16;
    self.backButton.layer.masksToBounds = YES;
    self.backButton.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:0.6];
    [self.topView addSubview:self.backButton];
    
    // name
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 160, 150, 20)];
    self.nameLabel.text = self.name;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.nameLabel];
    
    // releaseDate
    
    
}



- (void)presentMovie
{
    MoviePlayViewController *MoviePlayVC = [[MoviePlayViewController alloc] init];
    MoviePlayVC.movieUrlStr = self.movieUrlStr;
    
    [self presentViewController:MoviePlayVC animated:YES completion:nil];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    [UIView animateWithDuration:0 delay:1.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.navigationController.navigationBarHidden = NO;
    } completion:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    cell.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    cell.textLabel.text = @"哈哈哈";
    
    return cell;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return self.animation;
    }
    else
    {
        return  nil;
    }
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
