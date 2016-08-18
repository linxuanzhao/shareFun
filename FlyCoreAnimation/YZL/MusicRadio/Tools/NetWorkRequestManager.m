//
//  NetWorkRequestManager.m
//  Project-A
//
//  Created by kkk on 16/5/31.
//  Copyright © 2016年 苏  华. All rights reserved.
//

#import "NetWorkRequestManager.h"

@implementation NetWorkRequestManager

+(void)requestWithType:(RequstType)type url:(NSString *)urlStr para:(NSDictionary *)dicPara finish:(Success)success error:(Faill)faill{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    if (type == POST) {
        request.HTTPMethod = @"post";
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:dicPara options:NSJSONWritingPrettyPrinted error:nil];
        
        request.HTTPBody = data;
    }

    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            success(data);
        }else{
            faill(error);
        }
    }];
    [task resume];
    
}

@end
