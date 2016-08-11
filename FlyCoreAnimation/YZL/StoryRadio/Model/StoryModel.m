//
//  StoryModel.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/10.
//  Copyright © 2016年 he. All rights reserved.
//

#import "StoryModel.h"

@implementation StoryModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.desc = [NSString stringWithFormat:@"%@",value];
    }
}


@end
