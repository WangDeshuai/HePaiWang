//
//  MyBiaoDiWeiTuoViC.m
//  DistributionQuery
//
//  Created by Macx on 17/3/4.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "MyBiaoDiWeiTuoViC.h"
#import "MyWeiTuoTableViewCell.h"
@interface MyBiaoDiWeiTuoViC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIButton * lastBtn;
@end

@implementation MyBiaoDiWeiTuoViC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self CreatTableView];
    NSLog(@"输出tagg=%lu",_tagg);
}
#pragma mark --创建表格
-(void)CreatTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight-45) style:UITableViewStylePlain];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=BG_COLOR;
    _tableView.tableFooterView=[UIView new];
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
