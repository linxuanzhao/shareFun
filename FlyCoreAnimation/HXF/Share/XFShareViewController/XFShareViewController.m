//
//  XFShareViewController.m
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/5.
//  Copyright © 2016年 he. All rights reserved.
//

#import "XFShareViewController.h"
#import "XFMapViewController.h"
@interface XFShareViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentC;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation XFShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [[NSBundle mainBundle]loadNibNamed:@"XFShareViewController" owner:self options:nil];
 //   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_left - circle"] style:0 target:self action:@selector(back)];
    
                                            
}
- (IBAction)back2RootView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)segmentChange:(id)sender {
    if (self.segmentC.selectedSegmentIndex == 0) {
        XFMapViewController *XFMapVC = [[XFMapViewController alloc]init];
        XFMapVC.searchBarText = self.searchBar.text;
        [self.navigationController pushViewController:XFMapVC animated:YES];
    }
}
- (IBAction)rightButtonClick:(id)sender {
}

-(void)back{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
