//
//  AppDelegate.m
//  Note
//
//  Created by 朱鑫华 on 2017/11/22.
//  Copyright © 2017年 朱鑫华. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoginVC.h"
#import "RegisterVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AVOSCloud setApplicationId:@"lNq2g7FCNVoWwRqiydUEXOwF-gzGzoHsz" clientKey:@"I2p0vTv0FImDAtJwoYTPtGnr"];
//    [AVOSCloud setAllLogsEnabled:YES];
    
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    NSLog(@"用户名:%@",name);
    if(name.length <= 0){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginVC *loginVc = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
        self.window = [[UIWindow alloc] init];
        [self.window makeKeyAndVisible];
        self.window.frame = [[UIScreen mainScreen] bounds];
        [self.window setRootViewController:loginVc];  
    }else{
        
    }
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
