//
//  CompositeListViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 he. All rights reserved.
//

#import "CompositeListViewController.h"
#import "CompositeListCell.h"
#import "CompositeListModel.h"
#import "UIImageView+WebCache.h"
#import "CompositePlayViewController.h"
#import "DBManager.h"
#import "CompositeListModel.h"

@interface CompositeListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSMutableArray *newArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) MBProgressHUDMode *hudModel;
@property (nonatomic, strong) DBManager *manager;

@end

@implementation CompositeListViewController

-(NSMutableArray *)newArray
{
    if (_newArray == nil) {
        _newArray = [[NSMutableArray alloc]init];
    }
    return _newArray;
}

-(NSMutableArray *)listArray
{
    if (_listArray  == nil) {
        _listArray = [NSMutableArray new];
    }
    return _listArray;
}

-(void)createTableView
{
    UIImageView *compositeListImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    compositeListImageView.image = [UIImage imageNamed:@"composite-1.JPG"];
    compositeListImageView.userInteractionEnabled = YES;
    [self.view addSubview:compositeListImageView];
 
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView .dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CompositeListCell" bundle:nil] forCellReuseIdentifier:@"compositeListCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.bounces = YES;
    self.tableView.sectionIndexTrackingBackgroundColor  = [UIColor redColor];
    [compositeListImageView addSubview:_tableView];

    
}

-(void)refreshRequest
{
    [self.newArray removeAllObjects];
    NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/v1/album?albumId=%@&device=iPhone&pageId=%ld&pageSize=20&statPosition=%@",self.albumID,self.num + 1 ,self.statPosition];
    [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"data"][@"list"];
            for (NSDictionary *dic3 in array) {
            CompositeListModel *model = [[CompositeListModel alloc]init];
            [model setValuesForKeysWithDictionary:dic3];
            [self.newArray addObject:model];
        }
        NSLog(@"%@",self.newArray);
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
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic2 = dic[@"data"][@"tracks"];
        NSArray *array = dic2[@"list"];
        for (NSDictionary *dic3 in array) {
            CompositeListModel *model = [[CompositeListModel alloc]init];
            [model setValuesForKeysWithDictionary:dic3];
            [self.listArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestListData];
    [self createTableView];
    self.manager = [DBManager shareInstance];
  
   self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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
    CompositeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"compositeListCell"];
    CompositeListModel *model = self.listArray[indexPath.row];
    cell.PPmodel = model;
   
    [cell.imageviewA sd_setImageWithURL:[NSURL URLWithString:model.coverLarge]];
    cell.imageviewA.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.dayLable.text = model.likes.stringValue;
    cell.imageviewA.layer.borderWidth = 2;
    cell.titleLable.text = model.title;
    cell.countLable.text = model.duration.stringValue;
    cell.timeLable.text = model.playtimes.stringValue;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageViewBBB.layer.cornerRadius = 10;
    cell.imageViewBBB.layer.masksToBounds = YES;
    cell.imageViewBBB.layer.borderWidth = 1;
    cell.imageViewBBB.userInteractionEnabled = YES;
    cell.imageViewBBB.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.imageViewBBB.userInteractionEnabled = YES;
    
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompositeListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CompositePlayViewController *playVc = [[CompositePlayViewController alloc]init];
    playVc.compositeUrls = self.listArray;
    playVc.indexPath  = indexPath.row;
    playVc.collectModel = cell.PPmodel;
     
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
