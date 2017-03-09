//
//  WeiTuoPaiMaiCell.h
//  DistributionQuery
//
//  Created by Macx on 16/11/23.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiTuoPaiMaiCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID;
@property(nonatomic,strong)UIButton * codeBtn;
@property(nonatomic,strong)UITextField * textfield;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UIScrollView * bgScrollview;
@end
