//
//  ViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/7/27.
//  Copyright © 2016年 he. All rights reserved.
//

#import "ViewController.h"

#import "XFMapViewController.h"
#import "XFShareViewController.h"

#define marginX 120
#define marginY1 100
#define marginY2 40

@interface ViewController ()


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

@property(nonatomic,strong)NSMutableArray  *viewArr;
@property(nonatomic,strong)NSMutableArray  *rightRowArr;
@property(nonatomic,strong)NSMutableArray  *leftRowArr;
@property(nonatomic,strong)NSMutableArray  *finalArr;

@property(nonatomic,assign)NSInteger  tag;
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{

    [self rightViewToMid:self.viewArr[0] withCATransform3d:self.CA1];
    [self midViewToLeft:self.viewArr[3] CATransfrom:self.CA0];
    [self leftViewToFar:self.viewArr[2] CATransform:self.CA3];
    [self farViewToRight:self.viewArr[1] CATransform3d:self.CA2];
    for (UIView *IV in self.viewArr) {
        IV.hidden = NO;
    }
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
    [self initWithButton];
}



#pragma mark - 动画
-(void)view2Plan{
    self.toplan = CATransform3DMakeRotation(0, 0, 0, 0);
}
-(void)right2Mid{
    
    CATransform3D CA = CATransform3DMakeTranslation(0, 0, 0);
    CATransform3D CA2 = CATransform3DRotate(CA, 0, 0, 0, 0);
    CATransform3D CA3 = CATransform3DScale(CA2, 1.5, 1.5, 1);
    self.CA1 =CA3;

}
-(void)mid2Left{
    CATransform3D CA = CATransform3DMakeTranslation(-marginX, -marginY2, 0);
    CATransform3D CA2 = CATransform3DRotate(CA, M_PI_2, 0, 1, 1);
 
    self.CA0 = CA2;
}
-(void)far2right{
    CATransform3D CA = CATransform3DMakeTranslation(marginX, -marginY2, 0);
    CATransform3D CA2 = CATransform3DRotate(CA, -M_PI_2, 0, 1, 1);
    
    self.CA2 = CA2;
}
-(void)left2far{
    
    CATransform3D CA = CATransform3DMakeTranslation(0, -marginY1-marginY2, 0);
    CATransform3D CA2 = CATransform3DRotate(CA, M_PI_4, 1, 0, 0);
    self.CA3 = CA2;
}

#pragma mark - View的滑动
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


//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (self.P.x > self.MP.x) {
//        NSLog(@"%@",[NSValue valueWithCGPoint:self.scr.contentOffset]);
//        self.rightRowArr = [NSMutableArray arrayWithObjects:self.viewArr[1],self.viewArr[2],self.viewArr[3],self.viewArr[0], nil];
//        
//        [self midViewToLeft:self.viewArr[0] CATransfrom:self.CA0 ];
//        [self leftViewToFar:self.viewArr[3] CATransform:self.CA3];
//        [self farViewToRight:self.viewArr[2] CATransform3d:self.CA2];
//        [self rightViewToMid:self.viewArr[1] withCATransform3d:self.CA1];
//   
//        self.viewArr = self.rightRowArr;
//     //   self.scr.contentOffset = CGPointMake(0, 0);
//        
//        
//    }else{
//        if (self.P.x < self.MP.x) {
//            NSLog(@"%@",[NSValue valueWithCGPoint:self.scr.contentOffset]);
//            self.leftRowArr = [NSMutableArray arrayWithObjects: self.viewArr[3],self.viewArr[0],self.viewArr[1],self.viewArr[2], nil];
//            [self midViewToLeft:self.viewArr[0] CATransfrom:self.CA0 ];
//            [self leftViewToFar:self.viewArr[3] CATransform:self.CA3];
//            [self farViewToRight:self.viewArr[2] CATransform3d:self.CA2];
//            [self rightViewToMid:self.viewArr[1] withCATransform3d:self.CA1];
//            self.viewArr = self.leftRowArr;
//           //  self.scr.contentOffset = CGPointMake(0, 0);
//        }
//    }
//    
//
//}
//
//
//
//
//





- (void)imageBg
{
    UIImage *oldImage = [UIImage imageNamed:@"Home_refresh_bg.png"];
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    [oldImage drawInRect:self.view.bounds];
    
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
}



    
#pragma mark - View的创建

