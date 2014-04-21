//
//  DataBase.h
//  LicaiBao
//
//  Created by mac on 14-3-9.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LC_Fund.h"


@interface DataBase : NSObject

+ (DataBase *)shareDataBase;

- (NSString *)todayDate:(NSDate *)date;

- (NSArray *)selectFundCode;

- (void)uploadFundInfo:(NSArray *)fundArray;

- (NSArray *)selectTodayFund;
- (NSArray *)selectTrendsFund:(NSString *)fundCode;

@end
