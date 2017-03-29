//
//  ZaiXianJingJiaCell.h
//  DistributionQuery
//
//  Created by Macx on 16/11/24.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZaiXianJingJiaCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID;
@property (nonatomic,strong)UILabel * leftLabel;
@property(nonatomic,strong)UILabel * centerLabel;
@property(nonatomic,strong)UILabel * rightLabel;
@end
