//
//  StoryListViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 he. All rights reserved.
//

#import "StoryListViewController.h"
#import "DownLoad.h"
#import "LisstModel.h"
#import "ListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "StoryPlayViewController.h"
#import "DBManager.h"
#import "CompositeListModel.h"

@interface StoryListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSMutableArray *newArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) CompositeListModel *listModel;
@property (nonatomic, strong) DBManager *manager;

@end

@implementation StoryListViewController

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
        _listArray = [[NSMutableArray alloc]init];
    }
    return _listArray;
}

-(void)createTableView
{
    
    UIImageView *storyImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    storyImage.image = [UIImage imageNamed:@"story-1.JPG"];
    storyImage.userInteractionEnabled = YES;
    [self.view addSubview: storyImage];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellStyleDefault;
    [self.view addSubview:_tableView];
}


-(void)refreshRequest
{
    [self.newArray removeAllObjects];
    NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/v1/album/track?albumId=%@&device=iPhone&isAsc=true&pageId=%ld&pageSize=10&statPosition=%@",self.albumId,self.num + 1,self.statPosition];
    [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
        NSDictionary *DIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = DIC[@"data"][@"list"];
        for (NSDictionary *dic2 in array) {
            LisstModel *model = [[LisstModel alloc]init];
            [model setValuesForKeysWithDictionary:dic2];
            [self.newArray addObject:model];
        }
        [self.listArray addObjectsFromArray:self.newArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
    }];

}


-(void)requestData
{
    NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/v1/album?albumId=%@&device=iPhone&pageSize=20&statPosition=%@",self.albumId,self.statPosition];
    [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
        NSDictionary *DIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic1 = DIC[@"data"][@"tracks"];
        NSArray *array = dic1[@"list"];
        for (NSDictionary *dic2 in array) {
            LisstModel *model = [[LisstModel alloc]init];
            [model setValuesForKeysWithDictionary:dic2];
            [self.listArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self createTableView];
    self.manager = [DBManager shareInstance];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = self.listArray.count == 0;
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    LisstModel *model = self.listArray[indexPath.row];
    cell.model  = (CompositeListModel *)model;
    [cell.imageViewA sd_setImageWithURL:[NSURL URLWithString:model.coverSmall] placeholderImage:[UIImage imageNamed:@"2.png"]];
    cell.imageViewA.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.imageViewA.layer.borderWidth = 2;
    
    cell.titleLable.text = model.title;
    cell.countLable.text = model.duration.stringValue;
    cell.timeLabel.text = model.playtimes.stringValue;
    cell.dayLable.text = model.likes.stringValue;
    cell.bottomImageView.layer.cornerRadius = 10;
    cell.bottomImageView.layer.masksToBounds = YES;
    cell.bottomImageView.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.bottomImageView.layer.borderWidth = 1;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bottomImageView.userInteractionEnabled = YES;

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    StoryPlayViewController *playVc = [[StoryPlayViewController alloc]init];
    LisstModel *model = self.listArray[indexPath.row];
    playVc.storyUrls = self.listArray;
    playVc.indexPath = indexPath.row;
    playVc.title = model.title;
    playVc.collectModel = cell.model;
    
    [self.navigationController pushViewController:playVc animated:YES];
    
    
    
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
