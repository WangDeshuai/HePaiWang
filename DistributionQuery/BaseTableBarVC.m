//
//  BaseTableBarVC.m
//  DistributionQuery
//
//  Created by Macx on 16/10/8.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BaseTableBarVC.h"
#import "BaseNavigationController.h"
#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"
#define Global_tintColor [UIColor colorWithRed:221/255.0 green:(39 / 255.0) blue:(39 / 255.0) alpha:1]
@interface BaseTableBarVC ()

@end

@implementation BaseTableBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"HomeVC",
                                   kTitleKey  : @"首页",
                                   kImgKey    : @"home_noclick",
                                   kSelImgKey : @"home_click"},
                                 
                                 @{kClassKey  : @"ScanCodeVC",
                                   kTitleKey  : @"发布预告",
                                   kImgKey    : @"home_fabu",
                                   kSelImgKey : @"home_fabuclick"},
                                 
                                 @{kClassKey  : @"WeiTuoPaiMaiVC",
                                   kTitleKey  : @"委托拍卖",
                                   kImgKey    : @"home_paimai",
                                   kSelImgKey : @"home_paimaiclick"},
                                 
                                 @{kClassKey  : @"MyVC",
                                   kTitleKey  : @"我的",
                                   kImgKey    : @"home_my",
                                   kSelImgKey : @"home_myclick"},
                                 
                                 ];
    
    

    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : Global_tintColor} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
