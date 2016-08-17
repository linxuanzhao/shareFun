//
//  ClearnCache.m
//  YueMi
//
//  Created by lanou on 16/6/22.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import "ClearnCache.h"
#import "MBProgressHUD.h"

@implementation ClearnCache

//计算单个文件的大小
+(long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
}


//计算整个缓存目录的大小
+(float)caChefolderSizePath
{
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath]objectEnumerator];
    
    NSString *fileName;
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    
    return folderSize / (1024.0 *1024.0)+[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    
}


//异步清理缓存

+(void)cleanCache:(cleanCacheBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
        
        NSArray *subPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
        
        for (NSString *subPath in subPaths) {
            
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        [[SDImageCache sharedImageCache] cleanDisk];
        //返回主线程
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //自定义的block方法
//            block();
//        });
        
    });
}

+(void)modeSwitchingExampleWithView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.labelText = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        [self doSomeWorkWithMixedProgressWithView:view];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[hud hideAnimated:YES];
            [hud hide:YES];
        });
    });
}

+(void)doSomeWorkWithMixedProgressWithView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    // Indeterminate mode
    sleep(1);
    // Switch to determinate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeDeterminate;
       // hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
        hud.labelText = NSLocalizedString(@"Loading...", @"HUD loading title");
    });
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
        usleep(50000);
    }
    // Back to indeterminate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = NSLocalizedString(@"Cleaning up...", @"HUD cleanining up title");
    });
    sleep(1);
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [[UIImage imageNamed:@"checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"Completed", @"HUD completed title");
    });
    sleep(1);
}




@end
