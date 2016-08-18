//
//  ViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/7/27.
//  Copyright © 2016年 he. All rights reserved.
//
#import "UIView+XFView.h"
#import "ViewController.h"
#import "XFMapViewController.h"
#import "XFShareViewController.h"
#import "MovieViewController.h"
#import "RadioViewController.h"
#import "MovieTableViewController.h"
#import "AboutViewController.h"

#define marginX 120
#define marginY1 20
#define marginY2 40
#define bgtype @"rippleEffect"
#import "XFExplodeAnimationController.h"
@interface ViewController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,BackViewControllerDelegate>


@property(nonatomic,strong)UIView  *view0;
@property(nonatomic,strong)UIView  *view1;
@property(nonatomic,strong)UIView  *view2;
@property(nonatomic,strong)UIView  *view3;
@property(nonatomic,assign)CATransform3D  CA0;
@property(nonatomic,assign)CATransform3D  CA1;
@property(nonatomic,assign)CATransform3D  CA2;
@property(nonatomic,assign)CATransform3D  CA3;
@property(nonatomic,assign)CATransform3D  toplan;

@property(nonatomic,assign)int  state;
@property(nonatomic,assign)CGPoint  P;
@property(nonatomic,strong)UITouch*  touch;
@property(nonatomic,assign)CGPoint MP;
@property(nonatomic,strong)UITouch*  mtouch;

@property(nonatomic,strong)UIButton  *btn;
@property(nonatomic,strong)UIButton  *farbtn;
@property(nonatomic,strong)UILabel  *str;

@property(nonatomic,strong)NSMutableArray  *viewArr;
@property(nonatomic,strong)NSMutableArray  *rightRowArr;
@property(nonatomic,strong)NSMutableArray  *leftRowArr;
@property(nonatomic,strong)NSMutableArray  *finalArr;
@property(nonatomic,strong)NSMutableArray  *strArr;

@property(nonatomic,assign)NSInteger  tag;
@property(nonatomic,strong)XFExplodeAnimationController  *XFExplode;
@property(nonatomic,assign)BOOL  canClick;
@end

@implementation ViewController
-(XFExplodeAnimationController *)XFExplode{
    
    
    if (!_XFExplode) {
        _XFExplode = [XFExplodeAnimationController new];
    }
    return _XFExplode;
    
}

-(void)viewWillAppear:(BOOL)animated{
#warning navBar
    self.canClick = YES;
    self.navigationController.navigationBarHidden = YES;
    [self rightViewToMid:self.viewArr[0] withCATransform3d:self.CA1];
    [self midViewToLeft:self.viewArr[3] CATransfrom:self.CA0];
    [self leftViewToFar:self.viewArr[2] CATransform:self.CA3];
    [self farViewToRight:self.viewArr[1] CATransform3d:self.CA2];
//    for (UIView *IV in self.viewArr) {
//        IV.hidden = NO;
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self imageBg];
    [self right2Mid];
    [self mid2Left];
    [self far2right];
    [self left2far];
    self.state = 0;
     [self initFarButton];
    [self initWithButton];
   
    [self initLabel];
    [self initWithLeftButton];
    [self initWithRightButton];
}
#pragma mark BUTTON
-(void)initWithButton{
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.layer.anchorPoint = CGPointMake(0,0);
    _btn.frame = CGRectMake(SCWI/2-70, SCHI/2-128/2, 100, 90);
//    _btn.backgroundColor = [UIColor redColor];
    [_btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
}
-(void)initFarButton{
    self.farbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _farbtn.layer.anchorPoint = CGPointMake(0,0);
    _farbtn.frame = CGRectMake(SCWI/2-70, SCHI/2-marginY1-marginY2-50, 100, 50);
//    _farbtn.backgroundColor = [UIColor greenColor];
    [_farbtn addTarget:self action:@selector(far2Mid) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.farbtn];
}
-(void)initWithLeftButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    btn.frame = CGRectMake(SCWI/2-50/2-marginX, SCHI/2-marginY2-50/2, 50, 50);
//        btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(rowLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}
-(void)initWithRightButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(SCWI/2-50/2+marginX, SCHI/2-marginY2-50/2, 50, 50);
//    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(rowRight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}
-(void)far2Mid{

    [self rowRight];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self rowRight];
    });
    
}
#pragma mark - 标题
-(void)initLabel{
    self.strArr = [NSMutableArray arrayWithObjects:@"电影",@"电台",@"附近",@"分享", nil];
    self.str = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    self.str.layer.position = CGPointMake(SCWI/2, SCHI/2+220);
    self.str.textAlignment = NSTextAlignmentCenter ;
    self.str.text = self.strArr.firstObject;
    [self.view addSubview:self.str];
    
}

