//
//  LiteraryListViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 he. All rights reserved.
//

#import "LiteraryListViewController.h"
#import "DownLoad.h"
#import "LiteraryListModel.h"
#import "LiteraryListCell.h"
#import "UIImageView+WebCache.h"
#import "LiteraryPlayViewController.h"
#import "CompositeListModel.h"
#import "DBManager.h"

@interface LiteraryListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *newArray;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) DBManager *manager;
@property (nonatomic, strong) CompositeListModel *listmodel;
@end

@implementation LiteraryListViewController

-(NSMutableArray *)newArray
{
    if (_newArray == nil) {
        _newArray = [[NSMutableArray alloc]init];
    }
    return _newArray;
}

-(NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray new];
    }
    return _listArray;
}

-(void)createTableView
{
    UIImageView *ListImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    ListImageView.image = [UIImage imageNamed:@"literary.JPG"];
    ListImageView.userInteractionEnabled = YES;
    [self.view addSubview:ListImageView];
 
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView .dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"LiteraryListCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.bounces = YES;
    self.tableView.sectionIndexTrackingBackgroundColor  = [UIColor redColor];
    [ListImageView addSubview:_tableView];
}

-(void)refreshRequest
{
    [self.newArray removeAllObjects];
    NSString *str1 = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/v1/album/track?albumId=%@&device=iPhone&isAsc=true&pageId=%ld&pageSize=20&statPosition=%@",self.albumID,self.num + 1,self.statPosition];
    [DownLoad downLoadWithUrl:str1 postBody:nil resultBlock:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"data"][@"list"];
        for (NSDictionary *dict3 in array) {
            LiteraryListModel *model = [[LiteraryListModel alloc]init];
            [model setValuesForKeysWithDictionary:dict3];
            [self.newArray addObject:model];
        }
        [self.listArray addObjectsFromArray:self.newArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
        
    }];

    
}

-(void)requestListData
{
    NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/v1/album?albumId=%@&device=iPhone&pageSize=20&statPosition=%@",self.albumID,self.statPosition];
    [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
        if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict2 = dic[@"data"][@"tracks"];
        NSArray *array = dict2[@"list"];
        for (NSDictionary *dict3 in array) {
            LiteraryListModel *model = [[LiteraryListModel alloc]init];
            [model setValuesForKeysWithDictionary:dict3];
            [self.listArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [DBManager shareInstance];
    [self requestListData];
    [self createTableView];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.num += 1;
        [self refreshRequest];
    }];
    _hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.activityIndicatorColor = [UIColor blackColor];
    _hud.color = [UIColor clearColor];
    _hud.labelColor = [UIColor blackColor];
    _hud.labelFont = [UIFont systemFontOfSize:14];
    _hud.labelText = @"~主淫,马上就加载好了哦~";
}



-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = self.listArray.count == 0;
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiteraryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    LiteraryListModel *model = self.listArray[indexPath.row];
    cell.model = (CompositeListModel *)model;
    [cell.imageViewA sd_setImageWithURL:[NSURL URLWithString:model.coverLarge]];
    cell.timeLable.text = model.playtimes.stringValue;
    cell.titleLable.text = model.title;
    cell.dayLable.text = model.likes.stringValue;
    cell.countLable.text = model.duration.stringValue;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageViewA.layer.borderWidth = 2;
    cell.imageViewA.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.listImageView.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.listImageView.layer.borderWidth = 1;
    cell.listImageView.layer.cornerRadius = 10;
    cell.listImageView.layer.masksToBounds = YES;
    cell.listImageView.userInteractionEnabled = YES;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiteraryListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LiteraryPlayViewController *playVC = [[LiteraryPlayViewController alloc]init];
    LiteraryListModel *model = self.listArray[indexPath.row];
    playVC.literaryUrls = self.listArray;
    playVC.indexPath = indexPath.row;
    playVC.collectModel = cell.model;
    playVC.title = model.title;
    
    [self.navigationController pushViewController:playVC animated:YES];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_hud hide:YES];
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
