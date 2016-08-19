//
//  XFNetworking.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/18.
//  Copyright © 2016年 he. All rights reserved.
//

#import "XFNetworking.h"

@implementation XFNetworking

+(AFHTTPRequestOperationManager *)sharedManager{
    static AFHTTPRequestOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [AFHTTPRequestOperationManager manager];
        }
    });
    return manager;
}
@end
