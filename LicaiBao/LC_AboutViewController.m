//
//  LC_AboutViewController.m
//  LicaiBao
//
//  Created by mac on 14-3-23.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#define degreesToRadinas(x) (M_PI * (x)/180.0)

#import "LC_AboutViewController.h"


@interface LC_AboutViewController ()< UITableViewDataSource, UITableViewDelegate, NetworKDelegate, UIAlertViewDelegate>

@end

@implementation LC_AboutViewController
{
    NSArray *_nameArray;
    NSArray *_synopsisArray;
    NSArray *_headerImage;
    NSString *_nameStr;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *setTitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 17)];
    [setTitleImageView setImage:[UIImage imageNamed:@"title_about"]];
    [self.navigationItem setTitleView:setTitleImageView];
    
    UITableView *aboutTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, NAV_VIEW_HEIGHT) style:UITableViewStylePlain];
    [aboutTableView addTwitterCoverWithImage:[UIImage imageNamed:@"banner"]];
    aboutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    aboutTableView.delegate = self;
    aboutTableView.dataSource = self;
    [self.view addSubview:aboutTableView];
    
    _nameArray = [[NSArray alloc] initWithObjects:@"小王金王小",@"Droid_adj", nil];
    _synopsisArray = [[NSArray alloc] initWithObjects:@"三流PM 非典型精神分裂者",@"iOSCoder 坚持梦想的傻x", nil];
    _headerImage = [[NSArray alloc] initWithObjects:@"wx",@"cx", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, CHTwitterCoverViewHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CHTwitterCoverViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    UIImageView *cellBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 64)];
    [cellBackImageView setImage:[UIImage imageNamed:@"weibo-background"]];
    cellBackImageView.userInteractionEnabled = YES;
    [cell.contentView addSubview:cellBackImageView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 54, 54)];
    headerImageView.backgroundColor = [UIColor clearColor];
    [headerImageView setImage:[UIImage imageNamed:[_headerImage objectAtIndex:indexPath.row]]];
    [cellBackImageView addSubview:headerImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 100, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [_nameArray objectAtIndex:indexPath.row];
    nameLabel.textColor = [UIColor orangeColor];
    nameLabel.font = [UIFont systemFontOfSize:20];
    [cellBackImageView addSubview:nameLabel];
    
    UIImageView *sinaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 12, 21, 17)];
    [sinaImageView setImage:[UIImage imageNamed:@"sina"]];
    [cellBackImageView addSubview:sinaImageView];
    
    UILabel *synopsisLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 190, 24)];
    synopsisLabel.backgroundColor = [UIColor clearColor];
    synopsisLabel.text = [_synopsisArray objectAtIndex:indexPath.row];
    synopsisLabel.font = [UIFont systemFontOfSize:15];
    [cellBackImageView addSubview:synopsisLabel];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(254, 9, 46, 46);
    [addBtn setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = indexPath.row+10;
    if (indexPath.row == 0) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_care_w"]) {
            [addBtn setTransform:CGAffineTransformMakeRotation( M_PI/4 )];
        }
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_care_c"]) {
            [addBtn setTransform:CGAffineTransformMakeRotation( M_PI/4 )];
        }
    }
    

    [cellBackImageView addSubview:addBtn];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)addBtnClick:(UIButton *)sender
{
    NSString *messageStr;
    NSString *followBtnTitle;
    if (sender.tag == 10) {
        _nameStr = @"小王金王小";
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_care_w"]) {
            messageStr = [NSString stringWithFormat:@"您要取消关注 @%@ 的新浪微博吗？",_nameStr];
            followBtnTitle = @"取消关注";
        }
        else
        {
            messageStr = [NSString stringWithFormat:@"您要关注 @%@ 的新浪微博吗？",_nameStr];
            followBtnTitle = @"关注";
        }
    }
    if (sender.tag == 11) {
        _nameStr = @"Droid_adj";
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_care_c"]) {
            messageStr = [NSString stringWithFormat:@"您要取消关注 @%@ 的新浪微博吗？",_nameStr];
            followBtnTitle = @"取消关注";
        }
        else
        {
            messageStr = [NSString stringWithFormat:@"您要关注 @%@ 的新浪微博吗？",_nameStr];
            followBtnTitle = @"关注";
        }
    }
    
    UIAlertView *askAlertView = [[UIAlertView alloc] initWithTitle:nil message:messageStr delegate:self cancelButtonTitle:@"不" otherButtonTitles:followBtnTitle, nil];
    [askAlertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [SVProgressHUD showWithStatus:@"关注中"];
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
        
        if (!snsAccount.accessToken)
        {
            [SVProgressHUD dismiss];
            [UMSocialAccountManager isOauthWithPlatform:UMShareToSina];
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    [self sinaAccess:snsAccount.accessToken];
                }
            });
        }
        else
        {
            [self sinaAccess:snsAccount.accessToken];
        }
    }
}

- (void)sinaAccess:(NSString *)token
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:@"access_token"];
    [dic setObject:_nameStr forKey:@"screen_name"];
    
    if ([_nameStr isEqual:@"小王金王小"]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_care_w"])
            [[LC_Network shareNetwork] sina:dic url:@"https://api.weibo.com/2/friendships/destroy.json"];
        else
            [[LC_Network shareNetwork] sina:dic url:@"https://api.weibo.com/2/friendships/create.json"];
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_care_c"])
            [[LC_Network shareNetwork] sina:dic url:@"https://api.weibo.com/2/friendships/destroy.json"];
        else
            [[LC_Network shareNetwork] sina:dic url:@"https://api.weibo.com/2/friendships/create.json"];
    }
    
    
    [LC_Network shareNetwork].delegate = self;
}

- (void)downloadFinishWith:(NSDictionary *)json
{
    
    if ([[json objectForKey:@"screen_name"] isEqual:@"小王金王小"]) {
        UIView *view = [self.view viewWithTag:10];

        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_care_w"]) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_care_w"];
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            [UIView animateWithDuration:1 animations:^{
                [view setTransform:CGAffineTransformMakeRotation( M_PI/2 )];
            }];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_care_w"];
            [UIView animateWithDuration:1 animations:^{
                [view setTransform:CGAffineTransformMakeRotation( M_PI/4 )];
            }];
        }
    }
    if ([[json objectForKey:@"screen_name"] isEqual:@"Droid_adj"])
    {
        UIView *view = [self.view viewWithTag:11];

        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"is_care_c"]) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_care_c"];
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            [UIView animateWithDuration:1 animations:^{
                [view setTransform:CGAffineTransformMakeRotation( M_PI/2 )];
            }];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_care_c"];
            [UIView animateWithDuration:1 animations:^{
                [view setTransform:CGAffineTransformMakeRotation( M_PI/4 )];
            }];
        }
    }
}

- (void)downloadFail:(NSError *)error
{
    NSLog(@"Error");
    [SVProgressHUD showErrorWithStatus:@"关注失败"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
