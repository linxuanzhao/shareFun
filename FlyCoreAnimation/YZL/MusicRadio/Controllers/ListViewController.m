//
//  ListViewController.m
//  YzlRadio
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import "ListViewController.h"
#import "ListCell.h"
#import "ListModel.h"
#import "DownLoad.h"
#import "UIImageView+WebCache.h"
#import "RadioPlayViewController.h"
#import "CompositeListModel.h"
#import "DBManager.h"



@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSMutableArray *refreshArray;
@property (nonatomic, strong) NSMutableSet *mSet;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) DBManager *manager;
@property (nonatomic, strong) CompositeListModel *listModel;

@end

@implementation ListViewController

-(NSMutableSet *)mSet
{
    if (_mSet == nil) {
        _mSet = [[NSMutableSet alloc]init];
    }
    return _mSet;
}

-(NSMutableArray *)refreshArray
{
    if (_refreshArray == nil) {
        _refreshArray = [[NSMutableArray alloc]init];
    }
    return _refreshArray;
}

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)createTableView
{
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView1.image = [UIImage imageNamed:@"music-1.JPG"];
    imageView1.userInteractionEnabled = YES;
    [self.view addSubview: imageView1];
//    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:imageView1.frame];
//    toolbar.barStyle = UIBarStyleBlackOpaque;
//    [imageView1 addSubview:toolbar];
    imageView1.alpha = 0.8;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellReuseIdentifier:@"firstCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
      _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [imageView1 addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    
    
}


-(void)refreshRequset
{
    [self.refreshArray removeAllObjects];
    NSString *str1 = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/v1/album/track?albumId=%@&device=iPhone&isAsc=true&pageId=%ld&pageSize=10&statPosition%@",self.albumId,self.num + 1,self.statPosition];
    [DownLoad downLoadWithUrl:str1 postBody:nil resultBlock:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = dic[@"data"][@"list"];
        for (NSDictionary *dc2 in arr) {
            ListModel *model = [[ListModel alloc]init];
            [model setValuesForKeysWithDictionary:dc2];
            [self.refreshArray addObject:model];
        }
        
        [self.dataArray addObjectsFromArray:self.refreshArray];
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
        if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic1 = dic[@"data"][@"tracks"];
        NSArray *arr = dic1[@"list"];
            for (NSDictionary *dc2 in arr) {
                ListModel *model = [[ListModel alloc]init];
                [model setValuesForKeysWithDictionary:dc2];
                [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.Name;
    [self requestData];
    [self createTableView];
    self.manager = [DBManager shareInstance];
//    self.view.backgroundColor = [UIColor clearColor];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _num += 1;
        [self refreshRequset];
    }];
    _hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.dimBackground = YES;


    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _tableView.mj_footer.hidden = self.dataArray.count == 0;
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    ListModel *model = self.dataArray[indexPath.row];
    cell.model  = (CompositeListModel *)model;
    //cell.imageBB.layer.cornerRadius = 30;
    //cell.imageBB.layer.masksToBounds = YES;
    [cell.imageBB sd_setImageWithURL:[NSURL URLWithString:model.coverLarge]];
    cell.imageBB.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.imageBB.layer.borderWidth = 2;
    cell.countLable.text = model.playtimes.stringValue;
    cell.titleLable.text = model.title;
    cell.dayLable.text = model.likes.stringValue;
    cell.beijingImagevIew.layer.cornerRadius = 10;
    cell.beijingImagevIew.layer.masksToBounds = YES;
    cell.beijingImagevIew.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.beijingImagevIew.layer.borderWidth = 1;
    cell.backgroundColor  = [UIColor clearColor];
    float num = [model.duration floatValue]/60;
    NSString *str = [NSString stringWithFormat:@"%.2f",num];
    cell.timeLable.text = str;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    RadioPlayViewController *playVc = [[RadioPlayViewController alloc]init];
    ListModel *model = self.dataArray[indexPath.row];
    playVc.urls = self.dataArray;
    playVc.number = indexPath.row;
    playVc.collectModel = cell.model;
    playVc.name = model.title;
    [self.navigationController pushViewController:playVc animated:YES];
    
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_hud hide:YES];
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.25 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
