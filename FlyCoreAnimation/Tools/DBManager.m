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
    }

    return self;
}

// 创建表
- (void)createTable
{
    if ([self.db open]) {
        [self.db executeUpdate:@"create table if not exists movie(movieId text primary key not null, name text, logo520692 text, releaseDate text, grade text, logo556640 text, mobilePreview text, actors text, category text, duration text, director text, area text, highlight text)"];
        
        [self.db executeUpdate:@"create table if not exists radio(title text not null, images text, playUrls text)"];
    }
    [self.db close];
    
}

// 添加
- (void)addMovie:(Movie *)movie
{
    if ([self.db open]) {
        [self.db executeUpdate:@"insert into movie values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", movie.movieId, movie.name, movie.logo520692, movie.releaseDate, movie.grade, movie.logo556640, movie.mobilePreview, movie.actors, movie.category, movie.duration, movie.director, movie.area, movie.highlight];
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
            movie.movieId = [set stringForColumnIndex:0];
            movie.name = [set stringForColumnIndex:1];
            movie.logo520692 = [set stringForColumnIndex:2];
            movie.releaseDate = [set stringForColumnIndex:3];
            movie.grade = [set stringForColumnIndex:4];
            movie.logo556640 = [set stringForColumnIndex:5];
            movie.mobilePreview = [set stringForColumnIndex:6];
            movie.actors = [set stringForColumnIndex:7];
            movie.category = [set stringForColumnIndex:8];
            movie.duration = [set stringForColumnIndex:9];
            movie.director = [set stringForColumnIndex:10];
            movie.area = [set stringForColumnIndex:11];
            movie.highlight = [set stringForColumnIndex:12];
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
