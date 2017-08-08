//
//  YuGaoXiangQingCell.h
//  DistributionQuery
//
//  Created by Macx on 17/7/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWeiXinPhotoContainerView.h"

@interface YuGaoXiangQingCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView IndexPath:(NSIndexPath *)indexPath;
@property(nonatomic,strong)UILabel * leftLabel;
@property(nonatomic,strong)UITextField * textview;
@property(nonatomic,strong)UIScrollView * bgScrollview;
@property(nonatomic,strong) SDWeiXinPhotoContainerView *picContainerView;
@property(nonatomic,strong)NSArray * imageArr;
@property(nonatomic,strong)UIButton * deleteBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,assign) id deleteTe;
@property(nonatomic,strong)void(^photoArrImageBlock)(NSMutableArray*arr);
@end
