//
//  NewsDetailViewController.m
//  YzlRadio
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "DownLoad.h"
#import "UIImageView+WebCache.h"
#import "NewsDetailModel.h"
#import "NewsDetailCell.h"
#import "NewsPlayViewController.h"
#import "CompositeListModel.h"
#import "DBManager.h"

@interface NewsDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *detailArray;
@property (nonatomic, assign) NSInteger detaNum;
@property (nonatomic, strong) NSMutableArray *arrayNew;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) DBManager *manager;
@property (nonatomic, strong) CompositeListModel *listModel;
@end

@implementation NewsDetailViewController

-(NSMutableArray *)arrayNew
{
    if (_arrayNew == nil) {
        _arrayNew = [NSMutableArray new];
    }
    return _arrayNew;
}

-(NSMutableArray *)detailArray
{
    if (_detailArray == nil) {
        _detailArray = [[NSMutableArray alloc]init];
    }
    return _detailArray;
}

-(void)cretateTableView
{
    UIImageView *newsImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    newsImageView.image = [UIImage imageNamed:@"news-1.JPG"];
    newsImageView.userInteractionEnabled = YES;
    [self.view addSubview:newsImageView];
//    UIView *newsView = [[UIView alloc]initWithFrame:self.view.bounds];
//    newsView.backgroundColor = [UIColor grayColor];
//    newsView.alpha = 0.5;
//    [newsImageView addSubview:newsView];
   
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height
                                                              ) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"NewsDetailCell" bundle:nil] forCellReuseIdentifier:@"newsDetaCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [newsImageView addSubview:_tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestNewsDetailData];
    [self cretateTableView];
    self.manager = [DBManager shareInstance];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

            self.detaNum += 1;
            NSLog(@"%ld",self.detaNum);
            [self refreshRequest];
    }];
    _hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.activityIndicatorColor = [UIColor blackColor];
    _hud.color = [UIColor clearColor];
    _hud.labelColor = [UIColor blackColor];
    _hud.labelFont = [UIFont systemFontOfSize:14];
    _hud.labelText = @"~主淫,马上就加载好了哦~";
    
}


-(void)refreshRequest
{
    [self.arrayNew removeAllObjects];
    NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/v1/album/track?albumId=%@&device=iPhone&isAsc=true&pageId=%ld&pageSize=20&statPosition=%@",self.albumId,self.detaNum + 1,self.statPosition];
    [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"data"][@"list"];
            for (NSDictionary *dict in array) {
            NewsDetailModel *model = [[NewsDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.arrayNew addObject:model];
        }
     
        [self.detailArray addObjectsFromArray:self.arrayNew];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
        
    }];
}

-(void)requestNewsDetailData
{

       NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/v1/album/track?albumId=%@&device=iPhone&isAsc=true&pageId=1&pageSize=20&statPosition=%@",self.albumId,self.statPosition];
    [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
        if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"data"][@"list"];
        for (NSDictionary *dict in array) {
            NewsDetailModel *model = [[NewsDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.detailArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        }
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _tableView.mj_footer.hidden = self.detailArray == 0;
    return self.detailArray.count;
}

-( UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsDetaCell"];
    NewsDetailModel *model = self.detailArray[indexPath.row];
    cell.model = (CompositeListModel *)model;
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.coverLarge] placeholderImage:[UIImage imageNamed:@"c1.jpg"]];
    cell.countLable.text = model.playtimes.stringValue;
    cell.dayLable.text = model.likes.stringValue;
    cell.titleImageView.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.titleImageView.layer.borderWidth = 2;
    float num = [model.duration floatValue]/60;
    NSString *str = [NSString stringWithFormat:@"%.2f",num];
    cell.tracksLable.text = str;
    cell.title.text = model.title;
    cell.imageV.layer.cornerRadius = 10;
    cell.imageV.layer.masksToBounds = YES;
    cell.imageV.layer.borderWidth = 1;
    cell.imageV.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.imageV.userInteractionEnabled = YES;

//    cell.titleImageView.layer.cornerRadius = 10;
//    cell.titleImageView.layer.masksToBounds = YES;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NewsPlayViewController *playVc = [[NewsPlayViewController alloc]init];
    NewsDetailModel *model = self.detailArray[indexPath.row];
    playVc.urls = self.detailArray;
    playVc.number = indexPath.row;
    playVc.collectModel = cell.model;
    playVc.name = model.title;
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
