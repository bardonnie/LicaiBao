//
//  LC_TipsScrollView.m
//  LicaiBao
//
//  Created by mac on 14-4-23.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "LC_TipsScrollView.h"

@implementation LC_TipsScrollView

- (id)initWithFrame:(CGRect)frame AndTips:(NSArray *)tips
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height*tips.count);
        self.showsVerticalScrollIndicator = NO;
        [self drawTipsLabel:tips];
        [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)drawTipsLabel:(NSArray *)tips
{
    int i = 0;
    for (NSString *tip in tips)
    {
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*i, self.frame.size.width, self.frame.size.height)];
        tipLabel.text = [NSString stringWithFormat:@"Tips:%@",tip];
        tipLabel.textAlignment = UITextAlignmentCenter;
        tipLabel.font = [UIFont boldSystemFontOfSize:12];
        tipLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        tipLabel.numberOfLines = 0;
        tipLabel.textColor = [UIColor orangeColor];
        [self addSubview:tipLabel];
        i++;
    }
}

- (void)autoScroll
{
    if (self.contentOffset.y == self.contentSize.height-self.frame.size.height)
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    else
        [self setContentOffset:CGPointMake(0, self.contentOffset.y+self.frame.size.height) animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
