//
//  SignView.h
//  DistributionQuery
//
//  Created by Macx on 17/4/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理传值
@protocol ImageDalegate1 <NSObject>
@optional
//代理方法
- (void)showImage:(UIImage *)image;
-(void)buttonClinkTwo:(UIButton*)btn Image:(UIImage*)image;
@end



@interface SignView : UIView
//设置代理  弱引用
@property (nonatomic,assign) id <ImageDalegate1> delegate;

@end
