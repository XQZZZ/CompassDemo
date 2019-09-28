//
//  CompassView.m
//  SYCompassDemo
//
//  Created by 陈蜜 on 16/6/27.
//  Copyright © 2016年 sunyu. All rights reserved.
//

#import "CompassView.h"
#import "SensorManager.h"

#define defaultRadius 100

@interface CompassView () 

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, weak) UIView *dialView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, weak) UIView *horizontalView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) SensorManager *manager;

@end

@implementation CompassView

+ (instancetype)sharedWithRect:(CGRect)rect radius:(CGFloat)radius {
    return [[self alloc]initWithFrame:rect radius:radius];
}

- (instancetype)initWithFrame:(CGRect)frame radius:(CGFloat)radius {
    if (self = [super initWithFrame:frame]) {
        _point = CGPointMake(frame.size.width/2, frame.size.height/2);
        _scale = radius/100;
        [self customUI];
        [self startSensor];
    }
    return self;
}

- (void)customUI {
    [self createDial];
    [self createHorizontalView];
    [self resetSize];
}

/**
 *  重置尺寸
 */
- (void)resetSize {
    _dialView.transform = CGAffineTransformScale(_dialView.transform, _scale, _scale);
}

/**
 *  创建表盘
 */
- (void)createDial {
    
    CGFloat dialViewSpace = defaultRadius*2;
    UIView *dialView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dialViewSpace, dialViewSpace)];
    dialView.center = _point;

    _dialView = dialView;
    [self addSubview:_dialView];
    
    UIBezierPath *bezPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_dialView.frame.size.width/2, _dialView.frame.size.height/2)
                                                           radius:defaultRadius
                                                       startAngle:-M_PI_2
                                                         endAngle:M_PI_2*3
                                                        clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 3.5;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.path = bezPath.CGPath;
    self.shapeLayer = shapeLayer;
    [_dialView.layer addSublayer:shapeLayer];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    middleView.center = _point;
    middleView.layer.borderWidth = 1.5;
    middleView.layer.borderColor = [UIColor whiteColor].CGColor;
    middleView.layer.cornerRadius = middleView.frame.size.width / 2;
    middleView.layer.masksToBounds = YES;
    _middleView = middleView;
    [self addSubview:self.middleView];
}

/**
 *  创建水平仪 (中间点)
 */
- (void)createHorizontalView {
    UIView *horizontalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    horizontalView.center = _point;
    horizontalView.backgroundColor = [UIColor redColor];
    horizontalView.layer.cornerRadius = horizontalView.frame.size.height/2;
    horizontalView.layer.masksToBounds = YES;
    _horizontalView = horizontalView;
    [self addSubview:_horizontalView];
}

/**
 *  启动传感器
 */
- (void)startSensor {
    __weak typeof(self)mySelf = self;
    _manager = [SensorManager shared];
    
    _manager.updateDeviceMotionBlock = ^(CMDeviceMotion *data){
        
        NSLog(@"gravity.x == %f", data.gravity.x);
        NSLog(@"gravity.y == %f", data.gravity.y);
   
        CGFloat horizontalX = 0.0;
        CGFloat horizontalY = 0.0;
        
        CGFloat fabsf = fabs(data.gravity.x * 100);
        
        if (data.gravity.x > 0) {
            if (data.gravity.x * 100 >= 30) {
                horizontalX = _point.x - 30;
            } else {
                horizontalX = _point.x - data.gravity.x * 100;
            }
        } else {
            if (fabsf >= 30) {
                horizontalX = _point.x + 30;
            } else {
                horizontalX = _point.x +fabsf;
            }
        }
        if (data.gravity.y * 100 >= 30) {
            horizontalY = _point.y + 30;
        } else if (data.gravity.y * 100 <= -30) {
            horizontalY = _point.y - 30;
        } else {
            horizontalY = _point.y + data.gravity.y * 100;
        }
        NSLog(@"x == %f; y == %f", horizontalX, horizontalY);

        // 判断小红圆 是否在大圆内
        BOOL isRect = [mySelf point:CGPointMake(horizontalX, horizontalY) inCircleRect:CGRectMake(mySelf.dialView.frame.origin.x + 10, mySelf.dialView.frame.origin.y + 10, mySelf.dialView.frame.size.width - 20, mySelf.dialView.frame.size.height - 20)];
        if (isRect) {
            NSLog(@"在圆内");
            mySelf.horizontalView.center = CGPointMake(horizontalX, horizontalY);
        } else {
            NSLog(@"不在圆内");
            // 纠正偏移
            if (data.gravity.y * 100 >= 30) {
                mySelf.horizontalView.center = CGPointMake(horizontalX, sqrt(900 - (horizontalX - 50) * (horizontalX - 50)) + 50);
            } else {
                mySelf.horizontalView.center = CGPointMake(horizontalX, -sqrt(900 - (horizontalX - 50) * (horizontalX - 50)) + 50);
            }
        }
        
        // 判断小红圆 是否在小圆内
        BOOL isMiddleRect = [mySelf point:CGPointMake(horizontalX, horizontalY) inCircleRect:CGRectMake(mySelf.middleView.frame.origin.x + 10, mySelf.middleView.frame.origin.y + 10, mySelf.middleView.frame.size.width - 20, mySelf.middleView.frame.size.height - 20)];
        if (isMiddleRect) {
            mySelf.horizontalColor = [UIColor greenColor];
            mySelf.shapeLayer.strokeColor = [UIColor greenColor].CGColor;
        } else {
            mySelf.horizontalColor = [UIColor redColor];
            mySelf.shapeLayer.strokeColor = [UIColor redColor].CGColor;
        }
    };
    [_manager startGyroscope];
}

- (BOOL)point:(CGPoint)point inCircleRect:(CGRect)rect {
    CGFloat radius = rect.size.width/2.0;
    CGPoint center = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);
    double dx = fabs(point.x - center.x);
    double dy = fabs(point.y - center.y);
    double dis = hypot(dx, dy);
    return dis < radius;
}

#pragma mark - 设置属性
- (void)setHorizontalColor:(UIColor *)horizontalColor {
    _horizontalColor = horizontalColor;
    _horizontalView.backgroundColor = [UIColor colorWithCGColor:CGColorCreateCopyWithAlpha(_horizontalColor.CGColor, 1)];
}

- (void)removeAll {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
