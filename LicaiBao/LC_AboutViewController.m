//
//  LC_AboutViewController.m
//  LicaiBao
//
//  Created by mac on 14-3-23.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "LC_AboutViewController.h"


@interface LC_AboutViewController ()< UITableViewDataSource, UITableViewDelegate>

@end

@implementation LC_AboutViewController
{
    NSArray *_nameArray;
    NSArray *_synopsisArray;
    NSArray *_headerImage;
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
    _synopsisArray = [[NSArray alloc] initWithObjects:@"三流PM 非典型精神分裂者",@"iOSCoder 科技达人", nil];
    _headerImage = [[NSArray alloc] initWithObjects:@"",@"", nil];
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
    headerImageView.backgroundColor = [UIColor redColor];
    [cellBackImageView addSubview:headerImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 190, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [_nameArray objectAtIndex:indexPath.row];
    nameLabel.textColor = [UIColor orangeColor];
    nameLabel.font = [UIFont systemFontOfSize:20];
    [cellBackImageView addSubview:nameLabel];
    
    UILabel *synopsisLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 190, 24)];
    synopsisLabel.backgroundColor = [UIColor clearColor];
    synopsisLabel.text = [_synopsisArray objectAtIndex:indexPath.row];
    synopsisLabel.font = [UIFont systemFontOfSize:15];
    [cellBackImageView addSubview:synopsisLabel];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(254, 9, 46, 46);
    [addBtn setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = indexPath.row;
    [cellBackImageView addSubview:addBtn];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)addBtnClick:(UIButton *)sender
{
    NSLog(@"加关注");
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
