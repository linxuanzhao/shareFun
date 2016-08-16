//
//  MovieTableViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/16.
//  Copyright © 2016年 he. All rights reserved.
//

#import "MovieTableViewController.h"
#import "MovieAnimation.h"
#import "Movie.h"
#import "MovieTableViewCell.h"
#import "DetailMovieViewController.h"
#import "UIViewController+Trainsition.h"

@interface MovieTableViewController () <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) MovieAnimation *animation;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISegmentedControl *segment;

@end

@implementation MovieTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animation = [[MovieAnimation alloc] initWithAnimateType:animationPush andDuration:1.5];
    [self createSegmentedControl];
    [self createTableView];
    [self createMJRefresh];
    [self.tableView registerClass:[MovieTableViewCell class] forCellReuseIdentifier:@"movie"];
    [self getData];
    
    


}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
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
    //    http://piao.163.com/m/movie/list.html?app_id=2&mobileType=iPhone&ver=3.7.1&channel=lede&deviceId=E91204AD-3F7F-446E-A42E-BCEE5FEDFDF8&apiVer=21&city=440100
    //    latitude=23.18037&longitude=113.35261&offen_cinema_ids=&type=0
    
    [DownLoad downLoadWithUrl:@"http://piao.163.com/m/movie/list.html?app_id=2&mobileType=iPhone&ver=3.7.1&channel=lede&deviceId=E91204AD-3F7F-446E-A42E-BCEE5FEDFDF8&apiVer=21&city=440100" postBody:nil resultBlock:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = dic[@"list"];
        for (NSDictionary *movieDic in array) {
            Movie *movie = [[Movie alloc] init];
            [movie setValuesForKeysWithDictionary:movieDic];
            [self.dataArray addObject:movie];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
    
}

- (void)createSegmentedControl
{
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"热映", @"预告"]];
    self.segment.frame = CGRectMake(0, 0, 0, 30);
    self.segment.selectedSegmentIndex = 0;
//    self.segment.tintColor = [UIColor clearColor];
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment;
}


- (void)segmentAction:(UISegmentedControl *)sg
{
    switch (sg.selectedSegmentIndex) {
        case 0:
        {
            [self.view addSubview:self.tableView];
        }
            break;
            
        case 1:
        {
        
        }
            break;
            
        default:
            break;
    }
}


- (void)createMJRefresh
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.dataArray = nil;
        [self getData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
    self.tableView.mj_header = header;
    NSArray *imageArray1 = [NSArray arrayWithObject:[UIImage imageNamed:@"movie.png"]];
    NSArray *imageArray2 = [NSArray arrayWithObject:[UIImage imageNamed:@"movie.png"]];
    NSArray *imageArray3 = [NSArray arrayWithObject:[UIImage imageNamed:@"movie.png"]];
    
    [header setImages:imageArray1 forState:MJRefreshStateIdle];
    [header setImages:imageArray2 forState:MJRefreshStateRefreshing];
    [header setImages:imageArray3 forState:MJRefreshStatePulling];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
}


- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)createPredictTableView
{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movie"];
    Movie *movie = self.dataArray[indexPath.row];
    cell.movie = movie;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:movie.logo520692]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *cell = (MovieTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    self.targetView = cell.imageV;
    
    DetailMovieViewController *detailMovieVC = [[DetailMovieViewController alloc] init];
    NSString *str = [cell.movie.logo556640 substringToIndex:cell.movie.logo556640.length - 4];
    NSString *urlImgStr = [str stringByAppendingString:@"jpg"];
    detailMovieVC.cover = urlImgStr;
    detailMovieVC.movieUrlStr = cell.movie.mobilePreview;
    detailMovieVC.movieId = cell.movie.movieId;
    detailMovieVC.actors = cell.movie.actors;
    detailMovieVC.category = cell.movie.category;
    detailMovieVC.duration = cell.movie.duration;
    detailMovieVC.director = cell.movie.director;
    detailMovieVC.grade = cell.movie.grade;
    detailMovieVC.area = cell.movie.area;
    detailMovieVC.logo520692 = cell.movie.logo520692;
    detailMovieVC.name = cell.movie.name;
    detailMovieVC.releaseDate = cell.movie.releaseDate;
    
    [self.navigationController pushViewController:detailMovieVC animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return self.animation;
    }
    else
    {
        return nil;
    }
}


@end
