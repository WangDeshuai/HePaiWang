//
//  BuyDaoViewController.m
//  DistributionQuery
//
//  Created by Macx on 16/11/29.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BuyDaoViewController.h"
#import "MyWeiTuoTableViewCell.h"
#import "BuyXiangQingVC.h"
@interface BuyDaoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIButton * lastBtn;
@end

@implementation BuyDaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title=@"已买到的标的";
    [self CreatTopBtn];
    [self CreatTableView];
}
#pragma mark --创建顶部按钮
-(void)CreatTopBtn{
    NSArray * nameAr =@[@"全部",@"已交割",@"未交割"];
    
    
    int d =(ScreenWidth-120*nameAr.count)/(nameAr.count+1);
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
        .leftSpaceToView(self.view,d+(d+120)*i)
        .topSpaceToView(self.view,0)
        .widthIs(120)
        .heightIs(40);
    }
}
-(void)btnnClick:(UIButton*)button{
    _lastBtn.selected=NO;
    button.selected=!button.selected;
    _lastBtn=button;
}
#pragma mark --创建表格
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight-45-64) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=BG_COLOR;
    [self.view addSubview:_tableView];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    
    MyWeiTuoTableViewCell * cell =[MyWeiTuoTableViewCell cellWithTableView:tableView CellID:CellIdentifier];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyXiangQingVC * vc =[BuyXiangQingVC new];
    [self.navigationController pushViewController:vc animated:YES];
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
