//
//  XFShareViewController.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/5.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFShareViewController;

@protocol BackViewControllerDelegate <NSObject>

-(void)modalViewControllerDidClickedDismissButton:(XFShareViewController *)viewController;

@end

@interface XFShareViewController : UIViewController

@property (nonatomic, weak) id<BackViewControllerDelegate> delegate;
@end
