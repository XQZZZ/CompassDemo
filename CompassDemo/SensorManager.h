//
//  SensorManager.h
//  SYCompassDemo
//
//  Created by 陈蜜 on 16/6/27.
//  Copyright © 2016年 sunyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface SensorManager : NSObject 

+ (instancetype)shared;
- (void)startGyroscope;

@property (nonatomic, copy) void (^updateDeviceMotionBlock)(CMDeviceMotion *data);

@end
