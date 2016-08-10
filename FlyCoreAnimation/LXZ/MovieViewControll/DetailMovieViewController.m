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
#import "MovieDetail.h"

@interface DetailMovieViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DetailMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    [self createDetailMovieView];
    
    
    //    [self getData];
    
    
    
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
    //    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 20) style:UITableViewStylePlain];
    //    self.tableView.dataSource = self;
    //    self.tableView.delegate = self;
    //    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    //    [self.view addSubview:self.tableView];
    
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 220)];
    [self.topView sd_setImageWithURL:[NSURL URLWithString:self.cover]];
    //    self.tableView.tableHeaderView = self.topView;
    self.topView.userInteractionEnabled=YES;
    
    //    self.tableView.tableHeaderView = self.topView;
    [self.view addSubview:self.topView];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(0, 0, 50, 50);
    self.playBtn.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:0.6];
    self.playBtn.center = self.topView.center;
    self.playBtn.layer.cornerRadius = 25;
    self.playBtn.layer.masksToBounds = YES;
    [self.playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(presentMovie) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBtn];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    self.backButton.frame = CGRectMake(10, 50, 32, 32);
    self.backButton.layer.cornerRadius = 16;
    self.backButton.layer.masksToBounds = YES;
    self.backButton.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:0.6];
    [self.topView addSubview:self.backButton];
    
    
    
}



- (void)presentMovie
{
    MoviePlayViewController *MoviePlayVC = [[MoviePlayViewController alloc] init];
    MoviePlayVC.movieUrlStr = self.movieUrlStr;
    
    [self presentViewController:MoviePlayVC animated:YES completion:nil];
}

- (void)back
{
    [((OUNavigationController*)self.navigationController) popViewControllerAnimated:YES];
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
    
    
    
    return cell;
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
