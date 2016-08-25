//
//  DetailMovieViewController.m
//  Movie
//
//  Created by linxuanzhao on 16/8/2.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import "DetailMovieViewController.h"
#import "MoviePlayViewController.h"
#import "UIViewController+Trainsition.h"
#import "MovieAnimation.h"
#import "MovieDetailOneCell.h"
#import "MovieDetailTwoCell.h"
#import "PhotoViewController.h"
#import "MBProgressHUD.h"
#import "DBManager.h"
#import "MovieTableViewController.h"
#import "MovieViewController.h"

@interface DetailMovieViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSMutableArray *logo1Array; // 小图
@property (nonatomic, strong) NSMutableArray *logoArray; // 大图
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@property (nonatomic, strong) MovieAnimation *animation;
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation DetailMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.animation = [[MovieAnimation alloc] initWithAnimateType:animationPop andDuration:1.5];
    [self createDetailMovieView];
    [self getData];
    self.dbManager = [DBManager shareInstance];
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
   
    NSMutableArray *array = [self.dbManager selectFromTable];
    if (array.count) {
        for (Movie *movie in array) {
            if ([self.movie.name isEqualToString:movie.name]) {
                self.collectBtn.selected = YES;
            }
        }
    }
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

- (NSMutableArray *)logoArray
{
    if (!_logoArray) {
        _logoArray = [NSMutableArray array];
    }
    return _logoArray;
}

- (NSMutableArray *)logo1Array
{
    if (!_logo1Array) {
        _logo1Array = [NSMutableArray array];
    }
    return _logo1Array;
}


- (void)getData
{
    [DownLoad downLoadWithUrl:@"http://piao.163.com/m/movie/detail.html?app_id=2&mobileType=iPhone&ver=3.7.1&channel=lede&deviceId=E91204AD-3F7F-446E-A42E-BCEE5FEDFDF8&apiVer=21&city=440100" postBody:[NSString stringWithFormat:@"movie_id=%@", self.movieId] resultBlock:^(NSData *data) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.desc = dict[@"object"][@"description"];
    
        NSArray *array = dict[@"object"][@"stillsList"];
       
        for (NSDictionary *photoDict in array)
        {
            NSString *urlImgStr = photoDict[@"logo"];
            NSString *str = [urlImgStr substringToIndex:urlImgStr.length - 4];
            urlImgStr = [str stringByAppendingString:@"jpg"];
            
            NSString *urlImgStr1 = photoDict[@"logo1"];
            NSString *str1 = [urlImgStr1 substringToIndex:urlImgStr1.length - 4];
            urlImgStr1 = [str1 stringByAppendingString:@"jpg"];

            [self.logoArray addObject:urlImgStr];
            [self.logo1Array addObject:urlImgStr1];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    }];
}



- (void)createDetailMovieView
{
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 20) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[MovieDetailOneCell class] forCellReuseIdentifier:@"desc"];
    [self.tableView registerClass:[MovieDetailTwoCell class] forCellReuseIdentifier:@"photo"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // headView
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCWI, SCHI * 0.404)];
    
    // imageView
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCWI * 0.04, SCHI * 0.225, SCWI * 0.24, SCHI * 0.172)];
    self.targetView = self.imageV;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.logo520692]];
    
    // topView
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCWI, self.imageV.center.y)];
    [self.topView sd_setImageWithURL:[NSURL URLWithString:self.cover]];
    self.topView.userInteractionEnabled = YES;
    
    [self.headView addSubview:self.topView];
    [self.headView addSubview:self.imageV];
    self.tableView.tableHeaderView = self.headView;
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(0, 0, SCWI * 0.107, SCWI * 0.107);
    self.playBtn.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:0.6];
    self.playBtn.center = self.topView.center;
    self.playBtn.layer.cornerRadius = SCWI * 0.107 / 2;
    self.playBtn.layer.masksToBounds = YES;
    [self.playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(presentMovie) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.playBtn];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    self.backButton.frame = CGRectMake(SCWI * 0.04, SCHI * 0.075, SCWI * 0.085, SCWI * 0.085);
    self.backButton.layer.cornerRadius = SCWI * 0.085 / 2;
    self.backButton.layer.masksToBounds = YES;
    self.backButton.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:0.8];
    [self.topView addSubview:self.backButton];
    
    // name
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = self.name;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.textColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.topView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(SCWI * 0.04);
        make.top.equalTo(self.headView.mas_top).offset(SCHI * 0.225);
        make.right.equalTo(self.headView.mas_right).offset(-SCWI * 0.04);
        make.height.mas_equalTo(SCHI * 0.03);
    }];
    
    // releaseDate
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.text = [NSString stringWithFormat:@"%@上映 %@", self.releaseDate, self.area];
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    self.dateLabel.numberOfLines = 2;
    self.dateLabel.textColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
