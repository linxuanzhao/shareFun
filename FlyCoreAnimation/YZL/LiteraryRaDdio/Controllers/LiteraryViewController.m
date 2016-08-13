//
//  LiteraryViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 he. All rights reserved.
//

#import "LiteraryViewController.h"
#import "DownLoad.h"
#import "LiteraryCell.h"
#import "LiteraryModel.h"
#import "UIImageView+WebCache.h"
#import "LiteraryListViewController.h"
#import "MJRefresh.h"

@interface LiteraryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *literaryArray;


@end

@implementation LiteraryViewController

-(NSMutableArray *)literaryArray
{
    if (!_literaryArray) {
        _literaryArray = [NSMutableArray new];
    }
    return _literaryArray;
}

-(void)createTableView
{
    UIImageView *literaryImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    literaryImageView.image = [UIImage imageNamed:@"3333.JPG"];
    literaryImageView.userInteractionEnabled = YES;
    [self.view addSubview:literaryImageView];
    UIView *literaryView = [[UIView alloc]initWithFrame:self.view.bounds];
    literaryView.backgroundColor = [UIColor grayColor];
    literaryView.alpha = 0.5;
    [literaryImageView addSubview:literaryView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 375, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView .dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"LiteraryCell" bundle:nil] forCellReuseIdentifier:@"literaryCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.bounces = NO;
    self.tableView.sectionIndexTrackingBackgroundColor  = [UIColor redColor];
    [literaryImageView addSubview:_tableView];
    
    
    
    

    

    
}



-(void)requestLiteraryData
{
    [DownLoad downLoadWithUrl:@"http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=17&device=iPhone&keywordId=106&pageId=1&pageSize=20&statEvent=pageview%2Fcategory%40%E7%94%B5%E5%8F%B0&statModule=%E7%94%B5%E5%8F%B0&statPage=tab%40%E5%8F%91%E7%8E%B0_%E5%88%86%E7%B1%BB&status=0&version=5.4.21" postBody:nil resultBlock:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dict[@"list"];
        for (NSDictionary *dict1 in array) {
            LiteraryModel *model = [[LiteraryModel alloc]init];
            [model setValuesForKeysWithDictionary:dict1];
            [self.literaryArray addObject: model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestLiteraryData];
    [self createTableView];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.literaryArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiteraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"literaryCell"];
    LiteraryModel *model = self.literaryArray[indexPath.row];
    cell.titltLable.text = model.title;
    cell.descLable.text = model.intro;
    cell.countLable.text = model.playsCounts.stringValue;
    cell.trackLable.text = model.tracks.stringValue;
    [cell.ImageViewA sd_setImageWithURL:[NSURL URLWithString:model.albumCoverUrl290] placeholderImage:[UIImage imageNamed:@""]];
   
    cell.backgroundColor  = [UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.25 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    //对角线旋转
//    cell.layer.transform = CATransform3DMakeRotation(0.5, 0.5, 1, 1);
//    [UIView animateWithDuration:0.25 animations:^{
//        cell.layer.transform = CATransform3DMakeRotation(1, 1, 1, 1);
//    }];

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiteraryListViewController *listVC = [[LiteraryListViewController alloc]init];
    LiteraryModel *model = self.literaryArray[indexPath.row];
    listVC.albumID = model.desc;
    listVC.statPosition = [NSString stringWithFormat:@"%ld",indexPath.row+1];
     [self.navigationController pushViewController:listVC animated:YES];
    
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
