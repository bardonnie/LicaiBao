//
//  LC_Network.h
//  LicaiBao
//
//  Created by mac on 14-2-12.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworKDelegate <NSObject>

- (void)downloadFinish:(NSData *)data;
- (void)downloadFail:( NSError *)error;

@end

@interface LC_Network : NSObject
{
    __weak id < NetworKDelegate> _delegate;
}

@property (nonatomic, weak) __weak id< NetworKDelegate> delegate;

- (void)startDownload:(NSString *)url;

+ (LC_Network *)shareNetwork;

- (void)downloadAllFundInfo:(NSArray *)fundArray;

@end
