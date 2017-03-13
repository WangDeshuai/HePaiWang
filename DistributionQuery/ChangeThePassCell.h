//
//  ChangeThePassCell.h
//  DistributionQuery
//
//  Created by Macx on 17/3/13.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeThePassCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID;
@property(nonatomic,strong)UIButton * leftImage;
@property(nonatomic,strong)UITextField * textfield;
@property(nonatomic,strong)UIButton * codeBtn;
@end
