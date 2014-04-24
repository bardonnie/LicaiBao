//
//  LC_Network.h
//  LicaiBao
//
//  Created by mac on 14-2-12.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworKDelegate <NSObject>

@optional

- (void)downloadFail:( NSError *)error;

- (void)downloadFinish;
- (void)downloadFinishWith:(NSDictionary *)json;

@end

@interface LC_Network : NSObject
{
    __weak id < NetworKDelegate> _delegate;
}

@property (nonatomic, weak) __weak id< NetworKDelegate> delegate;

+ (LC_Network *)shareNetwork;

- (void)downloadAllFundInfo:(NSArray *)fundArray;
- (void)sina:(NSDictionary *)sinaInfo url:(NSString *)url;


@end
