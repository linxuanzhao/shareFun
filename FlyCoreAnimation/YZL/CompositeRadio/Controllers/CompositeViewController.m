//
//  CompositeViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/11.
//  Copyright © 2016年 he. All rights reserved.
//

#import "CompositeViewController.h"
#import "CompositeCell.h"
#import "CompositeModel.h"
#import "UIImageView+WebCache.h"   
#import "CompositeListViewController.h"

@interface CompositeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *CompositeArray;
@property (nonatomic, strong) NSMutableArray *newArray;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation CompositeViewController

-(NSMutableArray *)newArray
{
    if (_newArray == nil) {
        _newArray = [[NSMutableArray alloc]init];
    }
    return _newArray;
}

-(NSMutableArray *)CompositeArray
{
    if (_CompositeArray == nil) {
        _CompositeArray = [[NSMutableArray alloc]init];
    }
    return _CompositeArray;
}

-(void)createTableView
{
    UIImageView *compositeImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    compositeImageView.image = [UIImage imageNamed:@"composite-1.JPG"];
    compositeImageView.userInteractionEnabled = YES;
    [self.view addSubview:compositeImageView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView .dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CompositeCell" bundle:nil] forCellReuseIdentifier:@"compositeCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.bounces = YES;
    self.tableView.sectionIndexTrackingBackgroundColor  = [UIColor redColor];
    [compositeImageView addSubview:_tableView];
}

-(void)refreshRequest
{
    [self.newArray removeAllObjects];
    NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=17&device=iPhone&keywordId=113&pageId=%ld&pageSize=20&status=0&version=5.4.21",self.num + 1];
    [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dict[@"list"];
        for (NSDictionary *dic2  in array) {
            CompositeModel *model = [[CompositeModel alloc]init];
            [model setValuesForKeysWithDictionary:dic2];
            [self.newArray addObject:model];
        }
        [self.CompositeArray addObjectsFromArray:self.newArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
        
    }];
}


-(void)requestCompositeData
{
    [DownLoad downLoadWithUrl:@"http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=17&device=iPhone&keywordId=113&pageId=1&pageSize=20&statEvent=pageview%2Fcategory%40%E7%94%B5%E5%8F%B0&statModule=%E7%94%B5%E5%8F%B0&statPage=tab%40%E5%8F%91%E7%8E%B0_%E5%88%86%E7%B1%BB&status=0&version=5.4.21" postBody:nil resultBlock:^(NSData *data) {
        if (data != nil) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dict[@"list"];
        for (NSDictionary *dic2  in array) {
            CompositeModel *model = [[CompositeModel alloc]init];
            [model setValuesForKeysWithDictionary:dic2];
            [self.CompositeArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"综合台";
    [self requestCompositeData];
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
    self.tableView.mj_footer.hidden = self.CompositeArray.count == 0;
    return self.CompositeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompositeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"compositeCell"];
    CompositeModel *model = self.CompositeArray[indexPath.row];
    cell.titleLable.text = model.title;
    cell.descLable.text = model.intro;
    cell.countLable.text = model.playsCounts.stringValue;
    cell.trcakLabel.text = model.tracks.stringValue;
    [cell.imageViewA sd_setImageWithURL:[NSURL URLWithString:model.albumCoverUrl290]];
    cell.backgroundColor = [UIColor clearColor];
    cell.imageViewA.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.imageViewA.layer.borderWidth = 2;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageViewBVBBB.layer.borderWidth = 1;
    cell.imageViewBVBBB.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.imageViewBVBBB.layer.cornerRadius = 10;
    cell.imageViewBVBBB.layer.masksToBounds = YES;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompositeListViewController *listVc = [[CompositeListViewController alloc]init];
    CompositeModel *model = self.CompositeArray[indexPath.row];
    listVc.albumID = model.desc;
    listVc.statPosition = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    listVc.title  = model.title;
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
