//
//  LiuYanZhuanQuCell.h
//  DistributionQuery
//
//  Created by Macx on 17/4/5.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZaiXianModel.h"
@interface LiuYanZhuanQuCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID;
@property(nonatomic,strong)ZaiXianModel * model;
@end
