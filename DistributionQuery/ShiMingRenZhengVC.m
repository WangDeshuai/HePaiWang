//
//  ShiMingRenZhengVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/30.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ShiMingRenZhengVC.h"

@interface ShiMingRenZhengVC ()
@property(nonatomic,strong)UIButton * lastBtn;
@end

@implementation ShiMingRenZhengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CreatTopBtn];
}
#pragma mark --创建顶部按钮
-(void)CreatTopBtn{
    NSArray * nameAr =@[@"个人",@"企业"];
    
    
    int d =ScreenWidth/nameAr.count;
    for (int i=0; i<nameAr.count; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitle:nameAr[i] forState:0];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.titleLabel.alpha=.7;
        [btn addTarget:self action:@selector(btnnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font=[UIFont systemFontOfSize:16];
        if (i==0) {
            btn.selected=YES;
            _lastBtn=btn;
        }
        [self.view sd_addSubviews:@[btn]];
        btn.sd_layout
        .leftSpaceToView(self.view,(d+1)*i)
        .topSpaceToView(self.view,0)
        .widthIs(d)
        .heightIs(40);
    }
}
-(void)btnnClick:(UIButton*)button{
    _lastBtn.selected=NO;
    button.selected=!button.selected;
    _lastBtn=button;
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
