//
//  DetailViewController.m
//  YzlRadio
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import "DetailViewController.h"
#import "DownLoad.h"
#import "RadioModel.h"
#import "DetailCell.h"
#import "UIImageView+WebCache.h"
#import "ListViewController.h"
#import "MJRefresh.h"


@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger num1;
@property (nonatomic, strong) MBProgressHUD *hud;



@end

@implementation DetailViewController


-(NSMutableArray *)array
{
    if (_array == nil) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
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
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:self.view.bounds];
    image1.image = [UIImage imageNamed:@"music-1.JPG"];
    image1.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview: image1];
    image1.userInteractionEnabled = YES;
//    UIToolbar *toobar = [[UIToolbar alloc]initWithFrame:image1.frame];
//    toobar.barStyle = UIBarStyleDefault;
//    [image1 addSubview:toobar];
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
//    effectView.frame = image1.frame;
//    [image1 addSubview:effectView];
    
    

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:@"detailCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [image1 addSubview:_tableView];

    
    
}

-(void)refreshRequset
{
    
    [self.array removeAllObjects];
        NSString *str = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=17&device=iPhone&keywordId=102&pageId=%ld&pageSize=20&status=0&version=5.4.21",self.num1 + 1];
        [DownLoad downLoadWithUrl:str postBody:nil resultBlock:^(NSData *data) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = dic[@"list"];
            for (NSDictionary *dic2 in arr) {
                
                RadioModel *model = [[RadioModel alloc]init];
                [model setValuesForKeysWithDictionary:dic2];
                [self.array addObject:model];
            }
            [self.dataArray addObjectsFromArray:self.array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            });
        }];
}

-(void)requestLoadData
{
  
    [DownLoad downLoadWithUrl:@"http://mobile.ximalaya.com/mobile/discovery/v2/category/keyword/albums?calcDimension=hot&categoryId=17&device=iPhone&keywordId=102&pageId=1&pageSize=20&statEvent=pageview%2Fcategory%40%E7%94%B5%E5%8F%B0&statModule=%E7%94%B5%E5%8F%B0&statPage=tab%40%E5%8F%91%E7%8E%B0_%E5%88%86%E7%B1%BB&status=0&version=5.4.21" postBody:nil resultBlock:^(NSData *data) {
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"list"];
            for (NSDictionary *dict in array) {
                RadioModel *model = [RadioModel new];
                [model setValuesForKeysWithDictionary:dict];
                
                [self.array addObject:model];
            }
        }
        [self.dataArray addObjectsFromArray:self.array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"音乐电台";
    [self requestLoadData];
    [self createTableView];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.num1 += 1;
        [self refreshRequset];
    }];

    _hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.color = [UIColor clearColor];
    _hud.activityIndicatorColor = [UIColor blackColor];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _tableView.mj_footer.hidden = self.dataArray.count == 0;
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    RadioModel *model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.albumCoverUrl290] placeholderImage:[UIImage imageNamed:@"cellImage-1"]];
//    cell.imageV.layer.cornerRadius = 5;
//    cell.imageV.layer.masksToBounds = YES;
    cell.titleLable.text = model.title;
    cell.descLable.text = model.intro;
    cell.numberLable.text = model.playsCounts.stringValue;
    cell.EpisodesLable.text = model.tracks.stringValue;
    cell.HandleImageView.layer.cornerRadius = 10;
    cell.HandleImageView.layer.masksToBounds = YES;
    cell.imageV.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.imageV.layer.borderWidth = 2;
    cell.HandleImageView.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.HandleImageView.layer.borderWidth = 1;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListViewController *listVc = [[ListViewController alloc]init];
    RadioModel *model = self.dataArray[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    listVc.statPosition = str;
    listVc.albumId = model.desc;
    listVc.Name = model.title;
    [self.navigationController pushViewController:listVc animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_hud hide:YES];
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//    [UIView animateWithDuration:0.25 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
}




//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *array =  tableView.indexPathsForVisibleRows;
//    NSIndexPath *firstIndexPath = array[0];
//    
//    
//    //设置anchorPoint
//    cell.layer.anchorPoint = CGPointMake(0, 0.5);
//    //为了防止cell视图移动，重新把cell放回原来的位置
//    cell.layer.position = CGPointMake(0, cell.layer.position.y);
//    
//    
//    //设置cell 按照z轴旋转90度，注意是弧度
//    if (firstIndexPath.row < indexPath.row) {
//        cell.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1.0);
//    }else{
//        cell.layer.transform = CATransform3DMakeRotation(- M_PI_2, 0, 0, 1.0);
//    }
//    cell.alpha = 0.0;
//    [UIView animateWithDuration:1 animations:^{
//        cell.layer.transform = CATransform3DIdentity;
//        cell.alpha = 1.0;
//    }];
//    
//    
//}



//-(void)viewWillAppear:(BOOL)animated
//{
//    _alView = [[UIAlertView alloc]initWithTitle:@"正在加载" message:@"请稍后" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [_alView show];
//}
//
//-(void)viewDidAppear:(BOOL)animated
//
//{
//    [_alView removeFromSuperview];
////    [_alView dismissWithClickedButtonIndex:0 animated:NO];
////    _alView = NULL;
//}



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
