//
//  DBManager.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 he. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

static DBManager *manager;

+(instancetype)defaltManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc]init];
    });
    return manager;
}

-(instancetype)init
{
    if (self = [super init]) {
        int state = [self initDataBaseWithName:@"Radio.sqlite"];
        if (state == -1) {
            NSLog(@"没有数据库");
        }else{
            NSLog(@"成功创建");
        }
    }
    return self;
}

-(int)initDataBaseWithName:(NSString *)name
{
    if (!name) {
        return -1;
    }
    _path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [self connect];
    if ([fileManager fileExistsAtPath:_path]) {
        return 0;
    }else{
        return 1;
    }
}

-(void)connect
{
    _dataBase = [FMDatabase databaseWithPath:_path];
    if (![_dataBase open]) {
        NSLog(@"数据库么打开");
    }
}

-(void)close
{
    [_dataBase close];
}


@end
