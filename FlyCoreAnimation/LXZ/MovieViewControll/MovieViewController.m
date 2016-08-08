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
#import "OUNavigationController.h"
#import "OUNavigationController.h"

@interface MovieViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热映电影";
    [self getData];
    [self createCollectionView];
    
    
    
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
    [DownLoad downLoadWithUrl:@"http://piao.163.com/m/movie/list.html" postBody:@"app_id=2&mobileType=iPhone&ver=3.7.1&channel=lede&deviceId=E91204AD-3F7F-446E-A42E-BCEE5FEDFDF8&apiVer=21&city=440100?latitude=23.1967&longitude=113.33483&offen_cinema_ids=&type=0" resultBlock:^(NSData *data) {
        
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

    DetailMovieViewController *detailMovieVC = [[DetailMovieViewController alloc] init];
    MovieCell *cell = (MovieCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    NSString *str = [cell.movie.logo556640 substringToIndex:cell.movie.logo556640.length - 4];
    NSString *urlImgStr = [str stringByAppendingString:@"jpg"];
    
    detailMovieVC.cover = urlImgStr;
    detailMovieVC.movieUrlStr = cell.movie.mobilePreview;
    
    [((OUNavigationController*)self.navigationController) pushViewController:detailMovieVC withImageView:cell.imageV desRect:CGRectMake(20, 150, cell.imageV.bounds.size.width, cell.imageV.bounds.size.height)];
    

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
