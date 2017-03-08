//
//  PaiMaiBiaoDiCell.h
//  DistributionQuery
//
//  Created by Macx on 16/11/22.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChengJiaoAnLiModel.h"
#import "PaiMaiBiaoDiModel.h"
@interface PaiMaiBiaoDiCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID;


//成交案例来用的
@property(nonatomic,strong)ChengJiaoAnLiModel * model;
//拍卖标的用的
@property(nonatomic,strong)PaiMaiBiaoDiModel * twoModel;
@end
