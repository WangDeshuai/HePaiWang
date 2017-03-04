//
//  CenterableViewCell.h
//  DistributionQuery
//
//  Created by Macx on 17/3/3.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView;
@property(nonatomic,copy)NSString * name;
@end
