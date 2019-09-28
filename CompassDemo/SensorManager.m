//
//  SensorManager.m
//  CompassDemo
//
//  Created by Xhorse on 2019/9/28.
//  Copyright © 2019 Xhorse. All rights reserved.
//

#import "SensorManager.h"

@interface SensorManager ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation SensorManager

+ (instancetype)shared {
    return [[self alloc]init];
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)startGyroscope {
    _motionManager = [[CMMotionManager alloc]init];
    
    if (_motionManager.deviceMotionAvailable) {
        _motionManager.deviceMotionUpdateInterval = 1/30;
        __weak typeof(self)mySelf = self;
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMDeviceMotion *data, NSError *error) {
            if (mySelf.updateDeviceMotionBlock) {
                mySelf.updateDeviceMotionBlock(data);
            }
        }];
    }
}

@end
