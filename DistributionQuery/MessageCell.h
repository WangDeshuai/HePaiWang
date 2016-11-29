//
//  MessageCell.h
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UITextField * textfield;
@property(nonatomic,strong)UIImageView * headImage;
@end
