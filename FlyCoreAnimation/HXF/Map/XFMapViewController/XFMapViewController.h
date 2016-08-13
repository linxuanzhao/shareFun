//
//  XFViewController.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFMapViewController;

@protocol BackMapViewControllerDelegate <NSObject>

-(void)backToMapViewController:(XFMapViewController *)MapViewController;

@end

@interface XFMapViewController : UIViewController

@property(nonatomic,strong)NSString  *searchBarText;


@property (nonatomic, weak) id<BackMapViewControllerDelegate> delegate;
@end
