//
//  SensorManager.h
//  CompassDemo
//
//  Created by Xhorse on 2019/9/28.
//  Copyright © 2019 Xhorse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface SensorManager : NSObject 

+ (instancetype)shared;
- (void)startGyroscope;

@property (nonatomic, copy) void (^updateDeviceMotionBlock)(CMDeviceMotion *data);

@end
