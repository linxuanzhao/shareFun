//
//  RadioModel.h
//  YzlRadio
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioModel : NSObject

@property (nonatomic, strong) NSString *albumCoverUrl290;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSNumber *playsCounts;
@property (nonatomic, strong) NSNumber *tracks;
@property (nonatomic, strong) NSString *intro;


@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger trackId;


@end
