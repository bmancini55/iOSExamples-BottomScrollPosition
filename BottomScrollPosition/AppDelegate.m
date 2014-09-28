//
//  AppDelegate.m
//  BottomScrollPosition
//
//  Created by Brian Mancini on 9/28/14.
//  Copyright (c) 2014 iOSExamples. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    TableViewController *tableViewController = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navConroller = [[UINavigationController alloc]initWithRootViewController:tableViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navConroller;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
