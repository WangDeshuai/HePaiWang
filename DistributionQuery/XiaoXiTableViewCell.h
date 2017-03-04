//
//  XiaoXiTableViewCell.h
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiaoXiModel.h"
@interface XiaoXiTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID;
@property(nonatomic,strong)XiaoXiModel * model;
@end
