//
//  SignTextViewController.m
//  DistributionQuery
//
//  Created by Macx on 17/3/13.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "SignTextViewController.h"
#import "SignViewController.h"
@interface SignTextViewController ()<ImageDalegate>
@property(nonatomic,strong)UIImageView * imageView;
@end

@implementation SignTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"签名";
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"开始签名" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor redColor];
    button.sd_cornerRadius=@(5);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view sd_addSubviews:@[button]];
    
    button.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view,20)
    .widthIs(120)
    .heightIs(35);
    
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = [[UIColor grayColor]CGColor];
    [self.view addSubview:self.imageView];
}
-(void)buttonClick
{
    SignViewController *vc1=[[SignViewController alloc]init];
    vc1.delegate=self;
    [self.navigationController pushViewController:vc1 animated:YES];
    //[self presentViewController:vc1 animated:YES completion:nil];
}
- (void)showImage:(UIImage *)image
{
    self.imageView.image=image;
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
