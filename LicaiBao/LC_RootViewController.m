//
//  LC_RootViewController.m
//  LicaiBao
//
//  Created by mac on 14-1-26.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//


#define N_OR_L_TRENDS_U   is_N?[UIImage imageNamed:@"up"]:[UIImage imageNamed:@"up_n"]
#define N_OR_L_TRENDS_D   is_N?[UIImage imageNamed:@"down"]:[UIImage imageNamed:@"down_n"]

#import "LC_RootViewController.h"


@interface LC_RootViewController ()< UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_fundArray;
    UITableView *_homeTableView;
    MJRefreshHeaderView *_header;
    UILabel *_dateLabel;
    BOOL is_N;
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

// 摇一摇代码
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"began");
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"cancel");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"end");
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_show_tip"])
    {
        UIView *waitBackView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 220, 140)];
        waitBackView.backgroundColor = [UIColor clearColor];
        waitBackView.tag = 100;
        [self.view addSubview:waitBackView];
        
        UIView *waitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 140)];
        waitView.layer.cornerRadius = 10.0;
        waitView.backgroundColor = [UIColor blackColor];
        waitView.alpha = 0.85;
        [waitBackView addSubview:waitView];
        
        UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 210, 120)];
        pointLabel.backgroundColor = [UIColor clearColor];
        pointLabel.text = @"摇一摇即可切换模式\n已开启国际模式\n红色代表下降 绿色代表上升\n摇一摇关闭提示";
        pointLabel.textColor = [UIColor whiteColor];
        pointLabel.font = [UIFont boldSystemFontOfSize:16];
        pointLabel.textAlignment = UITextAlignmentCenter;
        pointLabel.numberOfLines = 0;
        pointLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        [waitBackView addSubview:pointLabel];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_show_tip"];
    }
    else
    {
        UIView *view = [self.view viewWithTag:100];
        if (view) {
            [view removeFromSuperview];
        }
        is_N = !is_N;
        if (is_N)
            [SVProgressHUD showSuccessWithStatus:@"已开启本地模式\n红色代表上升 绿色代表下降" duration:2];
        else
            [SVProgressHUD showSuccessWithStatus:@"已开启国际模式\n红色代表下降 绿色代表上升" duration:2];
        // 震动
    }
    [[NSUserDefaults standardUserDefaults] setBool:is_N forKey:@"is_N"];
    [_homeTableView reloadData];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

// 设置标题视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, 35)];
    headerBackView.backgroundColor = [UIColor clearColor];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, 35)];
    alphaView.backgroundColor = [UIColor grayColor];
    alphaView.alpha = 0.7;
    [headerBackView addSubview:alphaView];
    
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.frame = CGRectMake(0, 0, MAIN_WINDOW_WIDTH, 35);
    [headerView setImage:[UIImage imageNamed:@"title"]];
    [headerBackView addSubview:headerView];
    return headerBackView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"理财宝";
    
    if (IOS7_OR_LATER) {
        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x3b95d3)];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.translucent = NO;
        // 适配IOS7
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
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
    
    _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, MAIN_WINDOW_HEIGHT-STATUS_BAR_AND_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
    _homeTableView.delegate = self;
    _homeTableView.dataSource = self;
    _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _homeTableView.backgroundColor = UIColorFromRGB(0xf4f1e2);
    [self.view addSubview:_homeTableView];
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    LC_TipsScrollView *tipsScrollView = [[LC_TipsScrollView alloc] initWithFrame:CGRectMake(10, 10, 300, 36) AndTips:@[@"网易现金宝、新浪存钱罐和苏宁零钱宝-汇添富是同一款理财产品，故收益趋势一致。",@"腾讯理财通-广发天天红和苏宁零钱宝-广发天天红是同一款理财产品，故收益趋势一致。"]];
    [tipView addSubview:tipsScrollView];
    _homeTableView.tableFooterView = tipView;
    
    [self selectFundData];
    [self addHeader];
    
    is_N = [[NSUserDefaults standardUserDefaults] boolForKey:@"is_N"];
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _homeTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        [[LC_Network shareNetwork] downloadAllFundInfo:[[DataBase shareDataBase] selectFundCode]];
        [LC_Network shareNetwork].delegate = self;
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
        
        // 要播放的音频文件地址
        NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:urlPath];
        // 声明需要播放的音频文件ID[unsigned long]
        SystemSoundID ID;
        // 创建系统声音，同时返回一个ID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &ID);
        AudioServicesPlaySystemSound(ID);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
    };
    [header beginRefreshing];
    _header = header;
}

#pragma mark - networkDelegate
- (void)downloadFinish
{
    [self selectFundData];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    _dateLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Time"]];
    [_header endRefreshing];
}

- (void)downloadFail:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"请连接网络获取最新排名" duration:2];
    [self selectFundData];
    [_header endRefreshing];
}

- (void)selectFundData
{
    _fundArray = [NSArray array];
    NSMutableArray *fundMutableArray = [NSMutableArray arrayWithArray:[[DataBase shareDataBase] selectTodayFund]];
    [fundMutableArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        LC_Fund *doc1 = (LC_Fund*)obj1;
        LC_Fund *doc2 = (LC_Fund*)obj2;
        return [doc2.sevenDay compare:doc1.sevenDay];
    }];
    _fundArray = fundMutableArray;
    [_homeTableView reloadData];
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
    
    for (UIView *view in [cell.contentView subviews]) {
        if (view.tag == 1000) {
            [view removeFromSuperview];
        }
    }
    
    LC_Fund *fund = [_fundArray objectAtIndex:indexPath.row];
    cell.fundNameLabel.text = fund.name;
    cell.companyLabel.text = fund.company;
    cell.sevenDay.text = fund.sevenDay;
    cell.wanFen.text = fund.wanFen;
    
    if (fund.sevenDay)
    {
        UIImageView *sevenDayTrendsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 20, 8, 12)];
        sevenDayTrendsImageView.tag = 1000;
        [cell.contentView addSubview:sevenDayTrendsImageView];
        
        UIImageView *wanFenTrendsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(240, 20, 8, 12)];
        wanFenTrendsImageView.tag = 1000;
        [cell.contentView addSubview:wanFenTrendsImageView];
        
        if ([fund.oldSevenDay floatValue] < [fund.sevenDay floatValue])
            [sevenDayTrendsImageView setImage:N_OR_L_TRENDS_U];
        else
            [sevenDayTrendsImageView setImage:N_OR_L_TRENDS_D];
        
        
        if ([fund.oldWanFen floatValue] < [fund.wanFen floatValue])
            [wanFenTrendsImageView setImage:N_OR_L_TRENDS_U];
        else
            [wanFenTrendsImageView setImage:N_OR_L_TRENDS_D];
    }
    
    return cell;
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
    LC_FundInfoViewController *fundInfoViewController = [[LC_FundInfoViewController alloc] initWithFundName:fund.name FundCount:_fundArray.count AndFundRank:indexPath.row];
    [self.navigationController pushViewController:fundInfoViewController animated:YES];
    
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
