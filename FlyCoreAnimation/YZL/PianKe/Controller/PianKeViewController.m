//
//  PianKeViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/16.
//  Copyright © 2016年 he. All rights reserved.
//

#import "PianKeViewController.h"
#import "DownLoad.h"
#import "PKModel.h"
#import "PKListViewController.h"
#import "NetWorkRequestManager.h"
#import "PKListCell.h"

@interface PianKeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *pkArray;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, strong) NSMutableArray *newArray;
@property (nonatomic, strong) MBProgressHUD *hud;

@end


@implementation PianKeViewController

-(NSMutableArray *)newArray
{
    if (_newArray == nil) {
        _newArray = [[NSMutableArray alloc]init];
    }
    return _newArray;
}

-(NSMutableArray *)pkArray
{
    if (_pkArray == nil) {
        _pkArray = [[NSMutableArray alloc]init];
    }
    return _pkArray;
}

-(void)createTableView
{
    UIImageView *pkImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    pkImageView.image = [UIImage imageNamed:@"pk-1.JPG"];
    pkImageView.userInteractionEnabled = YES;
    [self.view addSubview:pkImageView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"PKListCell" bundle:nil] forCellReuseIdentifier:@"pkListCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [pkImageView addSubview:_tableView];
    
}


-(void)refreshData
{
    [self.newArray removeAllObjects];
    NSDictionary *dic = @{@"client":@"1",@"deviceid":@"63A94D37-33F9-40FF-9EBB-481182338873",@"auth":@"", @"start":[NSString stringWithFormat:@"%ld", (long)_start]};
    [NetWorkRequestManager requestWithType:POST url:@"http://api2.pianke.me/ting/radio_list" para:dic finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"data"][@"list"];
        for (NSDictionary *dict in array) {
            PKModel *model = [[PKModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.newArray addObject:model];
        }
        [self.pkArray addObjectsFromArray:self.newArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestData
{
    [DownLoad downLoadWithUrl:@"http://api2.pianke.me/ting/radio" postBody:nil resultBlock:^(NSData *data) {
        if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"data"][@"alllist"];
        for (NSDictionary *dict in array) {
            PKModel *model = [[PKModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.pkArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self requestData];
    [self createTableView];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self refreshData];

        self.start += 10;
        NSLog(@"%ld",self.start);
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
    _tableView.mj_footer.hidden = self.pkArray.count == 0;
    return self.pkArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pkListCell"];
    PKModel *model = self.pkArray[indexPath.row];
    [cell.imageViewA sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    cell.imageViewA.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.imageViewA.layer.borderWidth = 2;
    cell.imageViewB.layer.cornerRadius = 10;
    cell.imageViewB.layer.masksToBounds = YES;
    cell.imageViewB.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.imageViewB.layer.borderWidth = 1;
    cell.titleLable.text = model.desc;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKListViewController *listVc = [[PKListViewController alloc]init];
    PKModel *model = self.pkArray[indexPath.row];
    listVc.redioid = model.radioid;
    listVc.image = model.coverimg;
    listVc.str = model.title;
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
