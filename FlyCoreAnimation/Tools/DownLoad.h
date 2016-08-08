//
//  DownLoad.h
//  PianKe
//
//  Created by lanou on 16/7/21.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Block)(NSData *data);

@interface DownLoad : NSObject


+ (void)downLoadWithUrl:(NSString *)urls postBody:(NSString *)postBody resultBlock:(Block)resultBlock;




@end
