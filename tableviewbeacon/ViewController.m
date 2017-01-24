//
//  ViewController.m
//  tableviewbeacon
//
//  Created by 研发部 on 2016/11/30.
//  Copyright © 2016年 SKYTang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

#define BEACONUUID @"FDA50493-A4E2-4FB1-AFCF-C6EB07647888"//iBeacon的uuid可以换成自己设备的uuid

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    [self initLocationManager];
    [self initBeaconArr];
    [self initBeaconRegion];
    
}

#pragma mark ----------------------
#pragma mark Init Methods
- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 320, 400)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)initLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];//初始化
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];//设置location是一直允许
    }
    
//    self.locationManager.activityType = CLActivityTypeFitness;
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)initBeaconArr {
    self.beaconArr = [[NSArray alloc] init];
}

- (void)initBeaconRegion {
    //初始化监测的iBeacon信息
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:BEACONUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:@"media"];
    //when the user enters the region. By default, this is YES.调用locationManager:didEnterRegion:代理方法
    self.beaconRegion.notifyOnEntry = YES;
    //when the user exits the region. By default, this is YES. 调用locationManager:didExitRegion:代理方法
    self.beaconRegion.notifyOnExit = YES;
    //屏幕亮起，. By default, this is NO.调用locationManager:didDetermineState:forRegion:代理方法
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
}

#pragma mark Beacons Ranging
- (void)startBeaconRanging {
    if (!self.locationManager || !self.beaconRegion) {
        return;
    }
    if (self.locationManager.rangedRegions.count > 0) {
        NSLog(@"Didn't turn on ranging: Ranging already on.");
        return;
    }
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];//开始RegionBeacons
    [self.locationManager startMonitoringForRegion:self.beaconRegion];//开始MonitoringiBeacon
    
//    [self.locationManager requestStateForRegion:self.beaconRegion];
//    [self.locationManager startUpdatingLocation];
}

- (void)stopBeaconRanging {
    if (!self.locationManager || !self.beaconRegion) {
        return;
    }
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

#pragma mark ----------------------
#pragma mark CLlocationManagerDelegate
//发现有iBeacon进入监测范围
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
}

//发现有iBeacon退出监测范围
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self startBeaconRanging];
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    // A user can transition in or out of a region while the application is not running.
    // When this happens CoreLocation will launch the application momentarily, call this delegate method
    // and we will let the user know via a local notification.
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if(state == CLRegionStateInside)
    {
        notification.alertBody = @"You're inside the region";
    }
    else if(state == CLRegionStateOutside)
    {
        notification.alertBody = @"You're outside the region";
    }
    else
    {
        return;
    }
    
    // If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
    // If its not, iOS will display the notification to the user.
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}
    
//找的iBeacon后扫描它的信息
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    if (beacons.count == 0) {
        NSLog(@"No beacons found nearby.");
    } else {
        //如果存在不是我们要监测的iBeacon那就停止扫描他
        if (![[region.proximityUUID UUIDString] isEqualToString:BEACONUUID]){
            [self.locationManager stopMonitoringForRegion:region];
            [self.locationManager stopRangingBeaconsInRegion:region];
        }
        self.beaconArr = beacons;
        NSLog(@"beacons count:%lu", beacons.count);
        
        //打印所有iBeacon的信息
        for (CLBeacon * beacon in beacons) {
            NSLog(@"%@", [self detailsStringForBeacon:beacon]);
        }
        [self.tableView reloadData];
    }
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    
//}

#pragma mark Process Beacon Information
//将beacon的信息转换为NSString并返回
- (NSString *)detailsStringForBeacon:(CLBeacon *)beacon
{
    NSString *format = @"%@ • %@ • %@ • %f • %li";
    return [NSString stringWithFormat:format, beacon.major, beacon.minor, [self stringForProximity:beacon.proximity], beacon.accuracy, beacon.rssi];
}

- (NSString *)stringForProximity:(CLProximity)proximity{
    NSString *proximityValue;
    switch (proximity) {
        case CLProximityNear:
            proximityValue = @"近";
            break;
        case CLProximityImmediate:
            proximityValue = @"超近";
            break;
        case CLProximityFar:
            proximityValue = @"远";
            break;
        case CLProximityUnknown:
        default:
            proximityValue = @"不见了";
            break;
    }
    return proximityValue;
}

#pragma mark ----------------------
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beaconArr.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    CLBeacon *beacon = [self.beaconArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [beacon.proximityUUID UUIDString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %ld %@ %@",[self stringForProximity:beacon.proximity],beacon.rssi,beacon.major,beacon.minor];
    return cell;
    
}

@end
