//
//  LC_AppDelegate.m
//  LicaiBao
//
//  Created by mac on 14-1-26.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "LC_AppDelegate.h"
#import "BPush.h"


@implementation LC_AppDelegate
@synthesize rootNav = _rootNav;
@synthesize fundArray = _fundArray;
@synthesize aboutViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSLog(@"path - %@",NSHomeDirectory());
    
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
    [UMSocialData setAppKey:UMENG_APP_KEY];
    [UMSocialWechatHandler setWXAppId:@"wxe84e60dedee01c9d" url:@"https://itunes.apple.com/us/app/li-cai-bao-hu-lian-wang-li/id867471431?ls=1&mt=8"];
    
    [MobClick startWithAppkey:UMENG_APP_KEY];
    [MobClick checkUpdate:@"哔～～发现新版本" cancelButtonTitle:@"取消" otherButtonTitles:@"去下载"];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"2014.01.01" forKey:@"Time"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_N"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_push"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_show_tip"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_care_w"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_care_c"];

        NSFileManager * fm = [NSFileManager defaultManager];
        NSError * error = nil;
        BOOL ret = [fm copyItemAtPath:DB_AT_PATH
                               toPath:DB_TO_PATH
                                error:&error];
        if (ret)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        NSLog(@"-- 2");
        
    }
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    LC_RootViewController *rootViewController = [[LC_RootViewController alloc] init];
    _rootNav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = _rootNav;
    
    aboutViewController = [[LC_AboutViewController alloc] init];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken:deviceToken];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_push"])
        [BPush bindChannel];
    else
        [BPush unbindChannel];
}

- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
    if ([BPushRequestMethod_Bind isEqualToString:method])
    {
//        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [BPush handleNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"----1");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"----2");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"----3");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    NSLog(@"----4");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"----5");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
