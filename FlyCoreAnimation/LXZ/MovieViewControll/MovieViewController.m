//
//  MovieViewController.m
//  Movie
//
//  Created by linxuanzhao on 16/8/2.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import "MovieViewController.h"
#import "DownLoad.h"
#import "Movie.h"
#import "MovieCell.h"
#import "UIImageView+WebCache.h"
#import "DetailMovieViewController.h"
#import "MovieAnimation.h"
#import "UIViewController+Trainsition.h"
#import "MovieAnimationko.h"
#import "MovieTableViewController.h"
@interface MovieViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UINavigationControllerDelegate, UIGestureRecognizerDelegate,UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *predictArray;
@property (nonatomic, strong) MovieAnimation *animation;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *PredictCollectionView;
@property (nonatomic, strong) UISegmentedControl *segment;
@property(nonatomic,strong)MovieAnimationko  *mak;

@end

@implementation MovieViewController
-(MovieAnimationko *)mak{
    
    
    if (!_mak) {
        _mak = [MovieAnimationko new];
    }
    return _mak;

}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCollectionView];
    [self createPredictCollectionView];
    [self getData];
    [self getPredictData];
    [self createSegmentedControl];
    [self createMJRefresh];
    [self createPreMJRefresh];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab.png"] style:UIBarButtonItemStylePlain target:self action:@selector(changVC)];

}

- (void)changVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.animation = [[MovieAnimation alloc] initWithAnimateType:animationPush andDuration:1.5];
    self.navigationController.delegate = self;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)predictArray
{
    if (!_predictArray) {
        _predictArray = [NSMutableArray array];
    }
    return _predictArray;
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
            [self.collectionView reloadData];
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
            [self.predictArray addObject:movie];
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.PredictCollectionView reloadData];
        });
        
    }];
    
}


- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100, 150);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 10, 30, 10);
    flowLayout.minimumLineSpacing = 50;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCWI, SCHI - 64) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MovieCell class] forCellWithReuseIdentifier:@"movie"];
    [self.view addSubview:self.collectionView];
    
}


- (void)createPredictCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100, 150);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 10, 30, 10);
    flowLayout.minimumLineSpacing = 50;
    self.PredictCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.PredictCollectionView.delegate = self;
    self.PredictCollectionView.dataSource = self;
    self.PredictCollectionView.backgroundColor = [UIColor whiteColor];
    [self.PredictCollectionView registerClass:[MovieCell class] forCellWithReuseIdentifier:@"moviePredict"];
    [self.view addSubview:self.PredictCollectionView];
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
            self.collectionView.scrollsToTop = YES;
            self.PredictCollectionView.scrollsToTop = NO;
            [self.view insertSubview:self.collectionView aboveSubview:self.PredictCollectionView];
            
            break;
        }
        case 1:
        {
            self.PredictCollectionView.scrollsToTop = YES;
            self.collectionView.scrollsToTop = NO;
            [self.view insertSubview:self.PredictCollectionView aboveSubview:self.collectionView];
            
            break;
        }
        default:
            break;
    }
}

- (void)createMJRefresh
{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.dataArray = nil;
        [self getData];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        
    }];
    
    self.collectionView.mj_header = header;
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
        self.predictArray = nil;
        [self getPredictData];
        [self.PredictCollectionView reloadData];
        [self.PredictCollectionView.mj_header endRefreshing];
        
    }];
    self.PredictCollectionView.mj_header = header;
    NSArray *imageArray1 = [NSArray arrayWithObject:[UIImage imageNamed:@"movie.png"]];
    NSArray *imageArray2 = [NSArray arrayWithObject:[UIImage imageNamed:@"movie.png"]];
    NSArray *imageArray3 = [NSArray arrayWithObject:[UIImage imageNamed:@"movie.png"]];
    
    [header setImages:imageArray1 forState:MJRefreshStateIdle];
    [header setImages:imageArray2 forState:MJRefreshStateRefreshing];
    [header setImages:imageArray3 forState:MJRefreshStatePulling];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionView]) {
        return self.dataArray.count;
    }
    else
    {
        return self.predictArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movie" forIndexPath:indexPath];
        Movie *movie = self.dataArray[indexPath.item];
        cell.movie = movie;
        
        return cell;
    }
    else{
        MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moviePredict" forIndexPath:indexPath];
        Movie *movie = self.predictArray[indexPath.item];
        cell.movie = movie;
        
        return cell;

    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *cell = (MovieCell*)[collectionView cellForItemAtIndexPath:indexPath];
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
    
    [self.navigationController pushViewController:detailMovieVC animated:YES];}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    if (operation == UINavigationControllerOperationPush) {
        return self.animation;
    }
    else if(operation == UINavigationControllerOperationPop && [toVC isKindOfClass:[MovieTableViewController class]]){
        return self.mak;
    }
    {
        return nil;
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
