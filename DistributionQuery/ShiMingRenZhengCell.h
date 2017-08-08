//
//  ShiMingRenZhengCell.h
//  DistributionQuery
//
//  Created by Macx on 17/6/2.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShiMingRenZhengCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView IndexPath:(NSIndexPath *)indexPath;
@property(nonatomic,strong)UILabel * namelabel;
@property(nonatomic,strong)UITextField * textfield;
@property(nonatomic,strong)UIScrollView * bgScrollView;
@end
