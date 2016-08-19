//
//  PKListViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/16.
//  Copyright © 2016年 he. All rights reserved.
//

#import "PKListViewController.h"
#import "NetWorkRequestManager.h"
#import "PKListModel.h"
#import "PKTableViewCell.h"
#import "PKPlayViewController.h"

@interface PKListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, strong) NSMutableArray *newArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation PKListViewController

-(NSMutableArray *)newArray
{
    if (_newArray == nil) {
        _newArray = [[NSMutableArray alloc]init];
    }
    return _newArray;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)creatrTableView
{
    UIImageView *pkImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    pkImageView.image = [UIImage imageNamed:@"pk-1.JPG"];
    pkImageView.userInteractionEnabled = YES;
    [self.view addSubview:pkImageView];
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 180)];
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:_image]];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.tableHeaderView = imageView1;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [pkImageView addSubview:_tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PKTableViewCell" bundle:nil] forCellReuseIdentifier:@"pkCell"];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self creatrTableView];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self refreshData];
        self.start += 10;
    }];
    _hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.dimBackground = YES;
}



-(void)refreshData
{
    [self.newArray removeAllObjects];
    NSDictionary *dic = @{@"radioid":self.redioid, @"auth":@"Wc06FCrkoq1DCMVzGMTikDJxQ8bm3Mrm2NpT9qWjwzcWP23tBKQx1c4P", @"start":[NSString stringWithFormat:@"%ld", _start]};
    [NetWorkRequestManager requestWithType:POST url:@"http://api2.pianke.me/ting/radio_detail_list" para:dic finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dict[@"data"][@"list"];
        for (NSDictionary *dict2 in array) {
            PKListModel *model = [[PKListModel alloc]init];
            [model setValuesForKeysWithDictionary:dict2];
            [self.newArray addObject:model];
        }
        [self.dataArray addObjectsFromArray:self.newArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
        
    } error:^(NSError *error) {
        
    }];
}


-(void)requestData
{
    NSDictionary *dic = @{@"radioid":_redioid};
    
    [NetWorkRequestManager requestWithType:POST url:@"http://api2.pianke.me/ting/radio_detail" para:dic finish:^(NSData *data) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
      
        NSArray *array = dict[@"data"][@"list"];
            for (NSDictionary *dict1 in array) {
                PKListModel *model = [[PKListModel alloc]init];
                [model setValuesForKeysWithDictionary:dict1];
                [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } error:
     ^(NSError *error) {
         
     }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = self.dataArray.count == 0;
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pkCell"];
    PKListModel *model = self.dataArray[indexPath.row];
    cell.titleLable.text = model.title;
    [cell.ImageViewBBB sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    cell.ImageViewBBB.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.ImageViewBBB.layer.borderWidth = 2;
    cell.ImageViewAAA.layer.borderWidth = 1;
    cell.ImageViewAAA.layer.cornerRadius = 10;
    cell.ImageViewAAA.layer.masksToBounds = YES;
    cell.ImageViewAAA.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKPlayViewController *playVc = [[PKPlayViewController alloc]init];
    PKListModel *model = self.dataArray[indexPath.row];
    playVc.titleA = model.title;
    playVc.indexPath = indexPath.row;
    playVc.pkUrls = self.dataArray;
    
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
