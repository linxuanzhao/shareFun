//
//  MyLayout.m
//  yisuipin
//
//  Created by lanou on 16/8/3.
//  Copyright © 2016年 yzl. All rights reserved.
//

#import "MyLayout.h"

@implementation MyLayout

{
    NSMutableArray *_array;
}

-(void)prepareLayout{
    [super prepareLayout];
    //获取item的个数
    _itemCount = (int)[self.collectionView numberOfItemsInSection:0];
    _array = [[NSMutableArray alloc]init];
    //先设定大圆的半径 取长和宽最短的
    CGFloat radius = MIN(self.collectionView.frame.size.width, self.collectionView.frame.size.height)/2.5;
    //计算圆心位置
    CGPoint center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2-100);
    //设置每个item的大小为50*50 则半径为25
    for (int i=0; i<_itemCount; i++) {
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        //设置item大小
        attris.size = CGSizeMake(100, 100);
        //计算每个item的圆心位置
        /*
         .
         . .
         .   . r
         .     .
         .........
         */
        //计算每个item中心的坐标
        //算出的x y值还要减去item自身的半径大小
        float x = center.x+cosf(2*M_PI/_itemCount*i)*(radius-25);
        float y = center.y+sinf(2*M_PI/_itemCount*i)*(radius-25);
        
        attris.center = CGPointMake(x, y);
        [_array addObject:attris];
    }
    
    
    
}
//设置内容区域的大小
-(CGSize)collectionViewContentSize{
    return CGSizeMake(400, 400);
}
//返回设置数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _array;
}






@end
