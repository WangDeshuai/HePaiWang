//
//  ShiMingRenZhengVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/30.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ShiMingRenZhengVC.h"
#import "MySelfViC.h"
#import "CompanyVC.h"
#import "SGTopTitleView.h"
@interface ShiMingRenZhengVC ()<UIScrollViewDelegate,SGTopTitleViewDelegate>
@property (nonatomic, strong) SGTopTitleView *topTitleView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic,copy)NSString * index;
@end

@implementation ShiMingRenZhengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"实名认证";
//    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setupChildViewController];
    self.titles = @[@"个人",@"企业"];
    self.topTitleView = [SGTopTitleView topTitleViewWithFrame:CGRectMake(0, 0,ScreenWidth, 44)];
    _topTitleView.staticTitleArr = [NSArray arrayWithArray:_titles];
    _topTitleView.backgroundColor=[UIColor whiteColor];
    _topTitleView.delegate_SG = self;
    [self.view addSubview:_topTitleView];
    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * _titles.count, 0);
    _mainScrollView.backgroundColor = [UIColor clearColor];
    // 开启分页
    _mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    _mainScrollView.delegate = self;
    
    [self.view addSubview:_mainScrollView];
    
    
    
    MySelfViC *oneVC = [[MySelfViC alloc] init];
    [self.mainScrollView addSubview:oneVC.view];
    [self addChildViewController:oneVC];
    [self.view insertSubview:_mainScrollView belowSubview:_topTitleView];
   

}


#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index{
    
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    NSLog(@"哈哈哈%f",offsetX);
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
}
// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}

// 添加所有子控制器
- (void)setupChildViewController {
    //
    MySelfViC *oneVC = [[MySelfViC alloc] init];
    [self addChildViewController:oneVC];
    
    //
    CompanyVC *twoVC = [[CompanyVC alloc] init];
    [self addChildViewController:twoVC];
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self showVc:index];
   
    // 2.把对应的标题选中
   
    UILabel *selLabel = self.topTitleView.allTitleLabel[index];
    
    // 3.滚动时，改变标题选中
    [self.topTitleView staticTitleLabelSelecteded:selLabel];
    
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
