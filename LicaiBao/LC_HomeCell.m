//
//  LC_HomeCell.m
//  LicaiBao
//
//  Created by mac on 14-2-7.
//  Copyright (c) 2014年 trends-china. All rights reserved.
//

#import "LC_HomeCell.h"

@implementation LC_HomeCell

@synthesize fundNameLabel = _fundNameLabel;
@synthesize companyLabel = _companyLabel;
@synthesize sevenDay = _sevenDay;
@synthesize wanFen = _wanFen;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *cellBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 300, 40)];
        [cellBackImageView setImage:[UIImage imageNamed:@"background"]];
        [self.contentView addSubview:cellBackImageView];
        
        _fundNameLabel = [[UILabel alloc] init];
        _fundNameLabel.frame = CGRectMake(7, 6, 90, 16);
        _fundNameLabel.backgroundColor = [UIColor clearColor];
        _fundNameLabel.font = [UIFont boldSystemFontOfSize:14];
        _fundNameLabel.textColor = UIColorFromRGB(0x3b95d3);
        [cellBackImageView addSubview:_fundNameLabel];
        
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.frame = CGRectMake(7, 24, 89, 12);
        _companyLabel.backgroundColor = [UIColor clearColor];
        _companyLabel.font = [UIFont boldSystemFontOfSize:10];
        _companyLabel.textColor = UIColorFromRGB(0x91969c);
        [cellBackImageView addSubview:_companyLabel];
        
        _sevenDay = [[UILabel alloc] init];
        _sevenDay.frame = CGRectMake(100, 10, 60, 20);
        _sevenDay.backgroundColor = [UIColor clearColor];
        _sevenDay.font = [UIFont boldSystemFontOfSize:16];
        _sevenDay.textColor = UIColorFromRGB(0x91969c);
        _sevenDay.textAlignment = NSTextAlignmentCenter;
        [cellBackImageView addSubview:_sevenDay];
        
        _wanFen = [[UILabel alloc] init];
        _wanFen.frame = CGRectMake(180, 10, 60, 20);
        _wanFen.backgroundColor = [UIColor clearColor];
        _wanFen.font = [UIFont boldSystemFontOfSize:16];
        _wanFen.textColor = UIColorFromRGB(0x91969c);
        _wanFen.textAlignment = NSTextAlignmentCenter;
        [cellBackImageView addSubview:_wanFen];
        
        UIImageView *infoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 20, 20)];
        [infoImageView setImage:[UIImage imageNamed:@"trend"]];
        [cellBackImageView addSubview:infoImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