-(void)initView{
    self.view3 = [[UIView alloc]initWithFrame:CGRectMake(0,0, 100, 100)];
    self.view3.layer.position = CGPointMake(SCWI/2, SCHI/2);
    self.view3.tag = 103;
    self.view3.layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view addSubview:self.view3];
    
    self.view0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.view0.layer.position = CGPointMake(SCWI/2, SCHI/2);
    self.view0.layer.backgroundColor = [UIColor greenColor].CGColor;
    self.view0.tag = 100;
    [self.view.layer addSublayer:self.view0.layer];
    
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(0,0, 100, 100)];
    self.view1.layer.position = CGPointMake(SCWI/2, SCHI/2);
    self.view1.layer.backgroundColor = [UIColor blueColor].CGColor;
    self.view1.tag = 101;
    [self.view addSubview:self.view1];
    
    self.view2 = [[UIView alloc]initWithFrame:CGRectMake(0,0, 100, 100)];
    self.view2.layer.position = CGPointMake(SCWI/2, SCHI/2);
    self.view2.layer.backgroundColor = [UIColor cyanColor].CGColor;
    self.view2.tag = 102;
    self.viewArr = [NSMutableArray arrayWithObjects:self.view0,self.view1,self.view2,self.view3, nil];
    
    [self.view addSubview:self.view2];
}

-(void)initWithButton{
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.layer.anchorPoint = CGPointMake(0,0);
    _btn.frame = CGRectMake(SCWI/2-75, SCHI/2-75, 150, 150);
    
    [_btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
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
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIView *vi in self.viewArr) {
        vi.hidden = NO  ;
    }
    if (self.P.x > self.MP.x) {
       
        self.rightRowArr = [NSMutableArray arrayWithObjects:self.viewArr[1],self.viewArr[2],self.viewArr[3],self.viewArr[0], nil];
        
        [self midViewToLeft:self.viewArr[0] CATransfrom:self.CA0 ];
        [self leftViewToFar:self.viewArr[3] CATransform:self.CA3];
        [self farViewToRight:self.viewArr[2] CATransform3d:self.CA2];
        [self rightViewToMid:self.viewArr[1] withCATransform3d:self.CA1];
        self.viewArr = self.rightRowArr;
    }else{
        if (self.P.x < self.MP.x) {
            self.leftRowArr = [NSMutableArray arrayWithObjects: self.viewArr[3],self.viewArr[0],self.viewArr[1],self.viewArr[2], nil];
            [self midViewToLeft:self.viewArr[0] CATransfrom:self.CA2 ];
            [self leftViewToFar:self.viewArr[3] CATransform:self.CA1];
            [self farViewToRight:self.viewArr[2] CATransform3d:self.CA0];
            [self rightViewToMid:self.viewArr[1] withCATransform3d:self.CA3];
            self.viewArr = self.leftRowArr;
         }
    }
    self.P = CGPointZero;
    self.MP = CGPointZero;
    

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
    self.finalArr = [NSMutableArray arrayWithArray:self.viewArr];
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform";
    anim.duration = 0.8;
    CATransform3D CA = CATransform3DMakeRotation(-M_PI, 0, 0, 1);
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CA, SCWI/100, SCHI/100, 0)];
    anim.removedOnCompletion = NO;
    anim.fillMode =kCAFillModeForwards;
    
    
    CALayer *biglayer =  [self.viewArr[0] layer];
    self.tag =   [self.viewArr[0] tag];
    [biglayer addAnimation:anim forKey:@"big"];
    NSLog(@"%ld %@",(long)self.tag,[self.viewArr[0] backgroundColor]);
    for (int i = 1; i < self.viewArr.count; i++) {
        UIView *Iv = self.viewArr[i];
        Iv.hidden = YES;
        
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *VC = [[UIViewController alloc]init];
        switch (self.tag) {
                //青色 地图
            
            case 100:{
          // VC =     [[XFShareViewController alloc]init];
            }
                break;
            case 101:{
           //     VC =     [[XFShareViewController alloc]init];
            }
                break;
            case 102:{
                VC =     [[XFShareViewController alloc]init];
            }
                break;
            case 103:{
          //      VC =     [[XFShareViewController alloc]init];
            }
                break;
                
            default:
                break;
        }
        [self.navigationController pushViewController:VC animated:NO];
        

        
        
           });
   
}

@end
