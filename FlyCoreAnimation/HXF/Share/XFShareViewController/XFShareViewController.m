//
//  XFShareViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/5.
//  Copyright © 2016年 he. All rights reserved.
//

#import "XFShareViewController.h"
#import "XFMapViewController.h"
#import "DBSphereView.h"
#import "DBSphereView.h"
#import <Foundation/Foundation.h>

@interface XFShareViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate,BackMapViewControllerDelegate >


@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic,strong)DBSphereView  *sphereView;
@property(nonatomic,strong)NSMutableArray  *hereItemsArr;
@property(nonatomic,strong)NSMutableArray  *strArr;
@property(nonatomic,strong)NSMutableArray  *strNumArr;
@property(nonatomic,strong)NSMutableDictionary  *strDic;



@end

@implementation XFShareViewController



-(NSMutableArray *)strNumArr{
    
    
    if (!_strNumArr) {
        for (int i = 0; i < 11; i++) {
            _strNumArr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d",i], nil];
        }
    }
    return _strNumArr;
    
}

-(NSMutableDictionary *)strDic{
    if (!_strDic) {
        _strDic = [[NSMutableDictionary alloc]initWithObjects:self.strArr forKeys:self.strNumArr];
    }
    return _strDic;
}

-(NSMutableArray *)strArr{
    if (!_strArr) {
        _strArr = [NSMutableArray arrayWithObjects:@"酒店",@"影院",@"小吃",@"蛋糕店",@"KTV",@"美食",@"美容",@"酒吧",@"手机店",@"公交站",@"医院",@"宾馆",@"网吧",@"卫生间",@"房子",@"停车场",@"银行",@"影城",@"网咖",@"地铁站",nil];
    }
    return _strArr;
}


-(NSMutableArray *)hereItemsArr{
    if (!_hereItemsArr) {
        _hereItemsArr = [NSMutableArray new];
        self.sphereView = [[DBSphereView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
        self.sphereView.center = CGPointMake(SCWI/2, SCHI/2);
        //    self.sphereView.backgroundColor = [UIColor cyanColor];
        [self.view addSubview:self.sphereView];

        for (int i = 0; i < self.strArr.count; i++) {
            UIButton *subV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
            [subV setTitleColor: [UIColor colorWithRed:arc4random_uniform(200)/100. green:arc4random_uniform(150)/100. blue:arc4random_uniform(101)/100. alpha:1] forState:UIControlStateNormal];
            //   subV.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100. green:arc4random_uniform(100)/100. blue:arc4random_uniform(100)/100. alpha:1] ;
            

            [subV setTitle:self.strArr[i] forState:UIControlStateNormal];
            subV.titleLabel.font = [UIFont systemFontOfSize:22];
           //[subV setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 20, 0)];
            
            subV.layer.masksToBounds=YES;
            subV.layer.cornerRadius=10;
            [subV addTarget:self action:@selector(subVClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.sphereView addSubview:subV];
            [_hereItemsArr addObject:subV];
            
        }
        
    }
    return _hereItemsArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
#warning navBar
    self.navigationController.navigationBarHidden = YES;
    [[NSBundle mainBundle]loadNibNamed:@"XFShareViewController" owner:self options:nil];
    self.searchBar.delegate = self;
    //   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_left - circle"] style:0 target:self action:@selector(back)];
#warning 换球
    /*
    self.sphereView = [[DBSphereView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.sphereView.center = CGPointMake(SCWI/2, SCHI/2);
    //    self.sphereView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.sphereView];
     */
    self.hereItemsArr;//调用GET方法
    [self.sphereView setCloudTags:_hereItemsArr];
    [self.sphereView timerStart];
    [self imageBg];
    UIScreenEdgePanGestureRecognizer *screen = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    screen.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screen];
    
}
#pragma mark - 手势
-(void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint pt = [gestureRecognizer translationInView:self.view];
    gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + pt.x, gestureRecognizer.view.center.y);
    
    [gestureRecognizer setTranslation:CGPointZero inView:self.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.view.frame.origin.x > SCWI / 2) {
            
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(SCWI, 0, SCWI, SCHI);
                
                
            } completion:^(BOOL finished) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(modalViewControllerDidClickedDismissButton:)]) {
                    [self.delegate modalViewControllerDidClickedDismissButton:self];
                }
                
                [self.view removeFromSuperview];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, 0, SCWI, SCHI);
            }];
            
        }
        
    }
    
}
//返回到ViewController
- (IBAction)back2RootView:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(modalViewControllerDidClickedDismissButton:)]) {
        [self.delegate modalViewControllerDidClickedDismissButton:self];
    }
    
}
#pragma mark  - 跳转事件

-(void)push{
    
    XFMapViewController *XFMVC = [[XFMapViewController alloc]init];
    XFMVC.searchBarText = self.searchBar.text;
    //    [self.navigationController pushViewController:XFMVC animated:YES];
    XFMVC.delegate = self;
//    XFMVC.raidu = (int)self.raidu.text;
    [self presentViewController:XFMVC animated:YES completion:nil];
}
- (IBAction)BtnClick:(id)sender {
    if (self.searchBar.text.length != 0) {
        [self push];
    }
    
}


-(void)subVClick:(UIButton *)sender{
    XFMapViewController *XFMVC = [[XFMapViewController alloc]init];
    XFMVC.searchBarText = sender.titleLabel.text;
    // [self.navigationController pushViewController:XFMVC animated:YES];
    XFMVC.delegate = self;
//    XFMVC.raidu = (int)self.raidu.text;
    [self presentViewController:XFMVC animated:YES completion:nil];
    
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchButton");
    [self push];
}
//-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
//    NSLog(@"endEdit");
//    return YES;
//}


- (void)imageBg
{
    UIImage *oldImage = [UIImage imageNamed:@"XFBG.jpg"];
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    [oldImage drawInRect:self.view.bounds];
    
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
}
//返回到自己
-(void)backToMapViewController:(XFMapViewController *)MapViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
