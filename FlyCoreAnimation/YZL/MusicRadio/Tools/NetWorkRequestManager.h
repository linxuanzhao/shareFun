//
//  NetWorkRequestManager.h
//  Project-A
//
//  Created by kkk on 16/5/31.
//  Copyright © 2016年 苏  华. All rights reserved.
//

#import <Foundation/Foundation.h>
//写一个枚举来标示请求类型
typedef NS_ENUM(NSInteger,RequstType){
    GET,
    POST
};
//定义两个block 把block当做参数
typedef void(^Success)(NSData *data);
typedef void(^Faill)(NSError *error);

@interface NetWorkRequestManager : NSObject

//定义一个请求的方法
//1 请求的类型
//2 url
//3 请求的参数（post）
//4 请求成功
//5 失败
+(void)requestWithType:(RequstType)type url:(NSString *)urlStr para:(NSDictionary *)dicPara finish:(Success)success error:(Faill)faill;



@end
