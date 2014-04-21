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

- (void)createDataBase
{
    _dataBase = [[FMDatabase alloc] initWithPath:[NSString stringWithFormat:@"%@/Documents/funds.db",NSHomeDirectory()]];
    if([_dataBase open])
    {
        NSLog(@"数据库打开成功");
    }
    else
    {
        NSLog(@"数据库打开失败");
    }
}

- (void)createFundsTabel
{
    [_dataBase executeUpdate:@"create table funds(fundID integer primary key autoincrement,code text,name text,company text,seven0 text,net0 text,seven1 text,net1 text)"];
    [_dataBase close];
}

- (void)createFundsDetailTabel
{
    [_dataBase executeUpdate:@""];
}

- (void)insertFund:(LC_Fund *)fund
{
    _dataBase = [[FMDatabase alloc] initWithPath:[NSString stringWithFormat:@"%@/Documents/funds.db",NSHomeDirectory()]];
    if(![_dataBase open])
    {
        NSLog(@"打开数据库失败");
        return;
    }
    NSLog(@"--%d",[fund.fundCode intValue]);
    [_dataBase executeUpdate:@"insert into funds(code,name,company,seven0,net0) values(?,?,?,?,?)",fund.fundCode,fund.name,fund.company,fund.sevenDay,fund.net];
    [_dataBase close];
}

- (void)updateFund:(LC_Fund *)fund
{
    _dataBase = [[FMDatabase alloc] initWithPath:[NSString stringWithFormat:@"%@/Documents/funds.db",NSHomeDirectory()]];
    if(![_dataBase open])
    {
        NSLog(@"打开数据库失败");
        return;
    }
    [_dataBase executeUpdate:@"UPDATE funds SET seven0 = ?, net0 = ? WHERE code = ?",fund.sevenDay, fund.net, fund.fundCode];
    [_dataBase close];
}

- (BOOL)selectFund:(NSString *)fundCode
{
    _dataBase = [[FMDatabase alloc] initWithPath:[NSString stringWithFormat:@"%@/Documents/funds.db",NSHomeDirectory()]];
    if(![_dataBase open])
    {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    FMResultSet *rs = [_dataBase executeQuery:@"SELECT code FROM funds"];
    
    while ([rs next])
    {
//        NSLog(@"-----%@",[rs stringForColumn:@"code"]);
        if ([fundCode isEqualToString:[rs stringForColumn:@"code"]])
        {
            [_dataBase close];
            return YES;
        }
    }
    
    [_dataBase close];
    return NO;
}

- (NSMutableArray *)selectAllFund
{
    _dataBase = [[FMDatabase alloc] initWithPath:[NSString stringWithFormat:@"%@/Documents/funds.db",NSHomeDirectory()]];
    if(![_dataBase open])
    {
        NSLog(@"打开数据库失败");
        return nil;
    }
    // 查询操作
    // rs为查询结果集
    FMResultSet *rs = [_dataBase executeQuery:@"SELECT * FROM funds"];
    
    NSMutableArray *fundArray = [[NSMutableArray alloc] init];
    
    while ([rs next])
    {
        LC_Fund *fund = [[LC_Fund alloc] init];
        fund.fundCode = [rs stringForColumn:@"code"];
        fund.name = [rs stringForColumn:@"name"];
        fund.company = [rs stringForColumn:@"company"];
        fund.sevenDay = [rs stringForColumn:@"seven0"];
        fund.net = [rs stringForColumn:@"net0"];
        
        [fundArray addObject:fund];
    }
    
    [_dataBase close];
    // 遍历结果集
    return fundArray;
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
        NSString *updateWords = [NSString stringWithFormat:@"UPDATE funds SET seven0%d = ?, net0%d = ? WHERE FundsCode = ?",i, i];
        [dataBases executeUpdate:updateWords,fund.sevenDay, fund.net, fund.fundCode];
        i++;
    }
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
        fund.name = [rs stringForColumn:@"FundsName"];
        fund.company = [rs stringForColumn:@"FundsCompany"];
        fund.sevenDay = [rs stringForColumn:@"FundsCode"];
        fund.net = [rs stringForColumn:@"FundsCode"];
        fund.oldSevenDay = [rs stringForColumn:@"FundsCode"];
        fund.oldNet = [rs stringForColumn:@"FundsCode"];
    }
    
    return codeArray;
}





@end
