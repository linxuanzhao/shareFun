//
//  XFViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 he. All rights reserved.
//
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "XFMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface XFMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>
@property(nonatomic,strong)BMKMapView  *mapView;

@property(nonatomic,strong)BMKLocationService*  locService;

@property(nonatomic,strong)BMKPoiSearch  *searcher;

@end

@implementation XFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"XF";
    self.view.backgroundColor = [UIColor greenColor];
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pop)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(340, 20, 50, 50);
    [btn setImage:[UIImage imageNamed:@"ic_right - circle - o.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    
#pragma mark - 地图功能
//    创建定位
//    初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
//    启动LocationService
    [_locService startUserLocationService];

    //创建地图
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCWI,SCHI)];
    [self.view addSubview:self.mapView];
    
    
    
    [self.mapView addSubview:btn];
   
      //普通态
    //以下_mapView为BMKMapView对象
//    self.mapView.zoomLevel = 10;
    
    _mapView.showsUserLocation = YES;//显示定位图层
    [self.locService startUserLocationService];
  //  self.mapView.showsUserLocation = NO;//先关闭
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
  //  self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
  //  self.mapView.showsUserLocation = YES;

    [_mapView updateLocationData:_locService.userLocation];
#pragma mark - POI
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
#warning ------
    option.pageIndex = 1;
    option.pageCapacity = 10;
    option.location =CLLocationCoordinate2DMake(39.915, 116.404);
    option.keyword = self.searchBarText;
    BOOL flag = [_searcher poiSearchNearBy:option];
  
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
    
    
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
     _searcher.delegate = nil;
}


//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

-(void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
     NSLog(@"显示区域将要方式改变");
}
#pragma mark - POI代理方法
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

@end
