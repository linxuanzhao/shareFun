//
//  DBManager.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/18.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "CompositeListModel.h"
#import "PKListModel.h"

@interface DBManager : NSObject

+ (DBManager *)shareInstance;

// 添加
- (void)addMovie:(Movie *)movie;

// 查询
- (NSMutableArray *)selectFromTable;

// 删除
- (void)deleteMovie:(Movie *)movie;

//5个添加
-(void)addRadio:(CompositeListModel *)model;

//5个查询
-(NSMutableArray *)selectFromRadio;

//5个删除
-(void)deleteRadio:(CompositeListModel *)model;

//pk添加
-(void)addPKRadio:(PKListModel *)model;

//pk删除
-(void)deletePKRadio:(PKListModel *)model;

//pk查询
-(NSMutableArray *)selectFromPKRadio;

@end
