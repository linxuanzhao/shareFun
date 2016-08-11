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

@interface MovieViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) MovieAnimation *animation;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MovieViewController


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热映电影";
    
    self.animation = [[MovieAnimation alloc] initWithAnimateType:animationPush andDuration:1.5];
    [self createCollectionView];
    [self getData];
   
    
    
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
            [self.collectionView reloadData];
        });
        
        
    }];
    
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(110, 180);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 10, 30, 10);
    flowLayout.minimumLineSpacing = 50;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MovieCell class] forCellWithReuseIdentifier:@"movie"];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.collectionView];
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movie" forIndexPath:indexPath];
    Movie *movie = self.dataArray[indexPath.item];
    cell.movie = movie;
    
    return cell;
    
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
