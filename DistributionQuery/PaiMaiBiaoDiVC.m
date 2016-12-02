//
//  PaiMaiBiaoDiVC.m
//  DistributionQuery
//
//  Created by Macx on 16/11/21.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PaiMaiBiaoDiVC.h"
#import "PaiMaiBiaoDiCell.h"
#import "PaiMaiBiaoDiXiangQingVC.h"
@interface PaiMaiBiaoDiVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation PaiMaiBiaoDiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.title=@"拍卖标的";
    UIButton * logoBtn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn2.frame=CGRectMake(0, 0, 76/2, 44/2);
    [logoBtn2 setImage:[UIImage imageNamed:@"liebiao_phone"] forState:0];
    UIBarButtonItem *leftBtn2 =[[UIBarButtonItem alloc]initWithCustomView:logoBtn2];
    UIButton * searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(0, -10, 489/2, 65/2);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search-1"] forState:0];//489   65
    [searchBtn setTitle:@"搜索标的物" forState:0];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:0];
    searchBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    searchBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 30, 0, 0);
    searchBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    UIBarButtonItem *leftBtn3 =[[UIBarButtonItem alloc]initWithCustomView:searchBtn];
   self.navigationItem.rightBarButtonItems=@[leftBtn2,leftBtn3];
    [self CreatTableView];
    [self CreatButton];
}

#pragma mark --创建按钮
-(void)CreatButton{
    UIButton * fabu =[UIButton buttonWithType:UIButtonTypeCustom];
    fabu.backgroundColor=[UIColor whiteColor];
    fabu.frame=CGRectMake(0, ScreenHeight-55-64, ScreenWidth, 55);
    [fabu setImage:[UIImage imageNamed:@"liebiaonav_bottom "] forState:0];
    [self.view addSubview:fabu];
   
}


#pragma mark --创建表格
-(void)CreatTableView{
    if (!_tableView) {
     _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-55) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=BG_COLOR;
    _tableView.tableFooterView=[UIView new];
    [self.view sd_addSubviews:@[_tableView]];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];

    PaiMaiBiaoDiCell * cell =[PaiMaiBiaoDiCell cellWithTableView:tableView CellID:CellIdentifier];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PaiMaiBiaoDiXiangQingVC * vc =[PaiMaiBiaoDiXiangQingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