#pragma mark - 动画
-(void)view2Plan{
    self.toplan = CATransform3DMakeRotation(0, 0, 0, 0);
}
-(void)right2Mid{
    
    CATransform3D CA = CATransform3DMakeTranslation(0, 0, 10);
    CATransform3D CA2 = CATransform3DRotate(CA, 0, 0, 0, 0);
    CATransform3D CA3 = CATransform3DScale(CA2, 1, 1, 1);
    
    self.CA1 =CA3;
    
}
-(void)mid2Left{
    CATransform3D CA = CATransform3DMakeTranslation(-marginX, -marginY2, 0);
    CATransform3D CA2 = CATransform3DRotate(CA, M_PI/3, 0, 1, 1);
    
    self.CA0 = CA2;
}
-(void)far2right{
    CATransform3D CA = CATransform3DMakeTranslation(marginX, -marginY2, 0);
    CATransform3D CA2 = CATransform3DRotate(CA, -M_PI/3, 0, 1, 1);
    CATransform3D CA3 = CATransform3DScale(CA2, 0.8, 0.8, 0);
    
    self.CA2 = CA3;
}
-(void)left2far{
    
    CATransform3D CA = CATransform3DMakeTranslation(0, -marginY2-marginY1, -10);
    CATransform3D CA2 = CATransform3DRotate(CA, 0, 0, 1, 0);
    self.CA3 = CA2;
}

#pragma mark - View的滑动
-(void)viewWithAnim:(UIView *)view CATransform:(CATransform3D)CA{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform";
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.toValue = [NSValue valueWithCATransform3D:CA];
    
    [view.layer addAnimation:anim forKey:nil];
    
    
}
-(void)rightViewToMid:(UIView *)view withCATransform3d:(CATransform3D)CA{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform";
    anim.removedOnCompletion = NO;
    anim.fillMode =kCAFillModeForwards;
    anim.toValue = [NSValue valueWithCATransform3D:CA];
    [view.layer addAnimation:anim forKey:@"right2Mid"];
}
-(void)farViewToRight:(UIView *)view CATransform3d:(CATransform3D)CA{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform";
    anim.removedOnCompletion = NO;
    anim.fillMode =kCAFillModeForwards;
    
    anim.toValue = [NSValue valueWithCATransform3D:CA];
    
    [view.layer addAnimation:anim forKey:@"far2Right"];
    
    
}
-(void)leftViewToFar:(UIView *)view CATransform:(CATransform3D)CA{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform";
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.toValue = [NSValue valueWithCATransform3D:CA];
    
    [view.layer addAnimation:anim forKey:@"letf2Far"];
    
    
}
-(void)midViewToLeft:(UIView *)view CATransfrom:(CATransform3D)CA{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath=@"transform";
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    anim.toValue = [NSValue valueWithCATransform3D:CA];
    
    [view.layer addAnimation:anim forKey:@"mid2Left"];
}


- (void)imageBg
{
    UIImage *oldImage = [UIImage imageNamed:@"Home_refresh_bg.png"];
    
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 0.0);
    [oldImage drawInRect:self.view.bounds];
    
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
}





#pragma mark - View的创建

