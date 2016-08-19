//
//  CompositePlayViewController.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompositeListModel.h"

@interface CompositePlayViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *compositeUrls;
@property (nonatomic, assign) NSInteger indexPath;

@property (nonatomic, strong) NSString *titleA;
@property (nonatomic, strong) CompositeListModel *collectModel;
@end
