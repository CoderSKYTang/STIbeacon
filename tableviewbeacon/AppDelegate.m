//
//  AppDelegate.m
//  tableviewbeacon
//
//  Created by 研发部 on 2016/11/30.
//  Copyright © 2016年 SKYTang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
//{
//    // A user can transition in or out of a region while the application is not running.
//    // When this happens CoreLocation will launch the application momentarily, call this delegate method
//    // and we will let the user know via a local notification.
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    
//    if(state == CLRegionStateInside)
//    {
//        notification.alertBody = @"You're inside the region";
//    }
//    else if(state == CLRegionStateOutside)
//    {
//        notification.alertBody = @"You're outside the region";
//    }
//    else
//    {
//        return;
//    }
//    
//    // If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
//    // If its not, iOS will display the notification to the user.
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // This location manager will be used to notify the user of region state transitions.
//    _locationManager = [[CLLocationManager alloc] init];
//    _locationManager.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Display the main menu.
    _viewController = [[ViewController alloc] init];
    _rootViewController = [[UINavigationController alloc] initWithRootViewController:_viewController];
    
    self.window.rootViewController = _rootViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // If the application is in the foreground, we will notify the user of the region's state via an alert.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
