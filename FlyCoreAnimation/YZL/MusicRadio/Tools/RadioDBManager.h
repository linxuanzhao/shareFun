//
//  RadioDBManager.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "DBManager.h"
#import "RadioDownLoadModel.h"

@interface RadioDBManager : NSObject

@property (nonatomic, strong) FMDatabase *db;

-(void)createTable;
-(void)insertCollectModel:(RadioDownLoadModel *)model;
-(NSArray<RadioDownLoadModel *> *)selectAllModel;




@end
