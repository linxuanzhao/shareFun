//
//  DownLoad.m
//  PianKe
//
//  Created by lanou on 16/7/21.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import "DownLoad.h"

@implementation DownLoad

+ (void)downLoadWithUrl:(NSString *)urls postBody:(NSString *)postBody resultBlock:(Block)resultBlock
{
    NSURL *url = [NSURL URLWithString:urls];
    NSURLSession *session = [NSURLSession sharedSession];

    if (postBody == nil)
    {
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // 通过block将请求到的数据传到外面
            resultBlock(data);
        }];
        [task resume];
    }
    
    else{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [postBody dataUsingEncoding:NSUTF8StringEncoding];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      
            resultBlock(data);
        }];
        [task resume];
    
    }
    
}





@end
