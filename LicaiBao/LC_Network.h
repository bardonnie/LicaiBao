//
//  LC_Network.h
//  LicaiBao
//
//  Created by mac on 14-2-12.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworKDelegate <NSObject>

- (void)downloadFail:( NSError *)error;

- (void)downloadFinish;

@end

@interface LC_Network : NSObject
{
    __weak id < NetworKDelegate> _delegate;
}

@property (nonatomic, weak) __weak id< NetworKDelegate> delegate;

+ (LC_Network *)shareNetwork;

- (void)downloadAllFundInfo:(NSArray *)fundArray;

@end
