//
//  LC_FeedbackViewController.m
//  LicaiBao
//
//  Created by mac on 14-3-23.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "LC_FeedbackViewController.h"
#import "UMFeedback.h"

@interface LC_FeedbackViewController ()< UMFeedbackDataDelegate>

@end

@implementation LC_FeedbackViewController
{
    GCPlaceholderTextView *_feedBackTextView;
    UITextField *_numberTextField;
    UIScrollView *_feedBackScrollView;
    UMFeedback *_umFeedback;
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
    [setTitleImageView setImage:[UIImage imageNamed:@"title_feedback"]];
    [self.navigationItem setTitleView:setTitleImageView];
    
    _feedBackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WINDOW_WIDTH, NAV_VIEW_HEIGHT)];
    _feedBackScrollView.backgroundColor = [UIColor clearColor];
    _feedBackScrollView.contentSize = CGSizeMake(MAIN_WINDOW_WIDTH, 340);
    [self.view addSubview:_feedBackScrollView];
    
    _feedBackTextView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, 301, 165)];
    _feedBackTextView.placeholder = @"请输入您的宝贵意见";
    _feedBackTextView.font = [UIFont systemFontOfSize:18];
    _feedBackTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"big-frame"]];
    [_feedBackScrollView addSubview:_feedBackTextView];
    
    UILabel *feedBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, 301, 50)];
    feedBackLabel.font = [UIFont systemFontOfSize:18];
    feedBackLabel.text = @"输入框不够？请把想说的话发到:blocksstudio2014@gmail.com";
    feedBackLabel.textAlignment = NSTextAlignmentCenter;
    feedBackLabel.textColor = [UIColor orangeColor];
    feedBackLabel.lineBreakMode = NSLineBreakByCharWrapping;
    feedBackLabel.numberOfLines = 0;
    [_feedBackScrollView addSubview:feedBackLabel];
    
    UIImageView *textFieldBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 225, 301, 45)];
    [textFieldBackImageView setImage:[UIImage imageNamed:@"contact"]];
    textFieldBackImageView.userInteractionEnabled = YES;
    [_feedBackScrollView addSubview:textFieldBackImageView];
    
    _numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 2, 291, 40)];
    _numberTextField.borderStyle = UITextBorderStyleNone;
    _numberTextField.placeholder = @"请输入您的QQ、邮箱或者手机号";
    [textFieldBackImageView addSubview:_numberTextField];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(10, 280, 301, 45);
    [submitBtn setImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_feedBackScrollView addSubview:submitBtn];
 
    // 系统通知（键盘出现消失）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
    
    _umFeedback = [UMFeedback sharedInstance];
    [_umFeedback setAppkey:UMENG_APP_KEY delegate:self];
}

- (void)submitBtnClick:(UIButton *)sender
{
    NSLog(@"提交反馈");
    [_feedBackTextView resignFirstResponder];
    [_numberTextField resignFirstResponder];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:_feedBackTextView.text forKey:@"content"];
    NSDictionary *contact = [NSDictionary dictionaryWithObject:_numberTextField.text forKey:@"contact"];
    [dictionary setObject:contact forKey:@"contact"];
    [_umFeedback post:dictionary];
    [SVProgressHUD showWithStatus:@"提交成功" maskType:SVProgressHUDMaskTypeClear];
}

- (void)postFinishedWithError:(NSError *)error
{
    NSLog(@"error - %@",error);
    if (error)
    {
        [SVProgressHUD showErrorWithStatus:@"提交失败" duration:2];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"提交成功" duration:2];
    }
}

- (void)keyboardWillShow:(NSNotification *)sender
{
    // 获取系统键盘高
    NSDictionary *dict = [sender userInfo];
    NSValue *value = [dict objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    
    _feedBackScrollView.frame = CGRectMake(0, 0, MAIN_WINDOW_WIDTH, NAV_VIEW_HEIGHT-keyboardSize.height);
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    _feedBackScrollView.frame = CGRectMake(0, 0, MAIN_WINDOW_WIDTH, NAV_VIEW_HEIGHT);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _umFeedback.delegate = nil;
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