-(void)initView{
    self.view3 = [[UIView alloc]initWithFrame:CGRectMake(0,0, 150, 150)];
    self.view3.layer.position = CGPointMake(SCWI/2, SCHI/2);
    self.view3.tag = 103;
    [self.view3 drawRect:self.view3.frame image:@"XFSave2"];
  
    //    self.view3.layer.backgroundColor = [UIColor redColor].CGColor;
//    [self.view3 drawRect:self.view3.frame image:@"RadioXF"];
    [self.view addSubview:self.view3];
    
    self.view0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    self.view0.layer.position = CGPointMake(SCWI/2, SCHI/2);
   // self.view0.layer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view0 drawRect:self.view0.bounds image:@"movies"];
    self.view0.tag = 100;
    
   
    [self.view.layer addSublayer:self.view0.layer];
    
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(0,0, 150, 150)];
    self.view1.layer.position = CGPointMake(SCWI/2, SCHI/2);
   
    self.view1.tag = 101;
    [self.view1 drawRect:self.view1.frame image:@"Raido3"];
    //动图
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"XFRadio" ofType:@"gif"];
//    NSData *gif =[NSData dataWithContentsOfFile:filePath];
//    [self.view1 loadData:gif MIMEType:@"image/gif" textEncodingName:@"gifradio" baseURL:[NSURL URLWithString:@"https://image.baidu.com/search/detail?ct=503316480&z=undefined&tn=baiduimagedetail&ipn=d&word=%E7%94%B5%E5%8F%B0gif%E5%9B%BE&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=undefined&cs=1682682088,3457368853&os=2499386192,1125873253&simid=4152138367,892090828&pn=2&rn=1&di=3691159450&ln=1989&fr=&fmq=1471266142382_R&fm=&ic=undefined&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&is=&istype=0&ist=&jit=&bdtype=0&adpicid=0&pi=0&gsm=0&hs=2&objurl=http%3A%2F%2Fwww.qqtu8.com%2Ff%2F20130407190953.gif&rpstart=0&rpnum=0&ctd=1471266143335^3_1432X944%1"]];
//    self.view1.userInteractionEnabled = NO;
    [self.view addSubview:self.view1];
    
    self.view2 = [[UIView alloc]initWithFrame:CGRectMake(0,0, 150, 150)];
    self.view2.layer.position = CGPointMake(SCWI/2, SCHI/2);
   // self.view2.layer.backgroundColor = [UIColor cyanColor].CGColor;
    self.view2.tag = 102;
    [self.view2 drawRect:self.view2.frame image:@"XFMap3"];
    self.viewArr = [NSMutableArray arrayWithObjects:self.view0,self.view1,self.view2,self.view3, nil];
    
    [self.view addSubview:self.view2];
}



#pragma mark - 监听事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.touch = [touches anyObject];
    self.P = [self.touch locationInView:self.view];
    
    
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.mtouch = [touches anyObject];
    self.MP = [self.mtouch locationInView:self.view];
    
    
}
-(void)rowRight{
    self.state++;
    self.rightRowArr = [NSMutableArray arrayWithObjects:self.viewArr[1],self.viewArr[2],self.viewArr[3],self.viewArr[0], nil];
    
    [self midViewToLeft:self.viewArr[0] CATransfrom:self.CA0 ];
    [self leftViewToFar:self.viewArr[3] CATransform:self.CA3];
    [self farViewToRight:self.viewArr[2] CATransform3d:self.CA2];
    [self rightViewToMid:self.viewArr[1] withCATransform3d:self.CA1];
    self.viewArr = self.rightRowArr;
    if (self.state == 4) {
        self.state = 0;
    }
    self.str.text = self.strArr[self.state];
}
-(void)rowLeft{
    self.state--;
    self.leftRowArr = [NSMutableArray arrayWithObjects: self.viewArr[3],self.viewArr[0],self.viewArr[1],self.viewArr[2], nil];
    [self midViewToLeft:self.viewArr[0] CATransfrom:self.CA2 ];
    [self leftViewToFar:self.viewArr[3] CATransform:self.CA1];
    [self farViewToRight:self.viewArr[2] CATransform3d:self.CA0];
    [self rightViewToMid:self.viewArr[1] withCATransform3d:self.CA3];
    self.viewArr = self.leftRowArr;
    if (self.state == -1) {
        self.state = 3;
    }
    self.str.text = self.strArr[self.state];
}



-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.P.x - self.MP.x>10 && self.MP.x != 0) {
        [self rowRight];
    }else{
        if (self.P.x < self.MP.x) {
            [self rowLeft];
               }
    self.P = CGPointZero;
    self.MP = CGPointZero;
    
    }
}
#pragma mark - 初始状态
-(void)textTransform2{
    CABasicAnimation *animRota = [CABasicAnimation animation];
    
    animRota.keyPath =@"transform";
    CATransform3D tran = CATransform3DMakeTranslation(0, -(marginY1+marginY2), 0);
    animRota.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(tran, M_PI_4, 1, 0, 0)];
    animRota.removedOnCompletion = NO;
    animRota.fillMode =kCAFillModeForwards;
    animRota.duration = 0.8;
    
    [self.view2.layer addAnimation:animRota forKey:nil];
    
    
}



