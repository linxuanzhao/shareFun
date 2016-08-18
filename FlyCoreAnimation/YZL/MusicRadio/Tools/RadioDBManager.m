//
//  RadioDBManager.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 he. All rights reserved.
//

#import "RadioDBManager.h"

@implementation RadioDBManager

-(instancetype)init
{
    if (self = [super init]) {
        _db = [DBManager defaltManager].dataBase;
    }
    return self;
}

-(void)createTable
{
    BOOL result = [self.db executeUpdate:@"create table if not exists MusicRadio(id integer primary key, title text not null, imageUrl text not null, savePath text not null)"];
    if (result) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建失败");
    }
}

-(void)insertCollectModel:(RadioDownLoadModel *)model
{
    BOOL result = [self.db executeUpdate:@"insert into MusicRadio(title,imageUrl,savePth) values(?,?,?)",model.titleStr,model.imageUrl,model.savePath];
    if (result) {
        NSLog(@"添加成功");
    }else{
        NSLog(@"添加失败");
    }
}

-(NSArray<RadioDownLoadModel *> *)selectAllModel
{
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *results = [self.db executeQuery:@"select * from MusicRadio"];
    while ([results next]) {
        NSString *title = [results objectForColumnName:@"title"];
        NSString *imageUrl = [results objectForColumnName:@"imageUrl"];
        NSString *savePath = [results objectForColumnName:@"savePath"];
        RadioDownLoadModel *model = [[RadioDownLoadModel alloc]init];
        model.titleStr = title;
        model.imageUrl = imageUrl;
        model.savePath = savePath;
        [array addObject:model];
    }
    return array;
}



@end
