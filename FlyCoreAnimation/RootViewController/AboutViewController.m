//
//  AboutViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/18.
//  Copyright © 2016年 he. All rights reserved.
//

#import "AboutViewController.h"
#import "CollectViewController.h"

@interface AboutViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self createTableView];
    
    self.dataArray = @[@"清除缓存", @"我的收藏", @"给个评价", @"关于"];
    
}


- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCWI, SCHI)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"about"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"about"];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CollectViewController *collectVC = [[CollectViewController alloc] init];
//    [self.navigationController pushViewController:collectVC animated:YES];
    
    if (indexPath.row == 0) {
        [self clearCache];
    }
    
}


- (void)clearCache
{
    //    计算缓存
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSInteger fileSizes = 0;
    if ([manager fileExistsAtPath:folderPath]) {
        //        创建遍历器
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
        NSString *fileName;
        while ((fileName = [childFilesEnumerator nextObject]) != nil) {
            NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            fileSizes += [manager attributesOfItemAtPath:fileAbsolutePath error:nil].fileSize;
        }
    }
    CGFloat sizes = fileSizes * 1.0 / 1000000;
    
    NSString *message = [NSString stringWithFormat:@"内存大小:%.1fM", sizes];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定清除缓存？" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([manager fileExistsAtPath:folderPath]) {
            NSArray *childerFiles = [manager subpathsAtPath:folderPath];
            for (NSString *fileName in childerFiles) {
                NSString *absolutePath = [folderPath stringByAppendingPathComponent:fileName];
                [manager removeItemAtPath:absolutePath error:nil];
            }
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
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
