//
//  StoryViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 he. All rights reserved.
//

#import "StoryViewController.h"
#import "DownLoad.h"
#import "StoryModel.h"
#import "StoryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "StoryListViewController.h"

@interface StoryViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *storyArray;
@property (nonatomic, strong) NSMutableArray *newArray;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation StoryViewController

-(NSMutableArray *)newArray
{
    if (_newArray == nil) {
        _newArray = [[NSMutableArray alloc]init];
    }
    return _newArray;
}

-(NSMutableArray *)storyArray
{
    if (!_storyArray) {
        _storyArray = [[NSMutableArray alloc]init];
    }
    return _storyArray;
}

-(void)createTableView
{
    
    UIImageView *storyImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    storyImage.image = [UIImage imageNamed:@"story-1.JPG"];
   // storyImage.contentMode = UIViewContentModeScaleAspectFill;
    storyImage.userInteractionEnabled = YES;
    [self.view addSubview: storyImage];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"StoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"storyCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [storyImage addSubview:_tableView];
}

-(void)refreshRequest
{
    [self.newArray removeAllObjects];
    NSString *str1 = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=17&device=iPhone&keywordId=107&pageId=%ld&pageSize=20&version=5.4.21",self.num + 1];
    [DownLoad downLoadWithUrl:str1 postBody:nil resultBlock:^(NSData *data) {
        if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = [dic valueForKey:@"list"];
        for (NSDictionary *dict in array) {
            StoryModel *model = [[StoryModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.newArray addObject:model];
        }
        [self.storyArray addObjectsFromArray:self.newArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
        }
    }];

    
}


-(void)requestStoryData
{
    [DownLoad downLoadWithUrl:@"http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=17&device=iPhone&keywordId=107&pageId=1&pageSize=20&statEvent=pageview%2Fcategory%40%E7%94%B5%E5%8F%B0&statModule=%E7%94%B5%E5%8F%B0&statPage=tab%40%E5%8F%91%E7%8E%B0_%E5%88%86%E7%B1%BB&status=0&version=5.4.21" postBody:nil resultBlock:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = [dic valueForKey:@"list"];
        for (NSDictionary *dict in array) {
            StoryModel *model = [[StoryModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.storyArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self requestStoryData];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _tableView.mj_footer.hidden = self.storyArray.count == 0;
    return self.storyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell"];
    StoryModel *model = self.storyArray[indexPath.row];
    cell.titleLable.text = model.title;
    cell.descLable.text = model.intro;
    cell.countLable.text = model.playsCounts.stringValue;
    cell.trackLable.text = model.tracks.stringValue;
    [cell.imageViewA sd_setImageWithURL:[NSURL URLWithString:model.albumCoverUrl290] placeholderImage:[UIImage imageNamed:@"2.png"]];
    cell.imageViewA.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.imageViewA.layer.borderWidth = 2;
    cell.bottomImageView.layer.cornerRadius = 5;
    cell.bottomImageView.layer.masksToBounds = YES;
    cell.bottomImageView.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.bottomImageView.layer.borderWidth = 1;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryListViewController *listVc = [[StoryListViewController alloc]init];
    StoryModel *model = self.storyArray[indexPath.row];
    listVc.albumId = model.desc;
    NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    listVc.statPosition = str;
    [self.navigationController pushViewController:listVc animated:YES];
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
