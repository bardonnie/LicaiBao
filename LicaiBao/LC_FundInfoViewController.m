//
//  LC_FundInfoViewController.m
//  LicaiBao
//
//  Created by mac on 14-2-11.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "LC_FundInfoViewController.h"
#import "GDataXMLNode.h"


@interface LC_FundInfoViewController ()<UMSocialShakeDelegate, UMSocialUIDelegate>
{
    NSString *_fundCode;
    NSString *_fundName;
    NSString *_companyName;
    NSString *_sevenDayStr;
    NSString *_earningsStr;
    NSArray *_netArray;
    NSArray *_unitnetArray;
    UILabel *_earningsLabel;
    UILabel *_sevenDayLabel;
    
    int _fundCount;
    int rankNum;
}

@end

@implementation LC_FundInfoViewController

@synthesize sevenDaySimpleLineGraphView,earningsSimpleLineGraphView;

- (id)initWithFundName:(NSString *)fundName FundCount:(int)fundCount AndFundRank:(int)fundRank
{
    self = [super init];
    if (self) {
        
        LC_Fund *fund = [[DataBase shareDataBase] selectTrendsFund:fundName];
        
        _fundName = [NSString stringWithString:fund.name];
        _companyName = [NSString stringWithString:fund.company];
        _sevenDayStr = [NSString stringWithString:[fund.sevenDayArray lastObject]];
        _earningsStr = [NSString stringWithString:[fund.wanFenArray lastObject]];
        
        _unitnetArray = [NSArray arrayWithArray:fund.wanFenArray];
        _netArray = [NSArray arrayWithArray:fund.sevenDayArray];
        
        _fundCount = fundCount;
        rankNum = fundRank+1;
    }
    return self;
}

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
    self.view.backgroundColor = UIColorFromRGB(0xf4f1e2);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 摇一摇分享
    [UMSocialShakeService setShakeToShareWithTypes:nil
                                         shareText:nil
                                      screenShoter:nil
                                  inViewController:self
                                          delegate:self];
    
    // 分享按钮
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClick:)];
    self.navigationItem.rightBarButtonItem = shareBarItem;
    
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarItem:)];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 5, 50, 14)];
    [titleImageView setImage:[UIImage imageNamed:@"title-home"]];
    [titleView addSubview:titleImageView];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 20)];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Time"]];
    dateLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
    [titleView addSubview:dateLabel];
    
    self.navigationItem.titleView = titleView;
    
    UIScrollView *fundInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, MAIN_WINDOW_HEIGHT)];
    fundInfoScrollView.contentSize = CGSizeMake(MAIN_WINDOW_WIDTH, 480);
    [self.view addSubview:fundInfoScrollView];
    
    // 基金名字标签
    UILabel *fundNameLabel = [[UILabel alloc] init];
    fundNameLabel.frame = CGRectMake( 10, 10, 154, 32);
    fundNameLabel.backgroundColor = [UIColor clearColor];
    [fundNameLabel setFont:[UIFont boldSystemFontOfSize:22]];
    fundNameLabel.textAlignment = NSTextAlignmentCenter;
    fundNameLabel.text = _fundName;
    fundNameLabel.textColor = UIColorFromRGB(0x3b95d3);
    [fundNameLabel sizeToFit];
    [fundInfoScrollView addSubview:fundNameLabel];
    
    // 基金所属公司名称标签
    UILabel *companyNameLabel = [[UILabel alloc] init];
    companyNameLabel.frame = CGRectMake( 10+fundNameLabel.frame.size.width, 16, 80, 22);
    companyNameLabel.backgroundColor = [UIColor clearColor];
    [companyNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.text = _companyName;
    companyNameLabel.textColor = UIColorFromRGB(0x454443);
//    [companyNameLabel sizeToFit];
    [fundInfoScrollView addSubview:companyNameLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, 110, 30)];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.text = [NSString stringWithFormat:@"收益排名:   /%d",_fundCount];
    [fundInfoScrollView addSubview:numLabel];
    
    UILabel *rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 0, 10, 30)];
    rankLabel.backgroundColor = [UIColor clearColor];
    rankLabel.font = [UIFont boldSystemFontOfSize:14];
    rankLabel.text = [NSString stringWithFormat:@"%d",rankNum];
    rankLabel.textColor = UIColorFromRGB(0xf96231);
    [numLabel addSubview:rankLabel];
    
