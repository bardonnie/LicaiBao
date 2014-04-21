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

- (void)createDataBase;
- (void)createFundsTabel;
- (void)insertFund:(LC_Fund *)fund;
- (void)updateFund:(LC_Fund *)fund;
- (BOOL)selectFund:(NSString *)fundCode;

- (NSArray *)selectFundCode;

- (NSMutableArray *)selectAllFund;
- (void)uploadFundInfo:(NSArray *)fundArray;

@end
