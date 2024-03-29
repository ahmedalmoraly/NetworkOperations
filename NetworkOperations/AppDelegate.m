//
//  AppDelegate.m
//  NetworkOperations
//
//  Created by Ahmad al-Moraly on 12/8/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkOperations.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
//    [NetworkOperation operationWithPath:@"json_test.php?get=1" Paramerters:nil requestMethod:HTTPRequestMethodGET successBlock:^(id JSONResponse) {
//        [NetworkOperation operationWithParamerters:@{@"key" : JSONResponse, @"Jazzar":@"{\"name\":\"John Smith\""} requestMethod:HTTPRequestMethodPOST successBlock:nil andFailureBlock:nil];
//    } andFailureBlock:^(NSError *error) {
//        
//    }];
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"key": @"Jazzar"} options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"JSON string: %@\n\n\nJSON data: %@", json, data);
    [NetworkOperation operationWithParamerters:@{@"key": @"Jazzar"} requestMethod:HTTPRequestMethodPOST successBlock:nil andFailureBlock:nil];

//    [NetworkOperation operationWithParamerters:nil requestMethod:HTTPRequestMethodPOST successBlock:^(id JSONResponse) {
//        [NetworkOperation operationWithParamerters:@{@"key" : JSONResponse} requestMethod:HTTPRequestMethodPOST successBlock:nil andFailureBlock:nil];
//    } andFailureBlock:nil];
    
    UIViewController *viewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
