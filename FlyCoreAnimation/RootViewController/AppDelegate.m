//
//  AppDelegate.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/7/27.
//  Copyright © 2016年 he. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "XFNetworking.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"dXHYANPtIhrBBRnfaIExm8SjKXBTOuNZ"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
   // [self.window addSubview:_navigationController.view];
 //   [self.window makeKeyAndVisible];
 //-------------------------------------------//
     [self listenNetWorkingPort];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    UIImageView *imageV = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    imageV.image = [UIImage imageNamed:@"Home_refresh_bg.png"];
//    [self.window addSubview:imageV];
    [self.window makeKeyAndVisible];
    ViewController *VC = [[ViewController alloc]init];
    UINavigationController *Navc = [[UINavigationController alloc]initWithRootViewController:VC];
    self.window.rootViewController = Navc;
   
    return YES;
    
   
    
    return YES;
}

- (void)listenNetWorkingPort{
    [[NSURLCache sharedURLCache] setMemoryCapacity:5 * 1024 * 1024];
    [[NSURLCache sharedURLCache] setDiskCapacity:50 * 1024 * 1024];
    
    AFHTTPRequestOperationManager * manager = [XFNetworking sharedManager];
    
    // 设置网络状态变化回调
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                
                // 设置网络请求的缓存政策
                manager.requestSerializer.cachePolicy =  NSURLRequestReturnCacheDataDontLoad;
                NSLog(@"断网状态");
                
                 //               [UIAlertView showConfigPrompt:NSLocalizedString(@"当前没有网络，请检查你的网络设置", nil)];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"通知" message:@"网络不给力" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *act = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UINavigationController *backVC =    [self getCurrentVC];
                    [backVC popToRootViewControllerAnimated:YES];
                  
                }];
                
                [alertC addAction:act];
                [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];

            } break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                // 设置网络请求的缓存政策
                manager.requestSerializer.cachePolicy =  NSURLRequestReturnCacheDataElseLoad;
//                NSLog(@"4G状态");
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                // 设置网络请求的缓存政策
                manager.requestSerializer.cachePolicy =  NSURLRequestReloadIgnoringLocalCacheData;
//                NSLog(@"WiFi状态");
                break;
                
            default:
                break;
        }
    }];
    
    // 启动网络状态监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
