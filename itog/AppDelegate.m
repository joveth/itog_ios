//
//  AppDelegate.m
//  itog
//
//  Created by Shuwei on 15/10/15.
//  Copyright © 2015年 jov. All rights reserved.
//

#import "AppDelegate.h"
#import <ChameleonFramework/Chameleon.h>
#import "Common.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setBarTintColor:FlatRed];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:FlatWhite forKey:NSForegroundColorAttributeName];
    [UINavigationBar appearance].titleTextAttributes=dict;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
