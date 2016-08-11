//
//  ListModel.h
//  YzlRadio
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject
@property (nonatomic, strong) NSString *playUrl32;
@property (nonatomic, strong) NSString *coverLarge;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *playtimes;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSNumber *duration;

@end