-(void)textTransform0{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath =@"transform";
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1)];
    anim.removedOnCompletion = NO;
    anim.fillMode =kCAFillModeForwards;
    
    anim.duration = 0.8;
    [self.view0.layer addAnimation:anim forKey:nil];
}
-(void)textTransform3{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform";
    CATransform3D tra =  CATransform3DMakeTranslation(-marginX, -marginY2, 0);
    CATransform3D tra2 = CATransform3DRotate(tra, M_PI_2, 0, 1, 1);
    anim.toValue = [NSValue valueWithCATransform3D:tra2];
    
    anim.duration = 0.8;
    
    anim.removedOnCompletion = NO;
    anim.fillMode =kCAFillModeForwards;
    
    [self.view3.layer addAnimation:anim forKey:nil];
}

-(void)textTransform1{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform";
    CATransform3D tra = CATransform3DMakeTranslation(marginX, -marginY2, 0);
    CATransform3D tra2 = CATransform3DRotate(tra, -M_PI_2, 0, 1, 1);
    anim.toValue = [NSValue valueWithCATransform3D:tra2];
    anim.duration = 0.8;
    anim.removedOnCompletion = NO;
    anim.fillMode =kCAFillModeForwards;
    [self.view1.layer addAnimation:anim forKey:nil];
}

#pragma mark - 跳转进控制器
-(void)push{
    if (self.canClick) {
        self.canClick = NO;
    
  //  self.finalArr = [NSMutableArray arrayWithArray:self.viewArr];
    /*
     CABasicAnimation *anim = [CABasicAnimation animation];
     anim.keyPath = @"transform";
     anim.duration = 0.8;
     CATransform3D CA = CATransform3DMakeRotation(-M_PI, 0, 0, 1);
     anim.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CA, SCWI/75, SCHI/134, 0)];
     // anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(SCWI/75, SCHI/134, 0)];
     anim.removedOnCompletion = NO;
     anim.fillMode =kCAFillModeForwards;
     */
    //      anim.subtype = kCATransitionFromRight;
    
    
    
//    CALayer *biglayer =  [self.viewArr[0] layer];
    self.tag =   [self.viewArr[0] tag];
    
    // [biglayer addAnimation:anim forKey:@"big"];
    //    NSLog(@"%ld %@",(long)self.tag,[self.viewArr[0] backgroundColor]);
    
    //    for (int i = 1; i < self.viewArr.count; i++) {
    //        UIView *Iv = self.viewArr[i];
    //        Iv.hidden = YES;
    //
    //    }
    CATransition *anim = [CATransition animation];
    anim.type = bgtype;
    anim.duration = 0.8;
    
    [self.view.layer addAnimation:anim forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *VC = [[UIViewController alloc]init];
        UIView *alpView = [[UIView alloc]init];
        alpView.alpha = 0;
        
        switch (self.tag) {
                //青色 地图
                
            case 100:{
                VC =     [[MovieTableViewController alloc]init];
              
                [self.navigationController pushViewController:VC animated:YES];
//                [self presentViewController:VC animated:YES completion:nil];
            }
                break;
            case 101:{ 
                VC =     [[RadioViewController alloc]init];
 
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            case 102:{
                XFShareViewController *XFShare =     [[XFShareViewController alloc]init];
                XFShare.transitioningDelegate =self;
                XFShare.delegate = self;
                     [self presentViewController:XFShare
                                   animated:YES completion:nil];
            }
                break;
            case 103:{
                VC = [[AboutViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                
                
            }
                break;
                
            default:
                break;
        }
        //转场
        
        
        //    [self.navigationController pushViewController:VC animated:NO];
        
        
    });
    
    }
    
}
#pragma mark - 控制器跳转动画
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    return self.XFExplode;
}
// 3. Implement the methods to supply proper objects.
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.XFExplode;
}
//返回来这个控制器
-(void)modalViewControllerDidClickedDismissButton:(XFShareViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
