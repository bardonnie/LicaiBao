//
//  LC_FundInfoViewController.h
//  LicaiBao
//
//  Created by mac on 14-2-11.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"


@interface LC_FundInfoViewController : UIViewController< BEMSimpleLineGraphDelegate>

@property (nonatomic, strong) BEMSimpleLineGraphView *sevenDaySimpleLineGraphView;
@property (nonatomic, strong) BEMSimpleLineGraphView *earningsSimpleLineGraphView;

- (id)initWithFundName:(NSString *)fundName FundCount:(int)fundCount AndFundRank:(int)fundRank;

@end
