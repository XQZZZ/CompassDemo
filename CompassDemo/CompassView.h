//
//  CompassView.h
//  CompassDemo
//
//  Created by Xhorse on 2019/9/28.
//  Copyright © 2019 Xhorse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompassView : UIView

/**
 *  初始化
 *
 *  @param radius 半径（最小不小于50，最大不大于控件短边的一半）
 *
 *  @return 返回罗盘对象
 */
+ (instancetype)sharedWithRect:(CGRect)rect radius:(CGFloat)radius;

@property (nonatomic, strong) UIColor *horizontalColor;

@end
