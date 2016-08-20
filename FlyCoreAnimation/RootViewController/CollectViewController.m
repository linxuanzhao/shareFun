//
//  CollectViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/18.
//  Copyright © 2016年 he. All rights reserved.
//

#import "CollectViewController.h"
#import "DBManager.h"
#import "MovieTableViewCell.h"
#import "Movie.h"
#import "DetailMovieViewController.h"
#import "CompositeListModel.h"
#import "CollectRadioPlayController.h"
#import "PKListCell.h"


@interface CollectViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *radioArray;
@property (nonatomic, strong) NSMutableArray *newArray;


@end

@implementation CollectViewController

-(NSMutableArray *)newArray
{
    if (_newArray == nil) {
        _newArray = [[NSMutableArray alloc]init];
    }
    return _newArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editing)];
    self.dbManager = [DBManager shareInstance];
    
    
    
    
}

- (void)editing
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }
    else{
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        Movie *movie = self.dataArray[indexPath.row];
    
        [self.dbManager deleteMovie:movie];
        
        [self.dataArray removeObject:movie];
        
        if (self.dataArray.count == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
            label.text = @"收藏空空如也";
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:label];
            self.navigationItem.rightBarButtonItem = nil;
        }

        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
            }
   
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    self.dataArray = [self.dbManager selectFromTable];
    self.newArray = [self.dbManager selectFromPKRadio];

    
    if (self.dataArray.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
        label.text = @"收藏空空如也";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:label];
        self.navigationItem.rightBarButtonItem = nil;

        
    }
    
    [self.tableView reloadData];
}



- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCWI, SCHI)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[MovieTableViewCell class] forCellReuseIdentifier:@"movieCollect"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"radioCollect"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PKListCell" bundle:nil] forCellReuseIdentifier:@"pkListCell"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    }
    if (section == 1) {
        return self.newArray.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCollect"];
        Movie *movie = self.dataArray[indexPath.row];
        cell.movie = movie;
        [cell.playCountL removeFromSuperview];
        UILabel *releaseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 80, 300, 20)];
        releaseDateLabel.font = [UIFont systemFontOfSize:12];
        releaseDateLabel.textAlignment = NSTextAlignmentLeft;
        releaseDateLabel.text = movie.releaseDate;
        [cell.contentView addSubview:releaseDateLabel];
         return cell;
    }
    if (indexPath.section == 1) {
        PKListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pkListCell"];
        PKListModel *model = self.newArray[indexPath.row];
        [cell.imageViewA sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
        cell.imageViewA.layer.borderWidth = 2;
        cell.imageViewA.layer.borderColor = [[UIColor blackColor]CGColor];
        cell.titleLable.text = model.title;
        return cell;
    }
    return nil;
   

        
        
    
        
    
   
}

-  (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return @"电影";
        
    }
    else
    {
        return @"电台";
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MovieTableViewCell *cell = (MovieTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
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
    if (indexPath.section == 1) {
        CollectRadioPlayController *playVc = [[CollectRadioPlayController alloc]init];
        playVc.collectArray = self.newArray;
        playVc.indexPath = indexPath.row;
        [self.navigationController pushViewController:playVc animated:YES];
        
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
