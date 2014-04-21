//
//  LC_InfoViewController.m
//  LicaiBao
//
//  Created by mac on 14-2-11.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "LC_InfoViewController.h"


@interface LC_InfoViewController ()

@end

@implementation LC_InfoViewController

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
    self.navigationItem.title = @"关于";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnClick:)];
    self.navigationItem.rightBarButtonItem = doneBtn;
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
