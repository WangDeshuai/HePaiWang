//
//  BaoZhengJinAlert.h
//  DistributionQuery
//
//  Created by Macx on 17/7/3.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaoZhengJinAlert : UIView
- (id)initWithTitle:(NSString*)title  contentName:(NSDictionary*)contentDic achiveBtn:(NSString*)btnName ;

@property(nonatomic,strong)void(^buttonBlock)(UIButton*btn);
-(void)show;
-(void)dissmiss;
@end
