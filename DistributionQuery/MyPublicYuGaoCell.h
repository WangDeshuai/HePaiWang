//
//  MyPublicYuGaoCell.h
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPublicYuGaoModel.h"
@interface MyPublicYuGaoCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID;
@property(nonatomic,strong)MyPublicYuGaoModel * model;
@property(nonatomic,strong)UIButton * xiangQingBtn;//详情按钮
@property(nonatomic,strong)UIButton * deleteBtn;//删除按钮
@end
