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

@interface NewsDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *detailArray;

@end

@implementation NewsDetailViewController

-(NSMutableArray *)detailArray
{
    if (_detailArray == nil) {
        _detailArray = [[NSMutableArray alloc]init];
    }
    return _detailArray;
}

-(void)cretateTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"NewsDetailCell" bundle:nil] forCellReuseIdentifier:@"newsDetaCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestNewsDetailData];
    [self cretateTableView];
    
}

-(void)requestNewsDetailData
{
       NSString *str = [NSString stringWithFormat:@"http://180.153.255.5/mobile/v1/album?albumId=%@&device=iPhone&pageSize=20&source=5&statPosition=%@",self.albumId,self.statPosition];
    [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSDictionary *dic1 = dic[@"data"][@"tracks"];
        NSArray *array = dic1[@"list"];
        for (NSDictionary *dict in array) {
            NewsDetailModel *model = [[NewsDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.detailArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailArray.count;
}

-( UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsDetaCell"];
    NewsDetailModel *model = self.detailArray[indexPath.row];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.coverLarge] placeholderImage:[UIImage imageNamed:@"c1.jpg"]];
    cell.countLable.text = model.playtimes.stringValue;
    cell.dayLable.text = model.likes.stringValue;
    float num = [model.duration floatValue]/60;
    NSString *str = [NSString stringWithFormat:@"%.2f",num];
    cell.tracksLable.text = str;
    cell.title.text = model.title;
    cell.imageV.layer.cornerRadius = 10;
    cell.imageV.layer.masksToBounds = YES;
    cell.titleImageView.layer.cornerRadius = 10;
    cell.titleImageView.layer.masksToBounds = YES;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsPlayViewController *playVc = [[NewsPlayViewController alloc]init];
    NewsDetailModel *model = self.detailArray[indexPath.row];
    playVc.urls = self.detailArray;
    playVc.number = indexPath.row;
    playVc.name = model.title;
    [self.navigationController pushViewController:playVc animated:YES];
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
