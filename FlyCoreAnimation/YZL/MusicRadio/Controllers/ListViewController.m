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

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ListViewController

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellReuseIdentifier:@"firstCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
      _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}


-(void)requestData
{
    NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/v1/album?albumId=%@&device=iPhone&pageSize=20&statPosition=%@",self.albumId,self.statPosition];
    
    [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];       NSDictionary *dic1 = dic[@"data"][@"tracks"];
        NSArray *arr = dic1[@"list"];
        NSLog(@"%@",arr);
            for (NSDictionary *dc2 in arr) {
                ListModel *model = [[ListModel alloc]init];
                [model setValuesForKeysWithDictionary:dc2];
                [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.Name;
    [self requestData];
    [self createTableView];
    
//    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.view.backgroundColor = [UIColor clearColor];
//    imageView1.image = [UIImage imageNamed:@"a2.JPG"];
//    [self.view addSubview:imageView1];
    
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    
    ListModel *model = self.dataArray[indexPath.row];
    cell.imageBB.layer.cornerRadius = 30;
    cell.imageBB.layer.masksToBounds = YES;
    [cell.imageBB sd_setImageWithURL:[NSURL URLWithString:model.coverLarge]];
    cell.countLable.text = model.playtimes.stringValue;
    cell.titleLable.text = model.title;
    cell.dayLable.text = model.likes.stringValue;
    cell.beijingImagevIew.layer.cornerRadius = 10;
    cell.beijingImagevIew.layer.masksToBounds = YES;
    float num = [model.duration floatValue]/60;
    NSString *str = [NSString stringWithFormat:@"%.2f",num];
    
    cell.timeLable.text = str;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadioPlayViewController *playVc = [[RadioPlayViewController alloc]init];
    ListModel *model = self.dataArray[indexPath.row];
    playVc.urls = self.dataArray;
    playVc.number = indexPath.row;
    playVc.name = model.title;
    [self.navigationController pushViewController:playVc animated:YES];
    
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
