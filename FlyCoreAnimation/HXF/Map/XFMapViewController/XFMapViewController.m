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

@interface XFMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate,BMKRouteSearchDelegate>
@property(nonatomic,strong)BMKMapView  *mapView;

@property(nonatomic,strong)BMKLocationService*  locService;

@property(nonatomic,strong)BMKPoiSearch  *searcher;
@property(nonatomic,strong)BMKPoiSearch  *detailSearcher;
@property(nonatomic,strong)BMKRouteSearch  *routeSearch;
@property(nonatomic,strong)BMKPointAnnotation  *pointAnnotation;
@property(nonatomic,strong)BMKAnnotationView  *endPointAnnotation;


@property(nonatomic,strong)NSString  *detailUid;
@property(nonatomic,strong)NSMutableArray  *resultList;
@property(nonatomic,strong)NSMutableArray  *AnnotationPs;
@property(nonatomic,assign)CLLocationCoordinate2D  startPs;
@property(nonatomic,assign)BMKUserLocation*  bmkstart;
@property(nonatomic,assign)BOOL  State;
@property(nonatomic,strong)UISegmentedControl  *seg;

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
    
  //  self.mapManager = [[BMKMapManager alloc]init];
    self.title = @"XF";
    self.view.backgroundColor = [UIColor greenColor];
    // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pop)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(300, 20, 50, 50);
    [btn setImage:[UIImage imageNamed:@"ic_right - circle - o.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
 
    self.seg = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"步行",@"公交",@"驾车", nil]];
    [self.seg addTarget:self action:@selector(segchange) forControlEvents:UIControlEventValueChanged];
        self.seg.selectedSegmentIndex = 0;
    self.seg.frame = CGRectMake(0, 0, 200, 30);
    self.seg.layer.position = CGPointMake(SCWI/2, 40);
    
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
#pragma mark - 地图功能
    
    
    //创建地图
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCWI,SCHI)];
    [self.view addSubview:self.mapView];
    self.mapView.zoomLevel = 15;
    
    //    创建定位
    //    初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //    启动LocationService
     _mapView.showsUserLocation = YES;//显示定位图层
    [_locService startUserLocationService];
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    [self.mapView addSubview:btn];
    [self.mapView addSubview:self.seg];
    
    
    //个人位置蓝色图标设置
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = NO;
    displayParam.isAccuracyCircleShow = NO;
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
   
    //普通态
    //以下_mapView为BMKMapView对象
    //    self.mapView.zoomLevel = 10;
    
    //    _mapView.showsUserLocation = YES;//显示定位图层
    //    [self.locService startUserLocationService];
    //
    
    
    
    //    [_mapView updateLocationData:_locService.userLocation];
    //#pragma mark - POI
    //    //初始化检索对象
    //    _searcher =[[BMKPoiSearch alloc]init];
    //    _searcher.delegate = self;
    //    //发起检索
    //    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    //
    //    option.pageIndex = 1;
    //    option.pageCapacity = 10;
    //    // option.location =self.locService.userLocation.location.coordinate;
    //    option.location = self.startPs;
    //    NSLog(@"%f,%f",option.location.latitude,option.location.longitude);
    //    option.keyword = self.searchBarText;
    //
    //    BOOL flag = [_searcher poiSearchNearBy:option];
    //
    //    if(flag)
    //    {
    //        NSLog(@"%@周边检索发送成功",option.keyword);
    //    }
    //    else
    //    {
    //        NSLog(@"周边检索发送失败");
    //    }
    
    
    
#pragma mark - 详情检索
    self.detailSearcher = [[BMKPoiSearch alloc]init];
    self.detailSearcher.delegate = self;
    
    
}
-(void)search{
#pragma mark - POI
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
//    if (!self.raidu) {
        option.radius = 2000;
//    }
    
    option.pageIndex = 1;
  option.pageCapacity = 10;
     option.location =self.locService.userLocation.location.coordinate;
    option.location = self.startPs;
    NSLog(@"%f,%f",option.location.latitude,option.location.longitude);
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
    
}

-(void)pop{
    
    //    [self.navigationController popViewControllerAnimated:YES];
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(backToMapViewController:)]) {
    //        [self.delegate backToMapViewController:self];
    //    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
   
    self.State = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;
    _detailSearcher.delegate = nil;
    _locService.delegate = nil;
    self.State = NO;
}


