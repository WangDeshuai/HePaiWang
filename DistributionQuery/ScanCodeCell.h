//
//  ScanCodeCell.h
//  DistributionQuery
//
//  Created by Macx on 17/3/10.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanCodeCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView CellID:(NSString*)cellID;
@property(nonatomic,strong)UILabel * leftLabel;
@property(nonatomic,strong)UITextField * textview;
@property(nonatomic,strong)UIScrollView * bgScrollview;
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,assign) id deleteTe;
@property(nonatomic,strong)void(^photoArrImageBlock)(NSMutableArray*arr);
@end
