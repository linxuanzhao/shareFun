//
//  XFAnnotation.h
//  FlyCoreAnimation
//
//  Created by lanou on 16/8/9.
//  Copyright © 2016年 he. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <BaiduMapAPI_Map/BMKMapComponent.h>

typedef NSUInteger BMKPinAnnotationColor;

///提供类似大头针效果的annotation view
@interface XFAnnotation : BMKActionPaopaoView
{
@private
    BMKPinAnnotationColor _pinColor;
    BOOL _animatesDrop;
}
///大头针的颜色，有BMKPinAnnotationColorRed, BMKPinAnnotationColorGreen, BMKPinAnnotationColorPurple三种
@property (nonatomic) BMKPinAnnotationColor pinColor;
///动画效果
@property (nonatomic) BOOL animatesDrop;


-(instancetype)init;

@end




