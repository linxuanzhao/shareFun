//
//  DBManager.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/18.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@interface DBManager : NSObject

+ (DBManager *)shareInstance;

// 添加
- (void)addMovie:(Movie *)movie;

// 查询
- (NSMutableArray *)selectFromTable;

// 删除
- (void)deleteMovie:(Movie *)movie;

@end
