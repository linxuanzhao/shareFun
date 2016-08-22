//
//  PKPlayViewController.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/16.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKListModel.h"


@interface PKPlayViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *pkUrls;
@property (nonatomic, assign) NSInteger indexPath;
@property (nonatomic, strong) NSString *titleA;
@property (nonatomic, strong) PKListModel *collectModel;

@end
