//
//  LC_FeedbackViewController.m
//  LicaiBao
//
//  Created by mac on 14-3-23.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "LC_FeedbackViewController.h"
#import "UMFeedback.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface LC_FeedbackViewController ()< UMFeedbackDataDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate>

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

- (void)doneBarItemClick
{
    [_numberTextField resignFirstResponder];
    [_feedBackTextView resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneBarItemClick)];
    self.navigationItem.rightBarButtonItem = doneBarItem;
    
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
    
    UIImageView *textFieldBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 185, 301, 45)];
    [textFieldBackImageView setImage:[UIImage imageNamed:@"contact"]];
    textFieldBackImageView.userInteractionEnabled = YES;
    [_feedBackScrollView addSubview:textFieldBackImageView];
    
    _numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 2, 291, 40)];
    _numberTextField.borderStyle = UITextBorderStyleNone;
    _numberTextField.placeholder = @"QQ、邮箱等联系方式（非必填项）";
    _numberTextField.returnKeyType = UIReturnKeyDone;
    _numberTextField.delegate = self;
    [textFieldBackImageView addSubview:_numberTextField];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(10, 240, 301, 45);
    [submitBtn setImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_feedBackScrollView addSubview:submitBtn];
    
    UILabel *feedBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 295, 301, 30)];
    feedBackLabel.font = [UIFont systemFontOfSize:18];
    feedBackLabel.text = @"输入框不够？请把想说的话发到:";
    feedBackLabel.textAlignment = NSTextAlignmentCenter;
    feedBackLabel.textColor = [UIColor orangeColor];
    feedBackLabel.lineBreakMode = NSLineBreakByCharWrapping;
    feedBackLabel.numberOfLines = 0;
    [_feedBackScrollView addSubview:feedBackLabel];
    
    UIButton *emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emailBtn.frame = CGRectMake(10, 325, 301, 20);
    emailBtn.backgroundColor = [UIColor clearColor];
    [emailBtn setTitleColor:UIColorFromRGB(0x3b95d3) forState:UIControlStateNormal];
    [emailBtn setTitle:@"blocksstudio2014@gmail.com" forState:UIControlStateNormal];
    [emailBtn addTarget:self action:@selector(emailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_feedBackScrollView addSubview:emailBtn];
    
    // 系统通知（键盘出现消失）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
    
    _umFeedback = [UMFeedback sharedInstance];
    [_umFeedback setAppkey:UMENG_APP_KEY delegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)emailBtnClick
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayMailViewController];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请设置邮箱或直接反馈到blocksstudio2014@gmail.com" duration:3];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请设置邮箱或直接反馈到blocksstudio2014@gmail.com" duration:3];
    }
}

- (void)displayMailViewController
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:@"意见反馈"];
    [mc setToRecipients:[NSArray arrayWithObjects:@"blocksstudio2014@gmail.com", nil]];
    [self presentModalViewController:mc animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSLog(@"error - %@",error);
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"cancel");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"save");
            break;
        case MFMailComposeResultSent:
        {
            [SVProgressHUD showSuccessWithStatus:@"反馈已发送"];
            NSLog(@"sent");
        }
            break;
        case MFMailComposeResultFailed:
            NSLog(@"failed");
            break;
        default:
            break;
    }
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)submitBtnClick:(UIButton *)sender
{
    NSLog(@"提交反馈");
    [_feedBackTextView resignFirstResponder];
    [_numberTextField resignFirstResponder];
    
    if (_feedBackTextView.text) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:_feedBackTextView.text forKey:@"content"];
        NSDictionary *contact = [NSDictionary dictionaryWithObject:_numberTextField.text forKey:@"contact"];
        [dictionary setObject:contact forKey:@"contact"];
        [_umFeedback post:dictionary];
        [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeClear];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请填写评论内容"];
    }
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
        _feedBackTextView.text = @"";
        _numberTextField.text = @"";
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