//----------------------------------------------------
    
    UIImageView *sevenDayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 300, 170)];
    sevenDayImageView.userInteractionEnabled = YES;
    sevenDayImageView.layer.cornerRadius = 6;//设置那个圆角的有多圆
    sevenDayImageView.layer.masksToBounds = YES;//设为NO去试试
    [sevenDayImageView setImage:[UIImage imageNamed:@"trendback"]];
    [fundInfoScrollView addSubview:sevenDayImageView];
    
    // 七日转化率标签
    UILabel *sevenLabel = [[UILabel alloc] init];
    sevenLabel.frame = CGRectMake( 0, 0, 100, 40);
    sevenLabel.textAlignment = NSTextAlignmentCenter;
    sevenLabel.backgroundColor = [UIColor clearColor];
    sevenLabel.font = [UIFont systemFontOfSize:16];
    sevenLabel.text = @"7日年收益:";
    sevenLabel.textColor = [UIColor blackColor];
    [sevenDayImageView addSubview:sevenLabel];
    
    _sevenDayLabel = [[UILabel alloc] init];
    _sevenDayLabel.frame = CGRectMake( 100, 0, 60, 40);
    _sevenDayLabel.textAlignment = NSTextAlignmentCenter;
    _sevenDayLabel.backgroundColor = [UIColor clearColor];
    _sevenDayLabel.font = [UIFont systemFontOfSize:16];
    _sevenDayLabel.text = [NSString stringWithFormat:@"%@",_sevenDayStr];
    _sevenDayLabel.textColor = UIColorFromRGB(0xf96231);
    [sevenDayImageView addSubview:_sevenDayLabel];
    
    // 七日转化率趋势图
    sevenDaySimpleLineGraphView = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 40, 300, 130)];
    sevenDaySimpleLineGraphView.tag = 100;
    sevenDaySimpleLineGraphView.delegate = self;
    sevenDaySimpleLineGraphView.enableTouchReport = YES;
    sevenDaySimpleLineGraphView.colorTop = [UIColor whiteColor];
    sevenDaySimpleLineGraphView.colorBottom = [UIColor whiteColor];
    sevenDaySimpleLineGraphView.backgroundColor = [UIColor whiteColor];
    sevenDaySimpleLineGraphView.tintColor = [UIColor blueColor];
    sevenDaySimpleLineGraphView.widthLine = 3.0;
    sevenDaySimpleLineGraphView.colorXaxisLabel = [UIColor blackColor];
    sevenDaySimpleLineGraphView.colorLine = UIColorFromRGB(0xffc955);
    [sevenDayImageView addSubview:sevenDaySimpleLineGraphView];
    
