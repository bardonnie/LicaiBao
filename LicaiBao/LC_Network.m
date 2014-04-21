//
//  LC_Network.m
//  LicaiBao
//
//  Created by mac on 14-2-12.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#define FUND_DETAIL_URL @"http://wiapi.hexun.com/fund/fundtrend.php?code=%@&c=9"

#import "LC_Network.h"
#import "GDataXMLNode.h"

@implementation LC_Network

@synthesize delegate = _delegate;

static LC_Network *_shareNetwork;

+ (LC_Network *)shareNetwork
{
    if (!_shareNetwork)
    {
        _shareNetwork = [[LC_Network alloc] init];
    }
    return _shareNetwork;
}

- (void)downloadAllFundInfo:(NSArray *)fundArray
{
    for (NSString *fundCode in fundArray)
    {
        [self startDownload:[NSString stringWithFormat:FUND_DETAIL_URL,fundCode] AndFundCode:fundCode];
    }
}

- (void)startDownload:(NSString *)url AndFundCode:(NSString *)fundCode
{
    NSString *URLTmp = url;
    //转码成UTF-8  否则可能会出现错误
    NSString *URLTmp1 = [URLTmp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    URLTmp = URLTmp1;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLTmp]];
        
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", operation.responseString);
        
        NSMutableArray *fundArray = [[NSMutableArray alloc] init];
        
        GDataXMLDocument *root = [[GDataXMLDocument alloc] initWithData:operation.responseData options:0 error:nil];
        for ( GDataXMLElement *element in [root nodesForXPath:@"//data" error:nil])
        {
            LC_Fund *fund = [[LC_Fund alloc] init];
            fund.net = [[[element elementsForName:@"netvalue"] lastObject] stringValue];
            fund.sevenDay = [[[element elementsForName:@"unitnetvalue"] lastObject] stringValue];
            fund.fundCode = fundCode;
            [fundArray addObject:fund];
//            [arrayNet addObject:[[[element elementsForName:@"netvalue"] lastObject] stringValue]];
//            [arrayUnitnet addObject:[[[element elementsForName:@"unitnetvalue"] lastObject] stringValue]];
        }
        [[DataBase shareDataBase] uploadFundInfo:fundArray];
//        _netArray = [[arrayNet reverseObjectEnumerator] allObjects];
//        [sevenDaySimpleLineGraphView reloadGraph];
//        _unitnetArray = [[arrayUnitnet reverseObjectEnumerator] allObjects];
//        [earningsSimpleLineGraphView reloadGraph];
        
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        [_delegate downloadFinish:[[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]]];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failure: %@", error);
        [_delegate downloadFail:error];
        
    }];
    [operation start];
}



@end
