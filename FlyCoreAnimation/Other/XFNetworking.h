//
//  XFNetworking.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/18.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
@interface XFNetworking : NSObject

+ (AFHTTPRequestOperationManager *)sharedManager;
@end
