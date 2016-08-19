//
//  RadioPlayViewController.h
//  YzlRadio
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompositeListModel.h"

@interface RadioPlayViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) CompositeListModel *collectModel;

@end
