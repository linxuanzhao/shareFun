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
#import "MovieAnimationko.h"
#import "MovieViewController.h"

@interface MovieTableViewController () <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MovieAnimation *animation;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray*listArray;
@property (nonatomic, strong) UITableView *predictTableView;
@property (nonatomic, strong) MovieViewController *movieCollectVC;
@property (nonatomic, strong) MovieAnimationko *mak;

@end

@implementation MovieTableViewController

-(MovieAnimationko *)mak{
    
    
    if (!_mak) {
        _mak = [MovieAnimationko new];
    }
    return _mak;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createPredictView];
    [self createTableView];
    [self getData];
    [self getPredictData];
    [self createSegmentedControl];
    [self createMJRefresh];
    [self createPreMJRefresh];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"collectView.png"] style:UIBarButtonItemStylePlain target:self action:@selector(changeVC)];
    
    
}
- (void)changeVC{
    MovieViewController *mc = [[MovieViewController alloc] init];
//    mc.transitioningDelegate = self;
    [self.navigationController pushViewController:mc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.animation = [[MovieAnimation alloc] initWithAnimateType:animationPush andDuration:1.5];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.animation = nil;
}

- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
}

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
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
                [self.hotArray addObject:movie];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
         
        }];
    
}

- (void)getPredictData
{
    [DownLoad downLoadWithUrl:@"http://piao.163.com/m/movie/list.html?app_id=2&mobileType=iPhone&ver=3.7.1&channel=lede&deviceId=E91204AD-3F7F-446E-A42E-BCEE5FEDFDF8&apiVer=21&city=440100&type=1" postBody:nil resultBlock:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *listArray = dic[@"list"];
        
        for (NSDictionary *movieDic in listArray) {
            Movie *movie = [[Movie alloc] init];
            [movie setValuesForKeysWithDictionary:movieDic];
            [self.listArray addObject:movie];


        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.predictTableView reloadData];
        });
        
    }];

}

- (void)createSegmentedControl
{
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"热映", @"预告"]];
    self.segment.frame = CGRectMake(0, 0, 0, 30);
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment;
    [self segmentAction:self.segment];
}


- (void)segmentAction:(UISegmentedControl *)sg
{
    switch (sg.selectedSegmentIndex) {
        case 0:
        {
            self.tableView.scrollsToTop = YES;
            self.predictTableView.scrollsToTop = NO;
            [self.view insertSubview:self.tableView aboveSubview:self.predictTableView];
           
            break;
        }
        case 1:
        {
            self.predictTableView.scrollsToTop = YES;
            self.tableView.scrollsToTop = NO;
            [self.view insertSubview:self.predictTableView aboveSubview:self.tableView];
            
            break;
        }
        default:
            break;
    }
}


- (void)createMJRefresh
{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.hotArray = nil;
        [self getData];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
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

- (void)createPreMJRefresh
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.listArray = nil;
        [self getPredictData];
        [self.predictTableView reloadData];
        [self.predictTableView.mj_header endRefreshing];
      
    }];
    self.predictTableView.mj_header = header;
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

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCWI, SCHI - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MovieTableViewCell class] forCellReuseIdentifier:@"movie"];
    [self.view addSubview:self.tableView];
}

- (void)createPredictView
{
    self.predictTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCWI, SCHI) style:UITableViewStylePlain];
    self.predictTableView.dataSource = self;
    self.predictTableView.delegate = self;
    self.predictTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.predictTableView registerClass:[MovieTableViewCell class] forCellReuseIdentifier:@"list"];
    [self.predictTableView registerClass:[MovieTableViewCell class] forCellReuseIdentifier:@"notify"];
    [self.view addSubview:self.predictTableView];

}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.tableView]) {
        return self.hotArray.count;
    }
    else if ([tableView isEqual:self.predictTableView])
    {
        return self.listArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if ([tableView isEqual:self.tableView]) {
        MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movie"];
        Movie *movie = self.hotArray[indexPath.row];
        cell.movie = movie;
        return cell;
    }
    
    else if ([tableView isEqual:self.predictTableView])
    {
        MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
        Movie *movie = self.listArray[indexPath.row];
        cell.movie = movie;
        return cell;
    }
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCHI / 667 * 120;
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
    detailMovieVC.movie = cell.movie;
   
    [self.navigationController pushViewController:detailMovieVC animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{

    if (operation == UINavigationControllerOperationPush && [toVC isKindOfClass:[MovieViewController class]]) {
        return self.mak;
    }
    else if (operation == UINavigationControllerOperationPop && [toVC isKindOfClass:[MovieViewController class]]){
        return self.animation;
    }
    else if (operation == UINavigationControllerOperationPop){
        return nil;
    }else if (operation == UINavigationControllerOperationPush ){
        return self.animation;
    }
        
    return nil;
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];

}






@end
