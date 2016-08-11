//
//  NewsModel.m
//  YzlRadio
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.desc = [NSString stringWithFormat:@"%@",value];
    }
}


@end
