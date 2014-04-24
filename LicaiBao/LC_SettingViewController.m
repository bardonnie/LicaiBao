//
//  LC_SettingViewController.m
//  LicaiBao
//
//  Created by mac on 14-2-11.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "LC_SettingViewController.h"


@interface LC_SettingViewController ()< UITableViewDataSource, UITableViewDelegate>

@end

@implementation LC_SettingViewController
{
    NSArray *_cellTitleArray;
    LC_AppDelegate *_delegate;
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
    self.title = @"设置";
    UIImageView *setTitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 17)];
    [setTitleImageView setImage:[UIImage imageNamed:@"title_set"]];
    [self.navigationItem setTitleView:setTitleImageView];
    
    if (IOS7_OR_LATER)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.backBarButtonItem = backBarItem;
    
    UITableView *settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, MAIN_WINDOW_HEIGHT) style:UITableViewStylePlain];
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:settingTableView];
    
    _delegate = [UIApplication sharedApplication].delegate;
    
    _cellTitleArray = [[NSArray alloc] initWithObjects:@"收益提醒",@"检查更新",@"意见反馈",@"关于理财宝", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    UIImageView *cellBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 44)];
    [cellBackImageView setImage:[UIImage imageNamed:@"wire-frame"]];
    [cell.contentView addSubview:cellBackImageView];
    
    UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, 120, 34)];
    cellTitleLabel.backgroundColor = [UIColor clearColor];
    cellTitleLabel.text = [_cellTitleArray objectAtIndex:indexPath.row];
    [cellBackImageView addSubview:cellTitleLabel];
    
    if (indexPath.row == 0)
    {
        cellBackImageView.userInteractionEnabled = YES;
        
        UIButton *remindSwithBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        remindSwithBtn.frame = CGRectMake(215, 7, 70, 30);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_push"])
            [remindSwithBtn setImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
        else
            [remindSwithBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [remindSwithBtn addTarget:self action:@selector(remindSwithBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cellBackImageView addSubview:remindSwithBtn];
    }
    else if (indexPath.row == 1)
    {
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 7, 70, 30)];
        versionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        versionLabel.textAlignment = NSTextAlignmentRight;
        [cellBackImageView addSubview:versionLabel];
    }
    else
    {
        UIImageView *detailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275, 15, 8, 14)];
        [detailImageView setImage:[UIImage imageNamed:@"right-go"]];
        [cellBackImageView addSubview:detailImageView];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            [SVProgressHUD showWithStatus:@"请稍等"];
            [MobClick startWithAppkey:UMENG_APP_KEY];
            [MobClick checkUpdateWithDelegate:self selector:@selector(updateApp:)];
        }
            break;
        case 2:
        {
            LC_FeedbackViewController *feedbackViewController = [[LC_FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackViewController animated:YES];
        }
            break;
//        case 3:
//        {
//            NSLog(@"捐助");
//        }
//            break;
        case 3:
        {
            [self.navigationController pushViewController:_delegate.aboutViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)updateApp:(NSDictionary *)dic
{
    NSLog(@"dic - %@",dic);
    if ([[dic objectForKey:@"update"] boolValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"哔～～发现新版本%@",[dic objectForKey:@"version"]] message:[dic objectForKey:@"update_log"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去下载", nil];
        
        [alert show];
    }
    else
    {
        [SVProgressHUD showSmileStatus:@"当前已是最新版本!" duration:2];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/li-cai-bao-hu-lian-wang-li/id867471431?ls=1&mt=8"]];
            break;
        default:
            break;
    }
    
}

- (void)remindSwithBtnClick:(UIButton *)sender
{
    NSLog(@"推送");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_push"])
    {
        [sender setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_push"];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_push"];
    }
}

- (void)doneBtnClick:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
