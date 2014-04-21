//
//  LC_RootViewController.m
//  LicaiBao
//
//  Created by mac on 14-1-26.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "LC_RootViewController.h"


@interface LC_RootViewController ()< UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_fundArray;
    UITableView *_homeTableView;
    LC_AppDelegate *_appdelegate;
    MJRefreshHeaderView *_header;
    UILabel *_dateLabel;
}

@end

@implementation LC_RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"理财宝";
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x3b95d3)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    // 适配IOS7
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 5, 50, 14)];
    [titleImageView setImage:[UIImage imageNamed:@"title-home"]];
    [titleView addSubview:titleImageView];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 20)];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
    _dateLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Time"]];
    [titleView addSubview:_dateLabel];
    
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshBarItemClick:)];
    
    UIBarButtonItem *setBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"set-up"] style:UIBarButtonItemStylePlain target:self action:@selector(setBarItemClick:)];
    self.navigationItem.leftBarButtonItem = refreshBarItem;
    self.navigationItem.rightBarButtonItem = setBarItem;
    
    _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, MAIN_WINDOW_HEIGHT) style:UITableViewStylePlain];
    _homeTableView.delegate = self;
    _homeTableView.dataSource = self;
    _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _homeTableView.backgroundColor = UIColorFromRGB(0xf4f1e2);
    [self.view addSubview:_homeTableView];
    
    [self addHeader];
    
    _fundArray = [[NSArray alloc] init];
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _homeTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        
        _appdelegate = [UIApplication sharedApplication].delegate;
        
        NSMutableString *allCode = [[NSMutableString alloc] init];
        for (NSDictionary *fundDic in _appdelegate.fundArray)
        {
            [allCode appendString:[NSString stringWithFormat:@"%@,",[fundDic objectForKey:@"code"]]];
        }
        
        LC_Network *network = [[LC_Network alloc] init];
        network.delegate = self;
        [network startDownload:[NSString stringWithFormat:@"http://wiapi.hexun.com/fund/getnv.php?s=%@",allCode]];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
    };
    [header beginRefreshing];
    _header = header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fundArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    LC_HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LC_HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    
    LC_Fund *fund = [_fundArray objectAtIndex:indexPath.row];
    cell.fundNameLabel.text = fund.name;
    cell.companyLabel.text = fund.company;
    cell.sevenDay.text = fund.sevenDay;
    cell.wanFen.text = fund.net;
    return cell;
}

// 设置标题视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.frame = CGRectMake(0, 0, MAIN_WINDOW_WIDTH, 35);
    [headerView setImage:[UIImage imageNamed:@"title"]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LC_Fund *fund = [_fundArray objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LC_FundInfoViewController *fundInfoViewController = [[LC_FundInfoViewController alloc] initWithFund:fund WithNumOfAllFund:_fundArray.count AndRank:indexPath.row+1];
    [self.navigationController pushViewController:fundInfoViewController animated:YES];
}

#pragma mark - networkDelegate
- (void)downloadFinish:(NSData *)data
{
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSMutableArray *funds = [[NSMutableArray alloc] init];
    for (NSDictionary *fundDic in _appdelegate.fundArray)
    {
        LC_Fund *fund = [[LC_Fund alloc] init];
        for (NSString *code in resultDic)
        {
            if ([[fundDic objectForKey:@"code"] isEqualToString:code])
            {
                fund.name = [fundDic objectForKey:@"name"];
                fund.company = [fundDic objectForKey:@"company"];
                fund.sevenDay = [NSString stringWithFormat:@"%.3lf%@",[[[resultDic objectForKey:code] objectForKey:@"net"] doubleValue], @"%"];
                fund.net = [NSString stringWithFormat:@"%.3lf%@",[[[resultDic objectForKey:code] objectForKey:@"unit"] doubleValue], @"%"];
                fund.fundCode = code;
            }
        }
        
        if ([[DataBase shareDataBase] selectFund:fund.fundCode])
        {
            [[DataBase shareDataBase] updateFund:fund];
        }
        else
        {
            [[DataBase shareDataBase] insertFund:fund];
        }
        
        [funds addObject:fund];
    }
    
    _fundArray = [funds sortedArrayUsingComparator:^NSComparisonResult(LC_Fund *fund1, LC_Fund *fund2)
                  {
                      NSComparisonResult result = [fund1.sevenDay compare:fund2.sevenDay];
                      return result == NSOrderedAscending;
                  }];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@",[self todayDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"MJRefreshHeaderView"]]];
    
    [_homeTableView reloadData];
    [_header endRefreshing];
}

- (void)downloadFail:(NSError *)error
{
    NSMutableArray *dataBaseArray = [[DataBase shareDataBase] selectAllFund];
    _fundArray = [dataBaseArray sortedArrayUsingComparator:^NSComparisonResult(LC_Fund *fund1, LC_Fund *fund2)
                  {
                      NSComparisonResult result = [fund1.sevenDay compare:fund2.sevenDay];
                      return result == NSOrderedAscending;
                  }];
    [_homeTableView reloadData];

    [_header endRefreshing];
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

// 关于按钮点击
- (void)refreshBarItemClick:(UIBarButtonItem *)sender
{
    [_header beginRefreshing];
}

// 设置按钮点击
- (void)setBarItemClick:(UIBarButtonItem *)sender
{
    LC_SettingViewController *settingViewController = [[LC_SettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

// 设置状态栏显示颜色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
