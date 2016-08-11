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

@interface LiteraryListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation LiteraryListViewController

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
    ListImageView.image = [UIImage imageNamed:@"3333.JPG"];
    ListImageView.userInteractionEnabled = YES;
    [self.view addSubview:ListImageView];
    UIView *listView = [[UIView alloc]initWithFrame:self.view.bounds];
    listView.backgroundColor = [UIColor grayColor];
    listView.alpha = 0.5;
    [ListImageView addSubview:listView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 375, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView .dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"LiteraryListCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.bounces = NO;
    self.tableView.sectionIndexTrackingBackgroundColor  = [UIColor redColor];
    [ListImageView addSubview:_tableView];
}

-(void)requestListData
{
    NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/v1/album?albumId=%@&device=iPhone&pageSize=20&statPosition=%@",self.albumID,self.statPosition];
    [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
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
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestListData];
    [self createTableView];
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiteraryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    LiteraryListModel *model = self.listArray[indexPath.row];
    [cell.imageViewA sd_setImageWithURL:[NSURL URLWithString:model.coverLarge]];
    cell.timeLable.text = model.playtimes.stringValue;
    cell.titleLable.text = model.title;
    cell.dayLable.text = model.likes.stringValue;
    cell.countLable.text = model.duration.stringValue;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
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
