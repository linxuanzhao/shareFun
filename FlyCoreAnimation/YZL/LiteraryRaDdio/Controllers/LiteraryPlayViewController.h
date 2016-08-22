//
//  LiteraryPlayViewController.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompositeListModel.h"

@interface LiteraryPlayViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *literaryUrls;
@property (nonatomic, assign) NSInteger indexPath;
@property (nonatomic, strong) NSString *titleAA;
@property (nonatomic, strong) CompositeListModel *collectModel;

@end
