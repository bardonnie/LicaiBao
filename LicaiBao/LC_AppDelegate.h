//
//  LC_AppDelegate.h
//  LicaiBao
//
//  Created by mac on 14-1-26.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LC_AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *_rootNav;
    NSArray *_fundArray;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootNav;
@property (strong, nonatomic) NSArray *fundArray;
@property (strong, nonatomic) LC_AboutViewController *aboutViewController;


@end
