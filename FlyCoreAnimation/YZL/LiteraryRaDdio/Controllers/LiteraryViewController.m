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
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSMutableArray *newArray;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation LiteraryViewController

-(NSMutableArray *)newArray
{
    if (_newArray == nil) {
        _newArray = [[NSMutableArray alloc]init];
    }
    return _newArray;
}

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
    literaryImageView.image = [UIImage imageNamed:@"literary.JPG"];
    literaryImageView.userInteractionEnabled = YES;
    [self.view addSubview:literaryImageView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView .dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"LiteraryCell" bundle:nil] forCellReuseIdentifier:@"literaryCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.bounces = YES;
    [literaryImageView addSubview:_tableView];

}

-(void)refreshrequest
{
    [self.newArray removeAllObjects];
    NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=17&device=iPhone&keywordId=106&pageId=%ld&pageSize=20&status=0&version=5.4.21",self.num + 1];
    [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dict[@"list"];
        for (NSDictionary *dict1 in array) {
            LiteraryModel *model = [[LiteraryModel alloc]init];
            [model setValuesForKeysWithDictionary:dict1];
            [self.newArray addObject: model];
        }
        [self.literaryArray addObjectsFromArray:self.newArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
    }];

}

-(void)requestLiteraryData
{
    [DownLoad downLoadWithUrl:@"http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=17&device=iPhone&keywordId=106&pageId=1&pageSize=20&statEvent=pageview%2Fcategory%40%E7%94%B5%E5%8F%B0&statModule=%E7%94%B5%E5%8F%B0&statPage=tab%40%E5%8F%91%E7%8E%B0_%E5%88%86%E7%B1%BB&status=0&version=5.4.21" postBody:nil resultBlock:^(NSData *data) {
        if (data != nil) {
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
        }

    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestLiteraryData];
    [self createTableView];
    self.title = @"文艺台";
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.num += 1;
        [self refreshrequest];
    }];
    _hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.activityIndicatorColor = [UIColor blackColor];
    _hud.color = [UIColor clearColor];
    _hud.labelColor = [UIColor blackColor];
    _hud.labelFont = [UIFont systemFontOfSize:14];
    _hud.labelText = @"~主淫,马上就加载好了哦~";

    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = self.literaryArray.count == 0;
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
    cell.ImageViewA.layer.borderWidth = 2;
    cell.ImageViewA.layer.borderColor  = [[UIColor whiteColor]CGColor];
    cell.cellImageView.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.cellImageView.layer.borderWidth = 1;
    cell.backgroundColor  = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellImageView.layer.cornerRadius = 10;
    cell.cellImageView.layer.masksToBounds = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_hud hide:YES];
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
    listVC.title = model.title;
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
