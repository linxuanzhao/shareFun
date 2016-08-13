//
//  DetailMovieViewController.m
//  Movie
//
//  Created by linxuanzhao on 16/8/2.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import "DetailMovieViewController.h"
#import "UIImageView+WebCache.h"
#import "MoviePlayViewController.h"
#import "UIViewController+Trainsition.h"
#import "MovieAnimation.h"
#import "MovieDetailOneCell.h"

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
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSMutableArray *logo1;
@property (nonatomic, strong) NSMutableArray *logo;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) MovieAnimation *animation;

@end

@implementation DetailMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.animation = [[MovieAnimation alloc] initWithAnimateType:animationPop andDuration:1.5];
    [self createDetailMovieView];
    [self getData];
    
    
    UIScreenEdgePanGestureRecognizer *screen = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenAction:)];
    screen.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screen];
}

- (void)screenAction:(UIScreenEdgePanGestureRecognizer *)screen
{
    CGPoint pt = [screen translationInView:self.view];
    screen.view.center = CGPointMake(screen.view.center.x + pt.x, screen.view.center.y);
    
    [screen setTranslation:CGPointZero inView:self.view];
    
    if (screen.state == UIGestureRecognizerStateEnded) {
        if (self.view.frame.origin.x > SCWI / 2) {
            
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(SCWI, 0, SCWI, SCHI);
                
            } completion:^(BOOL finished) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, 0, SCWI, SCHI);
            }];
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

- (void)getData
{
    [DownLoad downLoadWithUrl:@"http://piao.163.com/m/movie/detail.html?app_id=2&mobileType=iPhone&ver=3.7.1&channel=lede&deviceId=E91204AD-3F7F-446E-A42E-BCEE5FEDFDF8&apiVer=21&city=440100" postBody:[NSString stringWithFormat:@"movie_id=%@", self.movieId] resultBlock:^(NSData *data) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.desc = dict[@"object"][@"description"];
    
//        NSArray *array1 = dic[@"stillsList"];
//        
//        self.logo = [NSMutableArray array];
//        
//        self.logo1 = [NSMutableArray array];
//        
//        for (NSDictionary *tempDict in array1)
//        {
//           [self.logo addObject:tempDict[@"logo"]];
//            
//           [self.logo1 addObject:tempDict[@"logo1"]];
//        }
        
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // headView
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCWI, 290)];
    
    // imageView
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 150, 100, 130)];
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
    self.playBtn.frame = CGRectMake(0, 0, 40, 40);
    self.playBtn.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:0.6];
    self.playBtn.center = self.topView.center;
    self.playBtn.layer.cornerRadius = 20;
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
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 150, 200, 20)];
    self.nameLabel.text = self.name;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.topView addSubview:self.nameLabel];
    
    // releaseDate
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 165, 250, 40)];
    self.dateLabel.text = [NSString stringWithFormat:@"%@上映 %@", self.releaseDate, self.area];
    self.dateLabel.font = [UIFont systemFontOfSize:15];
    self.dateLabel.numberOfLines = 2;
    self.dateLabel.textColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    [self.topView addSubview:self.dateLabel];
    
    // category
    self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 225, 200, 20)];
    self.categoryLabel.text = self.category;
    self.categoryLabel.font = [UIFont systemFontOfSize:14];
    self.categoryLabel.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:self.categoryLabel];
    
    // duration
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 250, 200, 20)];
    self.durationLabel.text = [NSString stringWithFormat:@"时长: %@", self.duration];
    self.durationLabel.font = [UIFont systemFontOfSize:14];
    self.durationLabel.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:self.durationLabel];

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
    [UIView animateWithDuration:0.0 delay:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.navigationController.navigationBarHidden = NO;
    } completion:nil];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieDetailOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"desc"];
    cell.descLabel.text = [NSString stringWithFormat:@"导演: %@\n主演: %@\n剧情: %@\n", self.director, self.actors, self.desc];
//    cell.descLabel.backgroundColor = [UIColor greenColor];
    
//    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:cell.descLabel.text];
//    NSMutableParagraphStyle *parStyle = [[NSMutableParagraphStyle alloc] init];
//    [att addAttribute:NSParagraphStyleAttributeName value:parStyle range:NSMakeRange(0, cell.descLabel.text.length)];
//    
//    parStyle.lineSpacing = 5;
//    parStyle.headIndent = 35;
//    cell.descLabel.attributedText = att;
//    [cell.descLabel sizeToFit];
    
    if (indexPath == self.selectedIndexPath) {
        
        CGRect rect = [cell.descLabel.text boundingRectWithSize:CGSizeMake(SCWI - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.descLabel.font} context:nil];
        
        self.height = rect.size.height;
        cell.descLabel.frame = CGRectMake(20, 0, SCWI - 40, self.height);
        
    }
    else
    {
        cell.descLabel.frame = CGRectMake(20, 0, SCWI - 40, 100);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath == self.selectedIndexPath) {
        return self.height;
    }
    else
    {
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.selectedIndexPath == nil) {
        self.selectedIndexPath = indexPath;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
    else
    {
//        BOOL hasSelectedOtherRow =![self.selectedIndexPath isEqual:indexPath];
        
//        NSIndexPath *temp=self.selectedIndexPath;
        self.selectedIndexPath=nil;
        
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
        
//        if(hasSelectedOtherRow){
//            self.selectedIndexPath=indexPath;
//            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }
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
