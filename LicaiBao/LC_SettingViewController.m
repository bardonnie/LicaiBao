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
    
    _cellTitleArray = [[NSArray alloc] initWithObjects:@"收益提醒",@"检查更新",@"意见反馈",@"捐助开发者",@"关于理财宝", nil];
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
        [remindSwithBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [remindSwithBtn addTarget:self action:@selector(remindSwithBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cellBackImageView addSubview:remindSwithBtn];
    }
    else if (indexPath.row == 1)
    {
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 7, 70, 30)];
        versionLabel.text = [NSString stringWithFormat:@"V %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
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
            NSLog(@"检测更新");
        }
            break;
        case 2:
        {
            LC_FeedbackViewController *feedbackViewController = [[LC_FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackViewController animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"捐助");
        }
            break;
        case 4:
        {
            
            [self.navigationController pushViewController:_delegate.aboutViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)remindSwithBtnClick:(UIButton *)sender
{
    NSLog(@"推送");
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
