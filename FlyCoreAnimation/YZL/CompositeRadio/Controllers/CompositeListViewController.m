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

@interface CompositeListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation CompositeListViewController

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
    compositeListImageView.image = [UIImage imageNamed:@"3333.JPG"];
    compositeListImageView.userInteractionEnabled = YES;
    [self.view addSubview:compositeListImageView];
    UIView *compositeListView = [[UIView alloc]initWithFrame:self.view.bounds];
    compositeListView.backgroundColor = [UIColor grayColor];
    compositeListView.alpha = 0.5;
    [compositeListImageView addSubview:compositeListView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 375, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView .dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CompositeListCell" bundle:nil] forCellReuseIdentifier:@"compositeListCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.bounces = NO;
    self.tableView.sectionIndexTrackingBackgroundColor  = [UIColor redColor];
    [compositeListImageView addSubview:_tableView];

    
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
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompositeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"compositeListCell"];
    CompositeListModel *model = self.listArray[indexPath.row];
    
    [cell.imageviewA sd_setImageWithURL:[NSURL URLWithString:model.coverLarge]];
    cell.titleLable.text = model.title;
    cell.countLable.text = model.duration.stringValue;
    cell.timeLable.text = model.playtimes.stringValue;
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
