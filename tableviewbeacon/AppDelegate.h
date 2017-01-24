//
//  AppDelegate.h
//  tableviewbeacon
//
//  Created by 研发部 on 2016/11/30.
//  Copyright © 2016年 SKYTang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *rootViewController;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

