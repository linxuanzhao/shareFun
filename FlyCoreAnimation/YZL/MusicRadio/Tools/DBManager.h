//
//  DBManager.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/13.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBManager : NSObject
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) FMDatabase *dataBase;

+(instancetype)defaltManager;






@end
