//
//  DetailCell.h
//  YzlRadio
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *descLable;
@property (weak, nonatomic) IBOutlet UILabel *numberLable;
@property (weak, nonatomic) IBOutlet UILabel *EpisodesLable;
@property (weak, nonatomic) IBOutlet UIImageView *HandleImageView;

@end