//    self.dateLabel.backgroundColor = [UIColor redColor];
    [self.topView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(SCWI * 0.04);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(SCHI *0.007);
        make.right.equalTo(self.headView.mas_right).offset(-SCWI * 0.04);
        make.height.mas_equalTo(20);
    }];
    
    // category
    self.categoryLabel = [[UILabel alloc] init];
    self.categoryLabel.text = self.category;
    self.categoryLabel.font = [UIFont systemFontOfSize:14];
    self.categoryLabel.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:self.categoryLabel];
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(SCWI * 0.04);
        make.top.equalTo(self.topView.mas_bottom).offset(SCWI * 0.015);
        make.right.equalTo(self.headView.mas_right).offset(-SCWI * 0.04);
        make.height.mas_equalTo(20);
    }];
    
    // duration
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 250, 200, 20)];
    self.durationLabel.text = [NSString stringWithFormat:@"时长: %@", self.duration];
    self.durationLabel.font = [UIFont systemFontOfSize:14];
    self.durationLabel.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:self.durationLabel];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(SCWI * 0.04);
        make.top.equalTo(self.categoryLabel.mas_bottom).offset(SCWI * 0.015);
        make.right.equalTo(self.headView.mas_right).offset(-SCWI * 0.04);
        make.height.mas_equalTo(20);

    }];
    
    // collectBtn
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectBtn addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectBtn setImage:[UIImage imageNamed:@"collection.png"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"haveCollection.png"] forState:UIControlStateSelected];
    [self.topView addSubview:self.collectBtn];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headView.mas_right).offset(-SCWI * 0.04);
        make.top.equalTo(self.headView.mas_top).offset(SCHI * 0.075);
        make.size.mas_equalTo(CGSizeMake(SCWI * 0.085, SCWI * 0.085));
    }];
  
}

- (void)collect:(UIButton *)btn
{
    self.collectBtn = btn;
    
    // MBProgressHUD
    if (!btn.selected) {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.progressHUD];
        self.progressHUD.labelText = @"已收藏";
        self.progressHUD.mode = MBProgressHUDModeText;
        self.progressHUD.minShowTime = 1;
        [self.progressHUD showAnimated:YES whileExecutingBlock:^{
        
            [self.dbManager addMovie:self.movie];
    
        } completionBlock:^{
            
            [self.progressHUD removeFromSuperview];
            self.progressHUD = nil;
        }];
    }
    else
    {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.progressHUD];
        self.progressHUD.labelText = @"取消收藏";
        self.progressHUD.mode = MBProgressHUDModeText;
        self.progressHUD.minShowTime = 1;
        [self.progressHUD showAnimated:YES whileExecutingBlock:^{
            
            [self.dbManager deleteMovie:self.movie];
            
        } completionBlock:^{
            [self.progressHUD removeFromSuperview];
            self.progressHUD = nil;
        }];

    }
    btn.selected = !btn.selected;
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

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.photoArray removeAllObjects];
    if (indexPath.section == 0) {
        MovieDetailOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"desc"];
        cell.descLabel.text = [NSString stringWithFormat:@"导演: %@\n主演: %@\n剧情: %@\n", self.director, self.actors, self.desc];
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:cell.descLabel.text];
        NSMutableParagraphStyle *parStyle = [[NSMutableParagraphStyle alloc] init];
        [att addAttribute:NSParagraphStyleAttributeName value:parStyle range:NSMakeRange(0, cell.descLabel.text.length)];
        parStyle.lineSpacing = 5;
        parStyle.headIndent = 35;
        cell.descLabel.attributedText = att;
        [cell.descLabel sizeToFit];
        
        self.height = CGRectGetHeight(cell.descLabel.frame);
        
        if (indexPath == self.selectedIndexPath) {

            cell.descLabel.frame = CGRectMake(SCWI * 0.04, 0, SCWI - 30, self.height);
            cell.imageV.frame = CGRectMake(cell.descLabel.center.x - 16, self.height, 16, 16);
            cell.imageV.image = [UIImage imageNamed:@"up.png"];
            
        }
        else
        {
            cell.descLabel.frame = CGRectMake(SCWI * 0.04, 0, SCWI - 30, SCHI * 0.18);
            cell.imageV.frame = CGRectMake(cell.descLabel.center.x - 16, SCHI * 0.18, 16, 16);
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    else if (indexPath.section == 1){
        MovieDetailTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo"];
        
            cell.photoArray = self.logo1Array;
     
       
        for (int i = 0; i < self.logo1Array.count; i++) {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCWI * 0.32, 0, SCWI * 0.267, SCHI * 0.15)];
            [imageV sd_setImageWithURL:[NSURL URLWithString:self.logo1Array[i]]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            imageV.userInteractionEnabled = YES;
            [imageV addGestureRecognizer:tap];
            [cell.scrollView addSubview:imageV];
            [self.photoArray addObject:imageV];


        }
       
        return cell;
    }
    
    
    return nil;
}

- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (void)tapAction:(UITapGestureRecognizer*)tap
{

    for (UIImageView *imageV in self.photoArray) {
        if (tap.view == imageV) {
            self.index = [self.photoArray indexOfObject:imageV];
            
            
        }
    }
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    photoVC.photoArray = self.logoArray;
    photoVC.index = self.index;
    UINavigationController *photoNav = [[UINavigationController alloc] initWithRootViewController:photoVC];
    
    [self presentViewController:photoNav animated:YES completion:nil];
}




- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    if (operation == UINavigationControllerOperationPop && [toVC isKindOfClass:[MovieTableViewController class]]) {
        
        return self.animation;
    }
    else if (operation == UINavigationControllerOperationPop && [toVC isKindOfClass:[MovieViewController class]]){
        return self.animation;
    }
    else
    {
        return  nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath == self.selectedIndexPath) {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

            return self.height + 16;
            
        }
        else
        {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

            return SCHI * 0.18 + 16;
        }

    }
    
    else if (indexPath.section == 1){
        return 140;
    }

        return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.selectedIndexPath == nil)
        {
            self.selectedIndexPath = indexPath;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         
        }
        
        else
        {
            self.selectedIndexPath = nil;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
       
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor lightGrayColor];
    view.alpha = 0.6;
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
