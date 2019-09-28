//
//  ViewController.m
//  CompassDemo
//
//  Created by Xhorse on 2019/9/28.
//  Copyright © 2019 Xhorse. All rights reserved.
//

#import "ViewController.h"
#import "CompassView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CompassView *compassView = [CompassView sharedWithRect:CGRectMake(self.view.center.x, self.view.center.y, 100, 100) radius:(100 - 20)/2];
    compassView.backgroundColor = [UIColor blackColor];
    compassView.horizontalColor = [UIColor redColor];
    [self.view addSubview:compassView];
}

@end
