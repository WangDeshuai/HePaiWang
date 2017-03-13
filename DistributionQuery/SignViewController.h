//
//  SignViewController.h
//  SignTest
//
//  Created by  on 16/8/23.
//  Copyright © 2016年 shixiaodan. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理传值
@protocol ImageDalegate <NSObject>
@optional
//代理方法
- (void)showImage:(UIImage *)image;

@end

@interface SignViewController : UIViewController
//设置代理  弱引用
@property (nonatomic,assign) id <ImageDalegate> delegate;
@end
