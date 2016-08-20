//
//  StoryPlayViewController.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompositeListModel.h"

@interface StoryPlayViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *storyUrls;
@property (nonatomic, assign) NSInteger indexPath;
@property (nonatomic, strong) NSString *titleA;
@property (nonatomic, strong) CompositeListModel *collectModel;
@end
