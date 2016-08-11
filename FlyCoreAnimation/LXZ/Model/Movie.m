//
//  Movie.m
//  Movie
//
//  Created by linxuanzhao on 16/8/2.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import "Movie.h"

@implementation Movie
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
 
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.movieId = [NSString stringWithFormat:@"%@", value];
    }
}

@end
