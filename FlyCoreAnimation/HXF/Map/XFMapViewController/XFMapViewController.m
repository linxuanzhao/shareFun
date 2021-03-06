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
/**
 *构造BMKMapPoint对象
 *@param x 水平方向的坐标值
 *@param y 垂直方向的坐标值
 *@return 根据指定参数生成的BMKMapPoint对象
 */
//UIKIT_STATIC_INLINE BMKMapPoint BMKMapPointMake(double x, double y) {
//    return (BMKMapPoint){x, y};
//}
/**
 *构造BMKMapSize对象
 *@param width 宽度
 *@param height 高度
 *@return 根据指定参数生成的BMKMapSize对象
 */
//UIKIT_STATIC_INLINE BMKMapSize BMKMapSizeMake(double width, double height) {
//    return (BMKMapSize){width, height};
//}


@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}
////地理坐标点，用直角地理坐标表示
//typedef struct {
//    double x;	///< 横坐标
//    double y;	///< 纵坐标
//} BMKMapPoint;

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end


@interface XFMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate,BMKRouteSearchDelegate>
@property(nonatomic,strong)BMKMapView  *mapView;

@property(nonatomic,strong)BMKLocationService*  locService;

@property(nonatomic,strong)BMKPoiSearch  *searcher;
@property(nonatomic,strong)BMKPoiSearch  *detailSearcher;
@property(nonatomic,strong)BMKRouteSearch  *routeSearch;
@property(nonatomic,strong)BMKPointAnnotation  *pointAnnotation;
@property(nonatomic,strong)BMKAnnotationView  *endPointAnnotation;
@property(nonatomic,strong)NSMutableArray  *walkArr;

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
    self.view.backgroundColor = [UIColor whiteColor];
    // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pop)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 30, 30);
    [btn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
 
    self.seg = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"普通",@"卫星", nil]];
    [self.seg addTarget:self action:@selector(segchange) forControlEvents:UIControlEventValueChanged];
        self.seg.selectedSegmentIndex = 0;
    self.seg.frame = CGRectMake(0, 0, 100, 30);
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
//-(void)search{
//#pragma mark - POI
//    //初始化检索对象
//    _searcher =[[BMKPoiSearch alloc]init];
//    _searcher.delegate = self;
//    //发起检索
//    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
//        option.radius = 1000;
//    option.pageIndex = 2;
//  option.pageCapacity = 10;
//    option.sortType = BMK_POI_SORT_BY_DISTANCE;
//     option.location =self.locService.userLocation.location.coordinate;
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
//    
//}

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
    [self.mapView removeFromSuperview];
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
   
   // NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
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
        
        option.pageIndex = 0;
        option.pageCapacity = 10;
        
        option.sortType = 0;
        // option.location =self.locService.userLocation.location.coordinate;
        option.location = self.startPs;
        NSLog(@"%f,%f",option.location.latitude,option.location.longitude);
        NSLog(@"%@",self.searchBarText);
        if ([self.searchBarText containsString:@"@"]) {
            NSArray *arr = [self.searchBarText componentsSeparatedByString:@"@"];
            option.keyword = arr.firstObject;
            option.radius = (int)arr.lastObject;
            NSLog(@"%@,%@",arr.firstObject,arr.lastObject);
        }else{
            option.keyword = self.searchBarText;
            option.radius = 2000;

        }
       
        
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
  //  [self segchange];
   
    
}
-(void)segchange{
    switch (self.seg.selectedSegmentIndex) {
        case 0:
            [_mapView setMapType:BMKMapTypeStandard];
            break;
            case 1:
            [_mapView setMapType:BMKMapTypeSatellite];
            break;
            
        default:
            break;
    }
}


@end
