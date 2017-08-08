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
@property(nonatomic,strong)UILabel * paimaiLabel;//拍卖地区
@property(nonatomic,strong)UILabel * qipaiLabel;//起拍价
//成交案例来用的
@property(nonatomic,strong)ChengJiaoAnLiModel * model;
@property(nonatomic,strong)UIImageView * chengJiaoImage;//成交
//拍卖标的用的
@property(nonatomic,strong)PaiMaiBiaoDiModel * twoModel;
@end
