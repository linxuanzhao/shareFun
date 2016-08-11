//
//  MovieDetail.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import "MovieDetail.h"

@implementation MovieDetail

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"description"]) {
        self.desc = [NSString stringWithFormat:@"%@", value];
    }
}
  
@end
