//
//  DetailMovieViewController.h
//  Movie
//
//  Created by linxuanzhao on 16/8/2.
//  Copyright © 2016年 linxuanzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface DetailMovieViewController : UIViewController

@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *movieUrlStr;
@property (nonatomic, strong) NSString *movieId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *actors;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *director;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *logo520692;
@property (nonatomic, strong) NSString *releaseDate;

@property (nonatomic, strong) Movie *movie;


  
@end
