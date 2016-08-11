//
//  NewsCell.h
//  YzlRadio
//
//  Created by lanou on 16/8/6.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *handleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *descLable;
@property (weak, nonatomic) IBOutlet UILabel *countLable;
@property (weak, nonatomic) IBOutlet UILabel *trackLable;
@property (weak, nonatomic) IBOutlet UIImageView *ImageV;

@end
