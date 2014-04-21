//
//  LC_HomeCell.h
//  LicaiBao
//
//  Created by mac on 14-2-7.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LC_HomeCell : UITableViewCell
{
    UILabel *_fundNameLabel;
    UILabel *_companyLabel;
    UILabel *_sevenDay;
    UILabel *_wanFen;
}

@property (nonatomic, strong) UILabel *fundNameLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *sevenDay;
@property (nonatomic, strong) UILabel *wanFen;

@end
