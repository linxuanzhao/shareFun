//
//  NewsModel.h
//  YzlRadio
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *albumCoverUrl290;
@property (nonatomic, strong) NSNumber *playsCounts;
@property (nonatomic, strong) NSNumber *tracks;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger trackId;

@end
