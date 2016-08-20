//
//  RadioViewController.m
//  YzlRadio
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 yzl. All rights reserved.
//

#define WHDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height


#import "RadioViewController.h"
#import "MyLayout.h"
#import "ImageCell.h"
#import "XRCarouselView.h"
#import "DetailViewController.h"
#import "NewsViewController.h"
#import "StoryViewController.h"
#import "LiteraryViewController.h"
#import "CompositeViewController.h"
#import "PianKeViewController.h"
#import "RadioViewController.h"


@interface RadioViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,XRCarouselViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) NSInteger tapNum;
@property (nonatomic, strong) XRCarouselView *carouselView;


@end

@implementation RadioViewController

-(void)createCollectionView
{
    
    MyLayout *myLayout = [[MyLayout alloc]init];
   
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 180,WHDTH,HEIGHT - 180) collectionViewLayout:myLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.bounces = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:_collectionView];
    [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"imageCell"];
    self.collectionView.showsHorizontalScrollIndicator = NO;

    UIImageView *iamgeView1 = [[UIImageView alloc]initWithFrame:self.view.bounds];
    iamgeView1.image = [UIImage imageNamed:@"collection-3.JPG"];
    [self.view addSubview:iamgeView1];
    iamgeView1.userInteractionEnabled = YES;
    [iamgeView1 addSubview:_collectionView];
    
    
   
//    UIImage *oldImage = [UIImage imageNamed:@"coo"];
//    
//    UIGraphicsBeginImageContextWithOptions(self.collectionView.bounds.size, NO, 0.0);
//    [oldImage drawAtPoint:CGPointZero];
//    
//    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:newImage];
   
    
    
}

-(void)createData
{
    _nameArray = @[@"综合台",@"文艺台",@"音乐台",@"新闻台",@"故事台",@"片刻"];
    UIImage *image1 = [UIImage imageNamed:@"1.png"];
    UIImage *image2 = [UIImage imageNamed:@"2.png"];
    UIImage *image3 = [UIImage imageNamed:@"3.png"];
    UIImage *image4 = [UIImage imageNamed:@"4.png"];
    UIImage *image5 = [UIImage imageNamed:@"5.png"];
    UIImage *image6 = [UIImage imageNamed:@"6.png"];
    _imageArray = @[image1,image2,image3,image4,image5,image6];
}


-(void)createScrollView
{
    UIImageView *scrImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, WHDTH, 180)];
    
    scrImageView.backgroundColor = [UIColor lightGrayColor];
    scrImageView.userInteractionEnabled = YES;
    [self.view addSubview:scrImageView];
    
    self.carouselView = [[XRCarouselView alloc]initWithFrame:scrImageView.bounds];
    NSArray *arr1  = @[@"http://fdfs.xmcdn.com/group5/M06/BD/98/wKgDtlR-qYCB5utUAAFBbo6WdM4232_ios_large.jpg",@"http://fdfs.xmcdn.com/group7/M04/61/93/wKgDWlXVSDTx6IIRAAGjeXzkkxU047_ios_large.jpg",@"http://fdfs.xmcdn.com/group7/M00/E5/C8/wKgDWlaXD3OwAhJpAAGFjMMOm-M170_ios_large.jpg",@"http://fdfs.xmcdn.com/group10/M00/D0/05/wKgDZ1Z7W0rzcx3UAAcWO9CkSJw641_ios_large.jpg",@"http://fdfs.xmcdn.com/group9/M03/E3/9A/wKgDZlaUnGvzDtBVAAPsA2faMEs573_ios_large.jpg",@"http://fdfs.xmcdn.com/group9/M0B/61/24/wKgDZlXVSEiwThvsAAICdiWsdNI299_ios_large.jpg"];
    self.carouselView.imageArray = arr1;
    self.carouselView.delegate = self;
    self.carouselView.time = 4;
    self.carouselView.pagePosition = PositionBottomRight;
    [scrImageView addSubview:self.carouselView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"电台列表";
    //[self createCAEmitter];
    [self createCollectionView];
    [self createData];
    [self createScrollView];
}
-(NSInteger)
collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    cell.imageV.image = self.imageArray[indexPath.row];
    cell.imageV.layer.cornerRadius = 50;
    cell.imageV.layer.masksToBounds = YES;
    cell.titleLable.text = self.nameArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CompositeViewController *compositeVc = [[CompositeViewController alloc]init];
        [self.navigationController pushViewController:compositeVc animated:YES];
    }
    if (indexPath.row == 1) {
        LiteraryViewController *literaryVc = [[LiteraryViewController alloc]init];
        [self.navigationController pushViewController:literaryVc animated:YES];
    }
    if (indexPath.row == 2) {
        DetailViewController *detailVc = [[DetailViewController alloc]init];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    if (indexPath.row == 3) {
        NewsViewController *newsVc = [[NewsViewController alloc]init];
        [self.navigationController pushViewController:newsVc animated:YES];
    }
    if (indexPath.row == 4) {
        StoryViewController *storyVC = [[StoryViewController alloc]init];
        [self.navigationController pushViewController:storyVC animated:YES];
    }
    if (indexPath.row == 5) {
        PianKeViewController *pkVc = [[PianKeViewController alloc]init];
        [self.navigationController pushViewController:pkVc animated:YES];
    }
    
}

- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index
{
    if (index == 0) {
        CompositeViewController *comVc = [[CompositeViewController alloc]init];
        [self.navigationController pushViewController:comVc animated:YES];
    }
    if (index == 1) {
        LiteraryViewController *literaryVc = [[LiteraryViewController alloc]init];
        [self.navigationController pushViewController:literaryVc animated:YES];
    }
    if (index == 2) {
        DetailViewController *detailVc = [[DetailViewController alloc]init];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    if (index == 3) {
        PianKeViewController *pianKeVc = [[PianKeViewController alloc]init];
        
        [self.navigationController pushViewController:pianKeVc animated:YES];
    }
    if (index == 4) {
        NewsViewController *newsVC = [[NewsViewController alloc]init];
        [self.navigationController pushViewController:newsVC animated:YES];
    }
    if (index == 5) {
        StoryViewController *storyVc = [[StoryViewController alloc]init];
        
        [self.navigationController pushViewController:storyVc animated:YES];
    }
}

-(void)createCAEmitter
{
    self.tapNum=1;
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, -30);
    snowEmitter.emitterSize		= CGSizeMake(self.view.bounds.size.width * 2.0, 0.0);;
    
    snowEmitter.emitterMode		= kCAEmitterLayerOutline;
    snowEmitter.emitterShape	= kCAEmitterLayerLine;
    
        CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    
    //    随机颗粒的大小
    snowflake.scale = 0.2;
    snowflake.scaleRange = 0.5;
    
    //    缩放比列速度
    //  snowflake.scaleSpeed = 0.1;
    
    //    粒子参数的速度乘数因子；
    snowflake.birthRate		= 20.0;
    
    //生命周期
    snowflake.lifetime		= 80.0;
    
    //    粒子速度
    snowflake.velocity		= 20;				    snowflake.velocityRange = 10;
    //    粒子y方向的加速度分量
    snowflake.yAcceleration = 2;
    
      snowflake.emissionRange = 0.5 * M_PI;
    snowflake.spinRange		= 0.25 * M_PI;
    
    snowflake.contents		= (id) [[UIImage imageNamed:@"fire"] CGImage];
    snowflake.color			= [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    
    
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    
   
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    [self.view.layer addSublayer:snowEmitter];
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.view.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0.0);
    fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
    fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
    fireworksEmitter.renderMode		= kCAEmitterLayerAdditive;
    fireworksEmitter.seed = (arc4random()%100)+1;
    
    
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate		= 5.0;
    rocket.emissionRange	= 0.25 * M_PI;      rocket.velocity			= 380;
    rocket.velocityRange	= 380;
    rocket.yAcceleration	= 75;
    rocket.lifetime			= 1.02;
    rocket.contents			= (id) [[UIImage imageNamed:@"ball"] CGImage];
    rocket.scale			= 0.2;
       rocket.greenRange		= 1.0;
    rocket.redRange			= 1.0;
    rocket.blueRange		= 1.0;
    
    rocket.spinRange		= M_PI;
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate			= 1.0;
    burst.velocity			= 0;
    burst.scale				= 2.5;
    burst.redSpeed			=-1.5;
    burst.blueSpeed			=+1.5;
    burst.greenSpeed		=+1.0;
    burst.lifetime			= 0.35;
    
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate			= 400;
    spark.velocity			= 125;
    spark.emissionRange		= 2* M_PI;
    spark.yAcceleration		= 75;
    spark.lifetime			= 3;
    
    spark.contents			= (id) [[UIImage imageNamed:@"kkk"] CGImage];
    spark.scale		        =0.5;
    spark.scaleSpeed		=-0.2;
    spark.greenSpeed		=-0.1;
    spark.redSpeed			= 0.4;
    spark.blueSpeed			=-0.1;
    spark.alphaSpeed		=-0.5;
    spark.spin				= 2* M_PI;
    spark.spinRange			= 2* M_PI;
    
  
    fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
    rocket.emitterCells				= [NSArray arrayWithObject:burst];
    burst.emitterCells				= [NSArray arrayWithObject:spark];
    [self.view.layer addSublayer:fireworksEmitter];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
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
