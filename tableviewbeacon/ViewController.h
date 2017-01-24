//
//  ViewController.h
//  tableviewbeacon
//
//  Created by 研发部 on 2016/11/30.
//  Copyright © 2016年 SKYTang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *beaconArr;//存放扫描到的iBeacon

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;//被扫描的iBeacon

@property (strong, nonatomic) CLLocationManager * locationManager;

@end