//----------------------------------------------------
    
    UIImageView *earningsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 230, 300, 170)];
    earningsImageView.userInteractionEnabled = YES;
    earningsImageView.layer.cornerRadius = 6;//设置那个圆角的有多圆
    earningsImageView.layer.masksToBounds = YES;//设为NO去试试
    [earningsImageView setImage:[UIImage imageNamed:@"trendback"]];
    [fundInfoScrollView addSubview:earningsImageView];

    // 万份收益标签
    UILabel *eLabel = [[UILabel alloc] init];
    eLabel.frame = CGRectMake( 0, 0, 110, 40);
    eLabel.textAlignment = NSTextAlignmentCenter;
    eLabel.backgroundColor = [UIColor clearColor];
    eLabel.font = [UIFont systemFontOfSize:16];
    eLabel.text = @"万份收益(元):";
    eLabel.textColor = [UIColor blackColor];
    [earningsImageView addSubview:eLabel];
    
    _earningsLabel = [[UILabel alloc] init];
    _earningsLabel.frame = CGRectMake( 110, 0, 60, 40);
    _earningsLabel.textAlignment = NSTextAlignmentCenter;
    _earningsLabel.backgroundColor = [UIColor clearColor];
    _earningsLabel.font = [UIFont systemFontOfSize:16];
    _earningsLabel.text = [NSString stringWithFormat:@"%@",_earningsStr];
    _earningsLabel.textColor = UIColorFromRGB(0xf96231);
    [earningsImageView addSubview:_earningsLabel];
    
    // 万份收益趋势图
    earningsSimpleLineGraphView = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 40, 300, 130)];
    earningsSimpleLineGraphView.tag = 101;
    earningsSimpleLineGraphView.delegate = self;
    earningsSimpleLineGraphView.enableTouchReport = YES;
    earningsSimpleLineGraphView.colorTop = [UIColor whiteColor];
    earningsSimpleLineGraphView.colorBottom = [UIColor whiteColor];
    earningsSimpleLineGraphView.backgroundColor = [UIColor whiteColor];
    earningsSimpleLineGraphView.tintColor = [UIColor blueColor];
    earningsSimpleLineGraphView.widthLine = 3.0;
    earningsSimpleLineGraphView.colorXaxisLabel = [UIColor blackColor];
    earningsSimpleLineGraphView.colorLine = UIColorFromRGB(0xffc955);
    [earningsImageView addSubview:earningsSimpleLineGraphView];
    
// ----------------------------------------------------------------
}

//在摇一摇的回调方法弹出分享面板
-(UMSocialShakeConfig)didShakeWithShakeConfig
{
    [self uMengShare];
    return UMSocialShakeConfigShowScreenShot;
}

- (void)shareBtnClick:(UIBarButtonItem *)sender
{
    [self uMengShare];
}

- (void)uMengShare
{
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialData defaultData].extConfig.title = @"点击跳转至App Store 下载理财宝";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"https://itunes.apple.com/us/app/li-cai-bao-hu-lian-wang-li/id867471431?ls=1&mt=8";
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APP_KEY
                                      shareText:[NSString stringWithFormat:@"#理财宝·收益趋势#%@ 近9日收益趋势",_fundName]
                                     shareImage:[[UMSocialScreenShoterDefault screenShoter] getScreenShot]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToTencent]
                                       delegate:self];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

#pragma mark - SimpleLineGraph Data Source

- (int)numberOfPointsInGraphWithTag:(int)tag
{
    if (tag == 100)
        return _netArray.count;
    else
        return _unitnetArray.count;
}

- (float)valueForIndex:(NSInteger)index WithTag:(int)tag
{
    if (tag == 100)
        return [[_netArray objectAtIndex:index] floatValue];
    else
        return [[_unitnetArray objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (int)numberOfGapsBetweenLabelsWithTag:(int)tag
{
    return 1;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index WithTag:(int)tag
{
    if (tag == 100)
        return [_netArray objectAtIndex:index];
    else
        return [_unitnetArray objectAtIndex:index];
}

- (void)didTouchGraphWithClosestIndex:(int)index WithTag:(int)tag
{
    if (tag == 100)
        _sevenDayLabel.text = [NSString stringWithFormat:@"%@",[_netArray objectAtIndex:index]];
    else
        _earningsLabel.text = [NSString stringWithFormat:@"%@",[_unitnetArray objectAtIndex:index]];
}

- (void)didReleaseGraphWithClosestIndex:(float)index WithTag:(int)tag
{
    if (tag == 100)
        _sevenDayLabel.text = [NSString stringWithFormat:@"%@",_sevenDayStr];
    else
        _earningsLabel.text = [NSString stringWithFormat:@"%@",_earningsStr];
}

- (void)backBarItem:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
