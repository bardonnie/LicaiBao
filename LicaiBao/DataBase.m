//
//  DataBase.m
//  LicaiBao
//
//  Created by mac on 14-3-9.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "DataBase.h"

@implementation DataBase
{
    FMDatabase *_dataBase;
}

static DataBase *_shareDataBase;

+ (DataBase *)shareDataBase
{
    if (!_shareDataBase)
    {
        _shareDataBase = [[DataBase alloc] init];
    }
    return _shareDataBase;
}

- (NSArray *)selectFundCode
{
    FMDatabase *dataBases = [[FMDatabase alloc] initWithPath:DB_TO_PATH];
    if(![dataBases open])
    {
        NSLog(@"打开数据库失败");
        return nil;
    }
    
    NSMutableArray *codeArray = [[NSMutableArray alloc] init];
    FMResultSet *rs = [dataBases executeQuery:@"SELECT FundsCode FROM Funds"];
    while ([rs next])
    {
        [codeArray addObject:[rs stringForColumn:@"FundsCode"]];
    }
    [dataBases close];
    return codeArray;
}

- (void)uploadFundInfo:(NSArray *)fundArray
{
    FMDatabase *dataBases = [[FMDatabase alloc] initWithPath:DB_TO_PATH];
    if(![dataBases open])
    {
        NSLog(@"打开数据库失败");
    }
    int i = 1;
    for (LC_Fund *fund in fundArray) {
        NSString *updateWords = [NSString stringWithFormat:@"UPDATE funds SET seven0%d = ?, wanfen0%d = ? ,updatadate = ? WHERE FundsCode = ?",i, i];
        NSString *date = [self todayDate:[NSDate date]];
        [dataBases executeUpdate:updateWords,fund.sevenDay, fund.wanFen, date, fund.fundCode];
        i++;
    }
    [dataBases close];
}

- (NSArray *)selectTodayFund
{
    FMDatabase *dataBases = [[FMDatabase alloc] initWithPath:DB_TO_PATH];
    if(![dataBases open])
    {
        NSLog(@"打开数据库失败");
        return nil;
    }
    
    NSMutableArray *codeArray = [[NSMutableArray alloc] init];
    FMResultSet *rs = [dataBases executeQuery:@"SELECT * FROM Funds"];
    while ([rs next])
    {
        LC_Fund *fund = [[LC_Fund alloc] init];
        fund.fundCode = [rs stringForColumn:@"FundsCode"];
        fund.name = [rs stringForColumn:@"FundsName"];
        fund.company = [rs stringForColumn:@"FundsCompany"];
        fund.sevenDay = [rs stringForColumn:@"seven01"];
        fund.wanFen = [rs stringForColumn:@"wanfen01"];
        fund.oldSevenDay = [rs stringForColumn:@"seven02"];
        fund.oldWanFen = [rs stringForColumn:@"wanfen02"];
        [codeArray addObject:fund];
    }
    return codeArray;
}

- (LC_Fund *)selectTrendsFund:(NSString *)fundName
{
    FMDatabase *dataBases = [[FMDatabase alloc] initWithPath:DB_TO_PATH];
    if(![dataBases open])
    {
        NSLog(@"打开数据库失败");
        return nil;
    }
    
    FMResultSet *rs = [dataBases executeQuery:@"SELECT * FROM Funds WHERE FundsName = ?",fundName];
    
    NSMutableArray *sevenDayArray = [NSMutableArray array];
    NSMutableArray *wanFenArray = [NSMutableArray array];
    
    LC_Fund *fund = [[LC_Fund alloc] init];
    while ([rs next])
    {
        fund.name = [rs stringForColumn:@"FundsName"];
        fund.company = [rs stringForColumn:@"FundsCompany"];
        
        for (int i = 9; i>0; i--)
        {
            [sevenDayArray addObject:[rs stringForColumn:[NSString stringWithFormat:@"seven0%d",i]]];
            [wanFenArray addObject:[rs stringForColumn:[NSString stringWithFormat:@"wanfen0%d",i]]];
        }
        fund.sevenDayArray = sevenDayArray;
        fund.wanFenArray = wanFenArray;
    }
    
    
    return fund;
}

- (NSString *)todayDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd";
    NSString *time = [formatter stringFromDate:date];
    
    [[NSUserDefaults standardUserDefaults] setValue:time forKey:@"Time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return time;
}



@end
