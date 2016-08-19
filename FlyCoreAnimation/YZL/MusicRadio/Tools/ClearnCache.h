//
//  ClearnCache.h
//  YueMi
//
//  Created by lanou on 16/6/22.
//  Copyright © 2016年 林志生. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^cleanCacheBlock) ();
@interface ClearnCache : NSObject

//清理缓存
+(void)cleanCache:(cleanCacheBlock)block;

//计算缓存目录的大小
+(float)caChefolderSizePath;

+(void)modeSwitchingExampleWithView:(UIView *)view;

+(void)doSomeWorkWithMixedProgressWithView:(UIView *)view;

@end
