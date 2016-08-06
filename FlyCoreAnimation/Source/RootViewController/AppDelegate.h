//
//  AppDelegate.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/7/27.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>



@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)BMKMapManager  *mapManager;
@property(nonatomic,strong)UINavigationController *navigationController;   
@end

