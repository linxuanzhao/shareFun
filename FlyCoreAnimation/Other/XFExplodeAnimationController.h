//
//  CEExplodeAnimationController.h
//  TransitionsDemo
//
//  Created by Colin Eberhardt on 11/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "XFReversibleAnimationController.h"
#import <Foundation/Foundation.h>
/**
 Animates between the two view controllers by slicing the from- view controller into lots of little pieces, then randomly spinning and shrinking them.
 */
@interface XFExplodeAnimationController : CEReversibleAnimationController

@end