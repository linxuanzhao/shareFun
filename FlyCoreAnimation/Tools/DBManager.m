//
//  DBManager.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/18.
//  Copyright © 2016年 he. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"



@interface DBManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation DBManager

+ (DBManager *)shareInstance
{
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [docPath stringByAppendingPathComponent:@"collect.sqlite"];
        self.db = [FMDatabase databaseWithPath:path];
        [self createTable];
        NSLog(@"%@", path);
    }

    return self;
}

// 创建表
- (void)createTable
{
    if ([self.db open]) {
        [self.db executeUpdate:@"create table if not exists movie(name text not null, logo520692 text, releaseDate text, grade text)"];
        [self.db executeUpdate:@"create table if not exists radio(title text not null, images text, playUrls text)"];
    }
    [self.db close];
    
}

// 添加
- (void)addMovie:(Movie *)movie
{
    if ([self.db open]) {
        [self.db executeUpdateWithFormat:@"insert into movie(name, logo520692, releaseDate, grade) values (%@, %@, %@, %@)", movie.name, movie.logo520692, movie.releaseDate, movie.grade];
    }
    [self.db close];
}

-(void)addRadio:(CompositeListModel *)model
{
    if ([self.db open]) {
        [self.db executeUpdateWithFormat:@"insert into radio(title, images, playUrls) values (%@, %@, %@)",model.title,model.coverLarge,model.playUrl64];
    }
    [self.db close];
}



// 查询
- (NSMutableArray *)selectFromTable
{
    NSMutableArray *array = [NSMutableArray array];
    if ([self.db open]) {
        FMResultSet *set = [self.db executeQuery:@"select *from movie"];
        while ([set next]) {
            Movie *movie = [[Movie alloc] init];
            movie.name = [set stringForColumn:@"name"];
            movie.logo520692 = [set stringForColumn:@"logo520692"];
            movie.releaseDate = [set stringForColumn:@"releaseDate"];
            movie.grade = [set stringForColumn:@"grade"];
            [array addObject:movie];
        }
        
    
    }
    [self.db close];
    return array;
}
//查询
-(NSMutableArray *)selectFromRadio
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if ([self.db open]) {
        FMResultSet *set = [self.db executeQuery:@"select *from radio"];
        while ([set next]) {
            CompositeListModel *model = [[CompositeListModel alloc]init];
            model.title = [set stringForColumn:@"title"];
            model.playUrl64 = [set stringForColumn:@"playUrls"];
            model.coverLarge = [set stringForColumn:@"images"];
            [array addObject:model];
        }
    }
    [self.db close];
    return  array;
}

//删除
-(void)deleteRadio:(CompositeListModel *)model
{
    if ([self.db open]) {
        [self.db executeUpdateWithFormat:@"delete from radio where title = %@", model.title];
    }
    [self.db close];
    
}

// 删除
- (void)deleteMovie:(Movie *)movie
{
    if ([self.db open]) {
        [self.db executeUpdateWithFormat:@"delete from movie where name = %@", movie.name];
    }
    [self.db close];
}


//pk添加
-(void)addPKRadio:(PKListModel *)model;
{
    if ([self.db open]) {
        [self.db executeUpdateWithFormat:@"insert into radio(title, images, playUrls) values (%@, %@, %@)",model.title,model.coverimg,model.musicUrl];
    }
    [self.db close];
}

//pk删除
-(void)deletePKRadio:(PKListModel *)model
{
    if ([self.db open]) {
        [self.db executeUpdateWithFormat:@"delete from radio where title = %@", model.title];
    }
    [self.db close];
    
}
-(NSMutableArray *)selectFromPKRadio
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if ([self.db open]) {
        FMResultSet *set = [self.db executeQuery:@"select *from radio"];
        while ([set next]) {
            PKListModel *model = [[PKListModel alloc]init];
            model.title = [set stringForColumn:@"title"];
            model.musicUrl = [set stringForColumn:@"playUrls"];
            model.coverimg = [set stringForColumn:@"images"];
            [array addObject:model];
        }
    }
    [self.db close];
    return  array;
}




@end
