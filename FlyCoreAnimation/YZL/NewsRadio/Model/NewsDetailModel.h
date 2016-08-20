//
//  NewsDetailModel.h
//  YzlRadio
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsDetailModel : NSObject

@property (nonatomic, strong) NSString *playUrl64;

@property (nonatomic, strong) NSString *coverLarge;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *playtimes;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSNumber *duration;

@end
