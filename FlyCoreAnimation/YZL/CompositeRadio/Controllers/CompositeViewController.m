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

@end

@implementation CompositeViewController

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
    compositeImageView.image = [UIImage imageNamed:@"3333.JPG"];
    compositeImageView.userInteractionEnabled = YES;
    [self.view addSubview:compositeImageView];
    UIView *compositeView = [[UIView alloc]initWithFrame:self.view.bounds];
    compositeView.backgroundColor = [UIColor grayColor];
    compositeView.alpha = 0.5;
    [compositeImageView addSubview:compositeView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 375, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView .dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CompositeCell" bundle:nil] forCellReuseIdentifier:@"compositeCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.bounces = NO;
    self.tableView.sectionIndexTrackingBackgroundColor  = [UIColor redColor];
    [compositeImageView addSubview:_tableView];
}

-(void)requestCompositeData
{
    [DownLoad downLoadWithUrl:@"http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=17&device=iPhone&keywordId=113&pageId=1&pageSize=20&statEvent=pageview%2Fcategory%40%E7%94%B5%E5%8F%B0&statModule=%E7%94%B5%E5%8F%B0&statPage=tab%40%E5%8F%91%E7%8E%B0_%E5%88%86%E7%B1%BB&status=0&version=5.4.21" postBody:nil resultBlock:^(NSData *data) {
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
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestCompositeData];
    [self createTableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    [self.navigationController pushViewController:listVc animated:YES];
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
