//
//  NewsViewController.m
//  YzlRadio
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"
#import "NewsModel.h"
#import "UIImageView+WebCache.h"
#import "NewsDetailViewController.h"
#import "DownLoad.h"


@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *newsArray;

@end

@implementation NewsViewController

-(NSMutableArray *)newsArray
{
    if (_newsArray == nil) {
        _newsArray  = [[NSMutableArray alloc]init];
    }
    return _newsArray;
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView .dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"newsCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"天下新闻";
    [self requestNewsData];
    [self createTableView];
}

-(void)requestNewsData
{
    [DownLoad downLoadWithUrl:@"http://180.153.255.5/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=17&device=iPhone&keywordId=101&pageId=1&pageSize=20&statEvent=pageview%2Fcategory%40%E7%94%B5%E5%8F%B0&statModule=%E7%94%B5%E5%8F%B0&statPage=tab%40%E5%8F%91%E7%8E%B0_%E5%88%86%E7%B1%BB&status=0&version=5.4.21" postBody:nil resultBlock:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"list"];
        for (NSDictionary *dict in array) {
            NewsModel *model = [[NewsModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.newsArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
    
}
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    NewsModel *model = self.newsArray[indexPath.row];
    cell.titleLable.text = model.title;
    cell.descLable.text = model.intro;
    cell.countLable.text = model.playsCounts.stringValue;
    cell.trackLable.text = model.tracks.stringValue;
    [cell.handleImageView sd_setImageWithURL:[NSURL URLWithString:model.albumCoverUrl290] placeholderImage:[UIImage imageNamed:@"c1.jpg"]];
    cell.ImageV.layer.cornerRadius = 10;
    cell.ImageV.layer.masksToBounds = YES;
    
    cell.handleImageView.layer.cornerRadius = 10;
    cell.handleImageView.layer.masksToBounds = YES;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsCell *shotCell = (NewsCell *) cell;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)];
    
    scaleAnimation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [shotCell.layer addAnimation:scaleAnimation forKey:@"transform"];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewController *detailVc = [[NewsDetailViewController alloc]init];
    NewsModel *model = self.newsArray[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    detailVc.statPosition = str;
    detailVc.albumId = model.desc;
    [self.navigationController pushViewController:detailVc animated:YES];
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
