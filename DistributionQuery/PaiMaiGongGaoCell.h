//
//  PaiMaiGongGaoCell.h
//  DistributionQuery
//
//  Created by Macx on 16/11/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaiMaiGongGaoModel.h"
@interface PaiMaiGongGaoCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID;
@property(nonatomic,strong)UIButton * lijiBaoMiang;
@property(nonatomic,strong)PaiMaiGongGaoModel * model;
@end
