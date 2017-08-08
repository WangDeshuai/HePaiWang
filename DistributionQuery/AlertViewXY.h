//
//  AlertViewXY.h
//  DistributionQuery
//
//  Created by Macx on 17/6/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewXY : UIView
- (id)initWithTitle:(NSString*)title  contentName:(NSString*)content achiveBtn:(NSString*)btnName ;
-(void)show;
-(void)dissmiss;
@end
