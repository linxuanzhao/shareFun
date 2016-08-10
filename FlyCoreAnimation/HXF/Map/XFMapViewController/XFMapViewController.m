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
#import "ResultModel.h"
#import "XFAnnotation.h"

@interface XFMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate>
@property(nonatomic,strong)BMKMapView  *mapView;

@property(nonatomic,strong)BMKLocationService*  locService;

@property(nonatomic,strong)BMKPoiSearch  *searcher;
@property(nonatomic,strong)BMKPoiSearch  *detailSearcher;
@property(nonatomic,strong)BMKRouteSearch  *routeSearch;
@property(nonatomic,strong)BMKPointAnnotation  *pointAnnotation;

@property(nonatomic,strong)NSString  *detailUid;
@property(nonatomic,strong)NSMutableArray  *resultList;
@property(nonatomic,strong)NSMutableArray  *AnnotationPs;
@property(nonatomic,assign)CLLocationCoordinate2D  startPs;
@property(nonatomic,assign)BMKUserLocation*  bmkstart;

@end

@implementation XFMapViewController
-(NSMutableArray *)resultList{
    
    
    if (!_resultList) {
        _resultList = [NSMutableArray new];
    }
    return _resultList;

}

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
    self.mapView.zoomLevel = 15;
    
    
    
    [self.mapView addSubview:btn];
    
    //普通态
    //以下_mapView为BMKMapView对象
    //    self.mapView.zoomLevel = 10;
    
    _mapView.showsUserLocation = YES;//显示定位图层
    [self.locService startUserLocationService];
    
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    
    
    [_mapView updateLocationData:_locService.userLocation];
#pragma mark - POI
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];

    option.pageIndex = 1;
    option.pageCapacity = 10;
    option.location =CLLocationCoordinate2DMake(39.915, 116.404);
    option.keyword = self.searchBarText;
    
    BOOL flag = [_searcher poiSearchNearBy:option];
    
    if(flag)
    {
        NSLog(@"%@周边检索发送成功",option.keyword);
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
#pragma mark - 详情检索
    self.detailSearcher = [[BMKPoiSearch alloc]init];
    self.detailSearcher.delegate = self;
    
    
    
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
    _detailSearcher.delegate = nil;
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
    self.bmkstart = userLocation;
    
}

-(void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
   // NSLog(@"显示区域将要方式改变");
}

#pragma mark - 定位
-(void)niche{
    //  self.mapView.showsUserLocation = NO;//先关闭
    //  self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    //  self.mapView.showsUserLocation = YES;
}

#pragma mark - POI代理方法
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"%d,%@",poiResultList.totalPoiNum,poiResultList);
        
//        self.resultList = poiResultList.poiInfoList;
        for (ResultModel *poi in poiResultList.poiInfoList) {
            [self.resultList addObject:poi];
            NSLog(@"resultList:%ld,%@,%f,%f",self.resultList.count,poi.name,poi.pt.latitude,poi.pt.longitude);
            [self setAnnotation:poi.pt name:poi.name adress:poi.address];
            
        }
#pragma mark - POI检索成功后详情检索
        BMKPoiDetailSearchOption *detailOption = [[BMKPoiDetailSearchOption alloc]init];
         detailOption.poiUid = [poiResultList.poiInfoList[0] uid] ;//POI搜索结果中获取的uid
        BOOL DetailFlag = [self.detailSearcher poiDetailSearch:detailOption];
        
        if(DetailFlag)
        {
        NSLog(@"%@详情检索发送成功",[self.resultList[0] name]);
        }
        else
        {
            NSLog(@"详情检索发送失败");
        }
 
        
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"通知" message:@"抱歉，未找到结果" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self pop];
        }];
        
        [alertC addAction:act];
        [self presentViewController:alertC animated:true completion:nil];
        
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma markl - 详情
-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    if(errorCode == BMK_SEARCH_NO_ERROR){
        //在此处理正常结果
        self.detailUid = poiDetailResult.uid;
        NSLog(@"%@",poiDetailResult.uid);
    }
}
-(void)setAnnotation:(CLLocationCoordinate2D)pt name:(NSString *)name adress:(NSString *)adress{
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = pt;
    annotation.title = name;
    annotation.subtitle = adress;
    [_mapView addAnnotation:annotation];
    
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        self.pointAnnotation = annotation;
        
        //用于自定义弹出视图
//        XFAnnotation *b2 = [[XFAnnotation alloc]init];
//        BMKActionPaopaoView *a = [[BMKActionPaopaoView alloc]initWithCustomView:b2];
//        newAnnotationView.paopaoView = a;
        return newAnnotationView;
    }
    return nil;
}

-(void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    NSLog(@"弹出的气泡");
    //初始化检索对象
    self.routeSearch = [[BMKRouteSearch alloc]init];
    self.routeSearch.delegate = self;
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.pt = (CLLocationCoordinate2D){0,0};
//    start.pt = (CLLocationCoordinate2D){self.bmkstart,};
    BMKPlanNode* end = [[BMKPlanNode alloc]init] ;
//    end.name = @"西单";
    
}
@end
