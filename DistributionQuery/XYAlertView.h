//
//  XYAlertView.h
//  DistributionQuery
//
//  Created by Macx on 17/3/10.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYAlertView : UIView

- (id)initWithTitle:(NSString*)title alerMessage:(NSString*)message canCleBtn:(NSString*)btnName1 otheBtn:(NSString*)btnName2;

-(void)show;
-(void)dissmiss;
@end