//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:_locService.userLocation];
    //  NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
   
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //    _mapView.centerCoordinate = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
    self.startPs = userLocation.location.coordinate;
    //    static CLLocationCoordinate2D staticLocation = self.startPs;
    
    if (CLLocationCoordinate2DIsValid(self.startPs) && self.State == YES) {
        self.State = NO;
#pragma mark - POI
        //初始化检索对象
        _searcher =[[BMKPoiSearch alloc]init];
        _searcher.delegate = self;
        //发起检索
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        
        option.pageIndex = 1;
        option.pageCapacity = 10;
        option.radius = 5000;
        // option.location =self.locService.userLocation.location.coordinate;
        option.location = self.startPs;
        NSLog(@"%f,%f",option.location.latitude,option.location.longitude);
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
        
        
    }
    
    
}

- (void)willStartLocatingUser
{
    NSLog(@"start locate");
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
        //   NSLog(@"%d,%@",poiResultList.totalPoiNum,poiResultList);
        
        //        self.resultList = poiResultList.poiInfoList;
        for (ResultModel *poi in poiResultList.poiInfoList) {
            [self.resultList addObject:poi];
            //      NSLog(@"resultList:%ld,%@,%f,%f",self.resultList.count,poi.name,poi.pt.latitude,poi.pt.longitude);
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
    NSLog(@"我是气泡yeah");
    //初始化检索对象
    //路线搜索
    self.routeSearch = [[BMKRouteSearch alloc]init];
    self.routeSearch.delegate = self;

    self.endPointAnnotation = view;
    [self segchange];
   
    
}
-(void)segchange{
   /*
    //发起检索
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    start.pt = self.startPs;
    NSLog(@"%f,%f",start.pt.longitude,start.pt.latitude);
    BMKPlanNode* end = [[BMKPlanNode alloc]init] ;
    end.pt = self.pointAnnotation.coordinate;
    NSLog(@"%f,%f",end.pt.longitude,end.pt.latitude);
    
    //BMKBaseRoutePlanOption *option = [[BMKBaseRoutePlanOption alloc]init];
    */
   
    
    
    switch (self.seg.selectedSegmentIndex) {
        case 0:{
           
            BMKWalkingRoutePlanOption *option =  [[BMKWalkingRoutePlanOption alloc]init];
            option.from = [[BMKPlanNode alloc]init];
            option.from.pt = self.startPs;
            option.to = [[BMKPlanNode alloc]init];
            option.to.pt = CLLocationCoordinate2DMake(self.pointAnnotation.coordinate.latitude, self.pointAnnotation.coordinate.longitude);
            [self.routeSearch walkingSearch:option];
             
//            [_mapView setMapType:BMKMapTypeStandard];
        } break;
        case 1:{
           
          BMKTransitRoutePlanOption  *option = [[BMKTransitRoutePlanOption alloc]init];
            option.from = [[BMKPlanNode alloc]init];
            option.from.pt = self.startPs ;
            option.to = [[BMKPlanNode alloc]init];
            option.to.pt = self.pointAnnotation.coordinate;
            [self.routeSearch transitSearch:option];
//            [_mapView setMapType:BMKMapTypeSatellite];
        } break;
        case 2:{
            
            BMKDrivingRoutePlanOption  *option = [[BMKDrivingRoutePlanOption alloc]init];
            option.from = [[BMKPlanNode alloc]init];
            option.from.pt = self.startPs ;
            option.to = [[BMKPlanNode alloc]init];
            option.to.pt = self.pointAnnotation.coordinate;
            [self.routeSearch drivingSearch:option];
            //            [_mapView setMapType:BMKMapTypeSatellite];
        } break;

    
        default:
            break;
    }
    
    
    
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        
        for (BMKTransitRouteLine *line in result.routes) {
            //            ///路线长度 单位： 米
            //            @property (nonatomic) int distance;
            //            ///路线耗时 单位： 秒
            //            @property (nonatomic, strong) BMKTime* duration;
            //            ///路线起点信息
            //            @property (nonatomic, strong) BMKRouteNode* starting;
            //            ///路线终点信息
            //            @property (nonatomic, strong) BMKRouteNode* terminal;
            NSString *routeDescription = [NSString stringWithFormat:@"路程长度: %d\n路线耗时: %d小时%d分%d秒", line.distance, line.duration.hours, line.duration.minutes, line.duration.seconds];
            NSLog(@"%@", routeDescription);
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        //当路线起终点有歧义时通，获取建议检索起终点
        //result.routeAddrResult
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
-(void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"walk");
}
-(void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"drive");
}
@end
